/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of
// this file may not be disclosed to third parties, copied or duplicated in
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: thang van ung tung@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- select*from segments order by segmentname

-- EXEC CMP_spMassExtractionOdm 'Alcon'
-- EXEC CMP_spMassExtractionOdm 'Coder Performance TestSegment 01'
/*
TASK:
    (0) preparation
    (0.1) verify segment name --resolvable to segmentId
    (0.2) get incremental list of request ids per segment

    (1) extracts selected values from codingRequests.XmlContent into persistent table format
    (1.1) process clear, uncompressed text
    (1.2) decompress (gzip) values, then extract.

DEPENDECIES:
    (1) sql-clr function Decompress, which is a gzip algorithm.
        place holder expected is database named CLR

ARGUMENTS:
    (1) division name (coder..Segments.SegmentName), case insensitive.
    (2) time out (time span), where the default 0 (00:00) is no time out.

*/


IF EXISTS(select * from sysobjects where type = 'P' and name = 'CMP_spMassExtractionOdm')
begin
    drop PROCEDURE CMP_spMassExtractionOdm
end

GO
create PROCEDURE dbo.CMP_spMassExtractionOdm( @segmentName sysname, @timespan datetime='00:00' )
as
begin
    declare @T table(id int primary key,
        zipped bit,
        unique(id,zipped)with(ignore_dup_key=on)
        );

    declare @SegmentId INT =(select top(1)SegmentId from Segments where SegmentName =@SegmentName),
            @topCount int=1000000,
            @checkStop datetime =(case datediff(ss,@timespan,0)
                                when 0 then null
                                else dateadd(ss,datediff(ss,0,@timespan),getdate())
                                end),
            @print varchar(128);
    IF @SegmentId is null
    begin
        RAISERROR(N'ERROR: No such Segment!', 16, 1)
        RETURN 0
    end
    else
        print 'Extraction from division: '+cast(@segmentId as varchar)
    print 'START TIME:    '+convert(varchar(50),getdate(),121)
    print 'CHECK STOP:    '+isnull(convert(varchar(50),@checkStop,121),'NO LIMIT')

    declare @mxkey int=(select isnull(max(T.codingRequestId),0)
        from _CodingOdmValues T
            join CodingRequests req (nolock) on req.SegmentId=@segmentId
            and req.CodingRequestId =T.CodingRequestId);

    while(@@rowcount >0)
    begin
        if( getdate() > @checkStop )
        begin
            print 'Time out enforced.'
            return -1;
        end

        insert into @T
        select distinct top(500) req.codingRequestId,
            req.IsXmlCompressed
        from codingRequests req (nolock)
        where req.codingRequestId >@mxkey
          and req.segmentId =@segmentId
          and dataLength(xmlContent) >0
        order by 1
        option(force order);
        if(@@rowcount = 0) return;

        select @mxkey =max(id)from @T;

        set @print ='counter key (uncompressed): '+ cast(@mxkey as varchar);
        RAISERROR(@print,0,1) WITH NOWAIT;    --flush prints

        ;WITH cteX
        AS(
            select top(@topCount)    --top is needed for the "order by" clause,
                                    -- and is large enough to cover previous loop accumulation
                CodingRequestId =T.id, req.SourceSystemId,    -- 1.c finally cast to xml
                Xodom =convert(xml,
                    -- 1. a cast to NVARCHAR cause NTEXT can't be cast to xml
                    -- 1.b simplify the XML into one schema and reduce the meta
                    N'<ODM xmlns:mdsol="~">'+substring(cast(XmlContent as nvarchar(max)), patindex('%<ClinicalData%',XmlContent), DataLength(xmlContent))
                )
            from @T T
              join CodingRequests req (nolock) on req.codingRequestId =T.id
            where T.zipped =0
            order by 1
        )
        insert into _CodingOdmValues
            SELECT
                CodingRequestId

                -- *** Source Properties
                --singletons
                ,StudyOID           =T.n.value('(//*/@StudyOID)[1]','VARCHAR(50)')

                --multiples
                ,SubjectKey         =isnull(T.n.value('(../../../../../@SubjectKey)[1]','NVARCHAR(50)'), '')
                ,SiteOID            =T.n.value('(../../../../../SiteRef/@LocationOID)[1]','NVARCHAR(50)')
                ,StudyEventOID      =isnull(T.n.value('(../../../../@StudyEventOID)[1]','VARCHAR(100)'), '')
                ,FolderNest         =isnull(T.n.value('(../../../../@StudyEventRepeatKey)[1]','VARCHAR(101)'), '')
                ,FormOID            =isnull(T.n.value('(../../../@FormOID)[1]','varchar(100)'), '')
                ,FormRepeatKey      =isnull(T.n.value('(../../../@FormRepeatKey)[1]','VARCHAR(100)'), '')
                ,ItemGroupOID       =isnull(T.n.value('(../../@ItemGroupOID)[1]','VARCHAR(100)'), '')
                ,recordOrdinal      =isnull(T.n.value('(../../@ItemGroupRepeatKey)[1]','smallint'), -1)
                ,ItemOID            =isnull(T.n.value('(../@ItemOID)[1]','VARCHAR(100)'), '')
                ,SourceIdentifier   =T.n.value('@OID','varchar(50)')
                ,UUID               =isnull(T.n.value('declare namespace mdsol="~";(../@mdsol:CodingTermUUID)[1]','varchar(40)'), '')

            from cteX
              cross apply Xodom.nodes('declare namespace mdsol="~";/ODM/ClinicalData/SubjectData/StudyEventData/FormData/ItemGroupData/ItemData/mdsol:QueueItem') T(n);
        delete @T where zipped =0;
    end--loop

    --process the compressed ODMs
    select @mxkey=isnull(min(id),1)-1 from @T;

    while(@@rowcount >0)
    begin
        if( @checkStop < getdate() )
        begin
            print 'Time out enforced.'
            return -2;
        end

        insert into @T
        select distinct top(500) req.codingRequestId,
            req.IsXmlCompressed
        from codingRequests req (nolock)
        where req.codingRequestId >@mxkey
          and req.segmentId =@segmentId
          and dataLength(xmlContent) >0
        order by 1
        option(force order);

        select @mxkey =max(id)from @T;
        set @print ='counter key (compressed): '+ cast(@mxkey as varchar);
        RAISERROR(@print,0,1) WITH NOWAIT;    --flush prints

        ;WITH cteX
        AS(
            select top(@topCount)
                CodingRequestId =T.id, req.SourceSystemId,    -- 1.c finally cast to xml
                Xodom =convert(xml,
                    -- 1.b simplify the XML into one schema and reduce the meta
                    N'<ODM xmlns:mdsol="~">'+substring(CMP.XmlContent, charindex('<ClinicalData',CMP.XmlContent), len(CMP.xmlContent))
                )
            from @T T
              join CodingRequests req (nolock) on req.codingRequestId =T.id
              cross apply(select xmlcontent =/*clr*/dbo.Decompress(req.XmlContent) ) CMP
            order by 1
        )
        insert into _CodingOdmValues
            SELECT
                CodingRequestId

                -- *** Source Properties
                --singletons
                ,StudyOID           =T.n.value('(//*/@StudyOID)[1]','VARCHAR(50)')

                --multiples
                ,SubjectKey         =isnull(T.n.value('(../../../../../@SubjectKey)[1]','NVARCHAR(50)'), '')
                ,SiteOID            =T.n.value('(../../../../../SiteRef/@LocationOID)[1]','NVARCHAR(50)')
                ,StudyEventOID      =isnull(T.n.value('(../../../../@StudyEventOID)[1]','VARCHAR(100)'), '')
                ,FolderNest         =isnull(T.n.value('(../../../../@StudyEventRepeatKey)[1]','VARCHAR(101)'), '')
                ,FormOID            =isnull(T.n.value('(../../../@FormOID)[1]','varchar(100)'), '')
                ,FormRepeatKey      =isnull(T.n.value('(../../../@FormRepeatKey)[1]','VARCHAR(100)'), '')
                ,ItemGroupOID       =isnull(T.n.value('(../../@ItemGroupOID)[1]','VARCHAR(100)'), '')
                ,recordOrdinal      =isnull(T.n.value('(../../@ItemGroupRepeatKey)[1]','smallint'), -1)
                ,ItemOID            =isnull(T.n.value('(../@ItemOID)[1]','VARCHAR(100)'), '')
                ,SourceIdentifier   =T.n.value('@OID','varchar(50)')
                ,UUID               =isnull(T.n.value('declare namespace mdsol="~";(../@mdsol:CodingTermUUID)[1]','varchar(40)'), '')

            from cteX
              cross apply Xodom.nodes('declare namespace mdsol="~";/ODM/ClinicalData/SubjectData/StudyEventData/FormData/ItemGroupData/ItemData/mdsol:QueueItem') T(n);

        delete @T;
    end--loop
end--CMP_spMassExtractionOdm
go
