
------------------------------------------------------------------

-- DAILY CODER JOB

-- jgiannone, smalaraj, yliu, ddapper

-- updated 2016-01-01 ddapper

-- Obsolete and removed rom job: MCC-111098 - removed code for this MCC, superceded by more general transmission reattempts. 
-- Unnecessary since indexes added 2015-08-11, and removed rom job: MCC-174016  (had been misidentified as MCC-178390) 

-- MCC-199405 - General, audited transmit reattempts, performing
-- 5 additional transmit reattempts over 5 days (5 additional transmits, not e.g. 5 x 5).
 
------------------------------------------------------------------

/*

-- test
dbcc dropcleanbuffers
go
declare @RunDT datetime = getutcdate()
begin transaction
exec spCoderDailyJob
select * from CoderSupportTransmissions where RunDT >= @RunDT
rollback

*/


IF EXISTS (SELECT * FROM sys.objects
	WHERE   TYPE = 'p'
	AND NAME = 'spCoderDailyJob') 
DROP PROCEDURE [dbo].[spCoderDailyJob]
GO

CREATE PROCEDURE spCoderDailyJob
AS 
    BEGIN

	DECLARE 
		@RunDT DATETIME,
		@EndDT DATETIME

	SET @RunDT = GETUTCDATE()

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	-- Re-attempt transmissions to Rave
 
	-------------------------------
	--	object types 	
	--		2251 - PartialCodingDecision
	-- 		2252 - OpenQueryMessage
	--	 	2253 - CancelQueryMessage
	--	 	2254 - CodingRejection
	--		2255 - FullCodingDecision
	-------------------------------

 
	if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb.dbo.#failedTrans') and type = 'u')
		drop table #failedTrans
 
	select
	tqi.TransmissionQueueItemID,
	tqi.ObjectTypeID,
	tqi.ObjectId
	into #failedTrans
	from TransmissionQueueItems tqi
	join (
			SELECT ObjectTypeID, ObjectID, max(TransmissionQueueItemId) TransmissionQueueItemId 
			FROM TransmissionQueueItems
			WHERE SuccessCount = 0
				AND FailureCount >= 5
				AND IsForUnloadService = 0 
				AND Created > DATEADD(d, -5, @RunDT)
			GROUP BY ObjectTypeID, ObjectID
		 ) tqimax on tqimax.TransmissionQueueItemId = tqi.TransmissionQueueItemId
	left join OutTransmissions ot on ot.OutTransmissionID = tqi.OutTransmissionID  
	where 
		(ot.httpstatuscode not in ('200', '204', '403', '404', '409') OR tqi.outtransmissionid <> 0 and ot.httpstatuscode is null OR tqi.OutTransmissionID = 0)
		AND COALESCE(OT.Updated, TQI.Updated) < DATEADD(hh, -2, @RunDT) 


	if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb.dbo.#toBeTransmitted') and type = 'u')
		drop table #toBeTransmitted

	select
		t.*, ce.CodingElementId
	into #toBeTransmitted
	from codingelements ce
	left join workflowtaskdata wftd on  wftd.workflowtaskid = ce.codingelementid and wftd.workflowvariableid = 7 and wftd.data = 'True'
	join codingassignment ca on ca.codingelementid = ce.codingelementid and ca.active = 1
	join #failedTrans t on t.objecttypeid in (2251, 2255) and t.objectid = ca.codingassignmentid
	where
		wftd.workflowtaskid is null
		and ce.workflowstateid = 5 and ce.AssignedCodingPath <> ''
 

	insert #ToBeTransmitted 
	select t.*, ce.CodingElementId
	FROM  #failedTrans t
	INNER JOIN CoderQueryHistory CQH ON CQH.QueryHistoryId = t.ObjectID
	INNER JOIN CoderQueries	CQ ON CQ.QueryId = CQH.QueryId
	INNER JOIN CodingElements CE ON CE.CodingElementId = CQ.CodingElementID
	left join workflowtaskdata wftd on wftd.workflowtaskid = ce.codingelementid and wftd.workflowvariableid = 7 and wftd.data = 'True'
	where
		wftd.workflowtaskid is null
		and ce.workflowstateid = 5 and ce.AssignedCodingPath <> ''
		and t.ObjectTypeID in (2252, 2253)

 
	insert #ToBeTransmitted 
	select t.*, ce.CodingElementId
	FROM  #failedTrans t
	INNER JOIN CodingRejections	CR ON CR.CodingRejectionID = t.ObjectID
	INNER JOIN CodingElements CE ON CE.CodingElementId = CR.CodingElementID
	left join workflowtaskdata wftd on wftd.workflowtaskid = ce.codingelementid and wftd.workflowvariableid = 7 and wftd.data = 'True'
	 where
	 	wftd.workflowtaskid is null
		and ce.workflowstateid = 5 and ce.AssignedCodingPath <> ''
		and t.ObjectTypeID in (2254)
 
 
	SET @EndDT = GETUTCDATE()

	insert CoderSupportTransmissions
	select
		@RunDT RunDT,
		2059481 WRNumber,
		tqi.TransmissionQueueItemID, 
		tqi.FailureCount, 
		tqi.SuccessCount, 
		tqi.Created tqiCreated, 
		tqi.Updated tqiUpdated, 
		tqi.CumulativeFailCount, 
		tqi.ServiceWillContinueSending, 
		tqi.IsForUnloadService, 
		tqi.OutTransmissionID, 
		ot.Acknowledged, 
		ot.AcknowledgeDate, 
		ot.TransmissionSuccess, 
		ot.TransmissionDate, 
		ot.HttpStatusCode, 
		ot.WebExceptionStatus,
		ot.ResponseText, 
		ot.Created otCreated, 
		ot.Updated otUpdated,
		@EndDT EndDT
	from #toBeTransmitted t
	join TransmissionQueueItems tqi on tqi.TransmissionQueueItemID = t.TransmissionQueueItemID
	left join Outtransmissions ot on ot.OutTransmissionID = tqi.OutTransmissionID


	UPDATE TQI SET     
		TQI.CumulativeFailCount = TQI.CumulativeFailCount + TQI.FailureCount,
		TQI.FailureCount = 4,
		TQI.ServiceWillContinueSending = 1,
		TQI.Updated = @RunDT
	FROM TransmissionQueueItems TQI
	JOIN  #ToBeTransmitted t ON t.TransmissionQueueItemID = TQI.TransmissionQueueItemID


	drop table #failedTrans
	drop table #toBeTransmitted

    END
GO