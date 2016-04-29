﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

if object_id('spUserObjectWorkflowRoleLoadBySegment') is not null
	drop procedure spUserObjectWorkflowRoleLoadBySegment
go

create procedure spUserObjectWorkflowRoleLoadBySegment
(
	@SegmentId bigint
)
as
begin
	select * from UserObjectWorkflowRole 
	where SegmentId=@SegmentId
		AND Active = 1
end 