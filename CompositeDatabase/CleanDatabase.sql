

DECLARE @MedidataReserved1_AppId nvarchar(255)= '6b7df735-7526-4dfd-a334-3fef3b8e3118' -- sandbox uuid

update users set 
firstname = 'Coder Admin', 
Email='medidatacoder+admin@gmail.com', 
Login='coderadmin',
iMedidataId='04677919-3e75-4e1c-80d2-0fb2a561a3f9' -- CoderAdmin in Sandbox
where UserId = 3 -- must be the coder admin user


--------------- Segment Clean All Script ---------------------------------------------------
DECLARE @IsProduction BIT
SET @IsProduction = (SELECT TOP 1 IsProduction 
					FROM CoderAppConfiguration 
					WHERE ACTIVE=1)
--production check					
IF (@IsProduction = 0)
BEGIN
BEGIN TRY
	DECLARE @SegmentOID VARCHAR(50)
	DECLARE segment_cursor CURSOR FOR
	SELECT OID from Segments

	OPEN segment_cursor 
	FETCH NEXT FROM segment_cursor into @SegmentOID

	WHILE @@FETCH_STATUS =0
	BEGIN
		exec spCodingElementsCleanup @SegmentOID, 1,1,0,1
		exec spDictionarySubscriptionCleanup @SegmentOID
		FETCH NEXT FROM segment_cursor into @SegmentOID 
	END

	CLOSE segment_cursor
	DEALLOCATE segment_cursor 
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('global','segment_cursor')>=-1
	BEGIN
		CLOSE segment_cursor
		DEALLOCATE segment_cursor
	END
	DECLARE @errorString NVARCHAR(MAX)
	SET @errorString = N'ERROR Segments Cleanup: Transaction Error Message - ' + ERROR_MESSAGE()
	PRINT @errorString
	RAISERROR(@errorString, 16, 1)
END CATCH
END
--------------------------------------------------------------------------------------------------------

truncate table Interactions
truncate table DoNotAutoCodeTerms
delete from Users where UserId > 3


UPDATE segments set IMedidataId = @MedidataReserved1_AppId where segmentid = 1

delete from activations
truncate table audits
truncate table auditsources
delete from configuration where segmentid > 10
delete from localizations where segmentid > 10
delete from LocalizedDataStringPKs where segmentid > 10
delete from RoleActions where segmentid > 10
delete from RolesAllModules where segmentid > 10
delete from objectsegments where segmentid > 10
delete from userobjectrole
where GrantToObjectTypeId <> 17 or ( GrantToObjectId > 2) or segmentid > 10

delete from objectsegments where objecttypeid = 17 and objectid > 2
delete from segments where segmentid > 10

truncate table ApplicationTrackableObject
truncate table StudyDictionaryVersionHistory
truncate table StudyDictionaryVersion
delete from trackableobjects

truncate table StudyProjects
truncate table SourceSystemTestTransmission
delete from ApplicationAdmin
delete from Application
delete from applicationtype

truncate table outtransmissions
truncate table outtransmissionlogs
truncate table transmissionqueueitems
delete from sourcesystems
delete from CodingRequests
delete from CodingRejections

truncate table codingpatterns

truncate table SubscriptionLogs
truncate table dictionaryversionlocaleref
truncate table dictionaryversionref
truncate table dictionarylevelref
truncate table dictionarycomponenttyperef
truncate table dictionaryref

truncate table groupVerbatimeng
truncate table groupVerbatimjpn

truncate table userobjectworkflowrole

delete from WorkflowActionItems where SegmentId > 10
delete from WorkflowActionList where SegmentId > 10
delete from WorkflowStateActions where SegmentId > 10
delete from WorkflowActionReasons where SegmentId > 10
delete from WorkflowTaskHistory
delete from WorkflowRoleActions where SegmentId > 10
delete from WorkflowActions where Segmentid > 10
delete from WorkflowReasons where SegmentId > 10
delete from workflowStates where SegmentId > 10
delete from workflowtaskdata
delete from workflowvariablelookupvalues where segmentid > 10
delete from WorkflowVariables where segmentid > 10
delete from workflowroles where segmentid > 10
delete from Workflows where SegmentId > 10

delete from [LocalizedDataStrings] where segmentid > 10