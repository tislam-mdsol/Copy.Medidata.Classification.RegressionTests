/*
** Copyright© 2007, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Keith Howells  khowells@mdsol.com
**
** This procedure parses a welcome message and substitutes values for any names in braces
**
*/

-- WORK IN PROGRESS

if object_id('spWlcmMssgGt') is not null
	drop procedure spWlcmMssgGt
go

create procedure spWlcmMssgGt(@LevelId int, @ObjectId int, @userid int, @roleid int, @locale char(3), @message nvarchar(4000) output) as
begin
set nocount on

	declare @ThisMessage nvarchar(4000), @Priority int, @MessageId int, @PriorityTag nvarchar(50)
	create table #TempPriority (priority int) 
	declare @MaxPriority int, @FunctionName varchar(50), @FunctionArgument nvarchar(1000), @sql nvarchar(4000)
	set @Message=null
	set @MaxPriority=0

	declare cMsgs cursor fast_forward for select WelcomeMessage, Priority, PriorityTag from WelcomeMessages m
	where getutcdate() between FromDate and ToDate
	and priority > 0 and active=1 and deleted=0
	and ((@levelid = 0 and ShowAtTopLevel=1) 
	or (@levelid = 1 and ShowAtStudyLevel=1 and (AllStudies=1 or exists (select null from WelcomeMessageStudies ms
		 where ms.WelcomeMessageID=m.WelcomeMessageID and ms.StudyID=@ObjectID))) 
	or (@levelid = 2 and ShowAtSiteLevel=1 and (AllStudies=1 or exists (select null from WelcomeMessageStudies ms
		join studysites ss on ms.StudyID=ss.StudyID		 
		where ms.WelcomeMessageID=m.WelcomeMessageID and ss.StudySiteID=@ObjectID))))
	and (AllRoles=1 or exists (select null from WelcomeMessageRoles mr where mr.WelcomeMessageID=m.WelcomeMessageID
								and mr.roleID=@roleID))
	order by WelcomeMessageId
	open cMsgs
	fetch cMsgs into @MessageID, @Priority, @PriorityTag
	while @@fetch_status=0
	begin
-- See if there is a tag to compute the priority
		if @PriorityTag is not null
		begin
			set @FunctionName=null
			select @FunctionName=SQLFunction, @FunctionArgument=SQLArgument from WelcomeMessageTags 
			where MessageTag=@PriorityTag
			If @FunctionName is not null
			begin
				if @functionArgument is null
					set @functionArgument='null'
				else set @functionArgument=''''+@functionArgument+''''

				set @sql='insert into #TempPriority select dbo.'+@functionName+'('+@functionArgument+','
				+cast(@priority as varchar)+','+cast(@LevelId as varchar)+','+Cast(@ObjectID as varchar)+
				+','+Cast(@userid as varchar)+','+Cast(@roleid as varchar)+','''+@locale+''')'
				exec sp_executesql @sql
				Select @Priority=Priority from #TempPriority
				truncate table #TempPriority
			end
		end	
-- If This exceeds maximum priority, get the message contents
		If @Priority > @MaxPriority
		begin
			exec spWelcomeMessageParse @MessageID, @LevelId,@ObjectId,@userid,@roleid,@locale,@Thismessage output
			if @ThisMessage is not null
			begin
				Set @Message = @ThisMessage
				Set @MaxPriority = @Priority
			end
		end

		fetch cMsgs into @MessageID, @Priority, @PriorityTag	
	end
	close cMsgs
	deallocate cMsgs
end
go

/**
** Revision History:
** $Log: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spWelcomeMessageGet.sql $
** 
** 3     7/26/07 6:13p Khowells
** DT 6356, ignore deleted messages
** 
** 2     7/20/07 5:42p Khowells
** Added extra arguments for message tags
** 
** 1     7/12/07 2:47p Dgoswami
** Customized Welcome Message Implementation.
** 
**
** $Header: /Viper/Medidata 5 RAVE Database Project/Stored Procedures/spWelcomeMessageGet.sql 3     7/26/07 6:13p Khowells $
** $Workfile: spWelcomeMessageGet.sql $
**/