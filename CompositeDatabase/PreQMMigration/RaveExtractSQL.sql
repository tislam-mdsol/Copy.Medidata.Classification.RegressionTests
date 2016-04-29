--********************************************************************************************************
-- * Author: Prathyusha M
-- * Create Date: Apr 18 2016
-- * Work Request: MCC-223250
-- * Rave Version Developed For:
-- * URL: 
-- * Module: 
--	 DT# (if applicable): 
--********************************************************************************************************
--********************************************************************************************************
-- *Description: Extract RAVE data to compare values on CODER and map RAVE terms with CODER tasks
--********************************************************************************************************

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET QUOTED_IDENTIFIER ON

select distinct
	dbo.fnLocalDefault(p.ProjectName) as ExternalObjectName,
	dbo.fnLocalDefault(st.EnvironmentNameID) as EnvironmentName,
	st.uuid as ExternalObjectId,
	dbo.fnLocalDefault(si.SiteNameID) as SiteName,
	si.sitenumber as SiteNumber,
	su.subjectname  as SourceSubject,
	isnull(dbo.fnlocaldefault(fl.foldername), '-') as FolderName,
	isnull(fl.OID, '-') as FolderOID,
	isnull(dbo.fnLocalizedInstanceName('eng', i.ParentInstanceID), '-') as ParentInstance,
	isnull(dbo.fnLocalizedInstanceName('eng', i.InstanceID), '-') as InstanceName,
	isnull(i.InstanceRepeatNumber,'-') as InstanceRepeatNumber,
	dbo.fnLocalDefault(fo.formname) as SourceForm,
	fo.OID as FormOID,
	dbo.fnLocalizedDataPageName('eng', dpg.DataPageID) as DataPageName,
	dpg.PageRepeatNumber,
	fi.OID as SourceField,
	rec.RecordPosition,
	dpt.GUID as UUID,
	dpt.datapointID,
	case when ctch.datapointid is null 
		 then 0 else 1
		 end as HasContexthash,
	ctch.ContextHash as CodingContextURI,
-- Active/deleted flags
	dpt.dataactive,
	dpt.istouched,
	rec.recordactive, 
	st.studyactive,
	ss.studysiteactive,
	su.subjectactive,
-- Active/deleted flags END
	dpt.Data as VerbatimTerm,
	stuff([supplementals].query('keys').value('/', 'varchar(max)'),1,1,'') AS [supplementalTermkey],
	stuff([supplementals].query('data').value('/', 'varchar(max)'),1,1,'') AS [supplementalValue],
	cd.created as CodedDate,
	case when cd.coderdecisionid is null 
		then 0 else 1
	end  iscoded,
	stuff(codingpath,1,1,'') as codingpath
from
	projects p
	join studies st on st.projectID = p.projectID
	join studysites ss on ss.studyID = st.studyID
	join sites si on si.siteID = ss.siteID
	join subjects su on su.studysiteID = ss.studysiteID
	join datapages dpg on dpg.subjectID = su.subjectID
	join forms fo on fo.FormID = dpg.FormID
	left join instances i on i.instanceID = dpg.InstanceID
	left join folders fl on fl.folderID = i.FolderID
	join records rec on rec.datapageID = dpg.datapageID
	join datapoints dpt on dpt.recordID = rec.recordID
	join fields fi on fi.fieldID = dpt.fieldID 
	join variables v on v.variableID = fi.variableID
	left join coderdecisions cd on cd.datapointid=dpt.datapointid and cd.deleted=0
	left join codingtermcontexthash ctch on ctch.datapointid=dpt.datapointid
	cross apply ( 
	    select 
			(select ':'+fo2.oid+'.'+fi2.oid as keys , 
					':'+ case when dde.UserDataStringID is null then dpt2.data
					       	else dbo.fnLocalDefault(dde.UserDataStringID)
                      			     end as data
			from fields fi1 
				JOIN coderconfigurations cc on cc.fieldid = fi1.fieldid and fi1.fieldid = dpt.fieldid
				JOIN coderlinkedfieldconfigurations clfc on clfc.coderfieldconfigurationid = cc.id
				JOIN fields fi2 on fi2.fieldid = clfc.linkedfieldid
				JOIN datapoints dpt2 on dpt2.recordid = dpt.recordid and dpt2.fieldid = fi2.fieldid
                    		LEFT JOIN DataDictionaryEntries dde on dde.DataDictionaryEntryID = dpt2.DataDictEntryID
				JOIN forms fo2 on fi2.formID = fo2.formID
				order by fi2.oid
			for xml path(''),type ) as [supplementals]
		) [supplementals]

	 cross apply (
		 select '/'+ cv.Value 
			 from codervalues cv
			 where cv.coderdecisionid=cd.coderdecisionid and cv.deleted=0
			 order by cv.codingcolumnid
			 for xml path('')
		) x(codingpath)
	
where 
	 v.isusingcoder=1