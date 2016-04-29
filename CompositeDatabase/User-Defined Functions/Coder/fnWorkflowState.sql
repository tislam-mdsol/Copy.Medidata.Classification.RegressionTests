/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of
// this file may not be disclosed to third parties, copied or duplicated in
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: thang v ung tung@mdsol.com
//
// bridge the trivial enumerated keys, to handle removal of coder..WorkflowStates table.
// has additional handling to interpret non-predefines as character base mnemonic, e.g. "WAIT"
	--select dbo.fnWorkflowState(2004121709), dbo.fnWorkflowState(6), dbo.fnWorkflowState(1380270926)
// ------------------------------------------------------------------------------------------------------
*/

if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.fnWorkflowState')
		AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
begin
	DROP FUNCTION dbo.fnWorkflowState
	PRINT 'FUNCTION: fnWorkflowState DROPPED'
end
go

create function fnWorkflowState(@stateId int)
returns varchar(32)
begin
	return(case @stateId
		when 0x00000001 then 'Start'
		when 0x00000002 then 'Waiting Manual Code'
		when 0x00000003 then 'Waiting Approval'
		when 0x00000004 then 'Waiting Transmission'
		when 0x00000005 then 'Completed'
		when 0x00000006 then 'Reconsider'
		--interpret as mnemonic
		else rtrim(cast(@stateId as varchar(4)))
		end)--case
end
go
