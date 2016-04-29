/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spWorkflowsGetDefaultWorkflow')
	DROP PROCEDURE dbo.spWorkflowsGetDefaultWorkflow
GO

create procedure dbo.spWorkflowsGetDefaultWorkflow
(
	@SegmentId int,
	@MedicalDictionaryId int
)
as
begin


		select top 1 w.* from Workflows w where w.SegmentID=@SegmentId
	
end