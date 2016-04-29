 

if exists (select * from sysobjects where name = 'CoderSupportTransmissions')
	DROP TABLE CoderSupportTransmissions

CREATE TABLE CoderSupportTransmissions(
	RunDT datetime,
	WRNumber int,
	TransmissionQueueItemID bigint,
	FailureCount int,
	SuccessCount int,
	tqiCreated datetime,
	tqiUpdated datetime,
	CumulativeFailCount int,
	ServiceWillContinueSending bit,
	IsForUnloadService bit,
	OutTransmissionID bigint,
	Acknowledged bit,
	AcknowledgeDate datetime,
	TransmissionSuccess bit,
	TransmissionDate datetime,
	HttpStatusCode int,
	WebExceptionStatus varchar(50),
	ResponseText nvarchar(max),
	otCreated datetime,
	otUpdated datetime,
	EndDT datetime
)  
 