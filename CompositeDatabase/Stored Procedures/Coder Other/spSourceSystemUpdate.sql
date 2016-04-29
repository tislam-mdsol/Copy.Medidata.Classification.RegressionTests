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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSourceSystemUpdate')
	DROP PROCEDURE dbo.spSourceSystemUpdate
GO
create procedure dbo.spSourceSystemUpdate
(
	@OID varchar(50),
	@SourceSystemVersion nvarchar(50),
	@ConnectionURI nvarchar(2000),
	@DefaultLocale char(3),
	@Updated datetime output,
	@SourceSystemID int,
	@DefaultSegmentID INT
)
as
begin
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Updated = @UtcDate

	update dbo.SourceSystems
	set OID=@OID,
		SourceSystemVersion=@SourceSystemVersion,
		ConnectionURI=@ConnectionURI,
		DefaultLocale=@DefaultLocale,
		Updated=@UtcDate,
		DefaultSegmentID = @DefaultSegmentID
	where SourceSystemID=@SourceSystemID
end
go
 