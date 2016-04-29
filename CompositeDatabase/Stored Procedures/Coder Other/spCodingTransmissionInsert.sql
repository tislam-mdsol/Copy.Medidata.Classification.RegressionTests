/** $Workfile:  $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**
** Complete history on bottom of file
**/

if exists (select * from sysobjects where id = object_id(N'dbo.spCodingTransmissionInsert') and objectproperty(id, N'IsProcedure') = 1)
    drop procedure dbo.spCodingTransmissionInsert
go

Create Procedure dbo.spCodingTransmissionInsert (
	@CodingTransmissionID bigint output,
	@CodingSourceTermID bigint,
	@CodingRequestId bigint,
	@TransmissionDate datetime,
	@TransmissionSuccess bit,
	@Acknowledged bit,
	@AcknowledgeDate datetime,
	@Created datetime output,  
	@Updated datetime output  
)
AS
begin

DECLARE @UtcDate DateTime  
SET @UtcDate = GetUtcDate()  
SELECT @Created = @UtcDate, @Updated = @UtcDate  

INSERT INTO CodingTransmissions (
	CodingSourceTermID,
	CodingRequestId,
	TransmissionDate,
	TransmissionSuccess,
	Acknowledged,
	AcknowledgeDate,
	Created,
	Updated
) VALUES (
	@CodingSourceTermID,
	@CodingRequestId,
	@TransmissionDate,
	@TransmissionSuccess,
	@Acknowledged,
	@AcknowledgeDate,
	@UtcDate,
	@UtcDate
)

SET @CodingTransmissionID = SCOPE_IDENTITY()

end
Go
/**
** Revision History:
** $Log: $
** 
** 
** 
** $Header: $
** $Workfile: $
**/