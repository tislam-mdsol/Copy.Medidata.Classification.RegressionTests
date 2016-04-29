﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowRoleLoadBySegment')
	DROP PROCEDURE dbo.spWorkflowRoleLoadBySegment
GO
create procedure spWorkflowRoleLoadBySegment
(
	@segmentOID varchar(50),
	@SegmentID INT
)
as
begin
	select distinct r.* from WorkflowRoles r
	inner join Segments s on r.SegmentId=s.SegmentID
	where s.OID = @segmentOID
end

 