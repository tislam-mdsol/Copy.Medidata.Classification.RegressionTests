IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCorrelateCoderTasks')
	DROP PROCEDURE dbo.spCorrelateCoderTasks
GO
CREATE PROCEDURE dbo.spCorrelateCoderTasks
(
    @raveToken INT
)
AS
BEGIN

    -- TODO : define the correlation logic here!
	select distinct ce.codingelementid,rc.* from ravecoderextract rc
	inner join trackableobjects tr on tr.ExternalObjectId=rc.ExternalObjectId 
	inner join studydictionaryversion sdv on sdv.studyid=tr.trackableobjectid  
	inner join codingelements ce on ce.studydictionaryversionid=sdv.studydictionaryversionid
	inner join codingsourcetermreferences cs_site on cs_site.ReferenceName = 'SITE' and cs_site.ReferenceValue=rc.SiteName
	inner join codingsourcetermreferences cs_event on cs_event.ReferenceName = 'EVENT' and cs_event.ReferenceValue = rc.FolderName
	inner join codingsourcetermreferences cs_log on cs_log.ReferenceName='LINE' 
							and isnull(nullif(cs_log.ReferenceValue,''),0) = rc.RecordPosition 
	inner join SynonymMigrationMngmt smm on smm.SynonymMigrationMngmtID = sdv.synonymManagementID
	cross apply ( 
				select 
					(select ':'+su.SupplementTermKey as keys , 
							':'+ su.SupplementalValue as data
					from  CodingSourceTermSupplementals su 
					where su.codingsourcetermid=ce.codingelementid
					order by su.SupplementTermKey
					for xml path(''),type ) as [supplementals]
				) [supplementals]
	where 
		rc.RaveToken=@RaveToken
		and ce.sourcesubject=rc.SourceSubject
		and ce.SourceField=rc.SourceField
		and ce.SourceForm=rc.SourceForm
		and isnull(ce.uuid,rc.uuid) = rc.uuid
		and stuff([supplementals].query('keys').value('/', 'varchar(max)'),1,1,'')=rc.SupplementalTermkey
		and sdv.RegistrationName=isnull(rc.RegistrationName,sdv.RegistrationName)
		and smm.DictionaryLocale_Backup = isnull(rc.EntryLocale,smm.DictionaryLocale_Backup)
END
