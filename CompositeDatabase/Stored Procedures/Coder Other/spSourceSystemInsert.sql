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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSourceSystemInsert')
	DROP PROCEDURE dbo.spSourceSystemInsert
GO
create procedure dbo.spSourceSystemInsert
(
	@OID varchar(50),
	@SourceSystemVersion nvarchar(50),
	@ConnectionURI nvarchar(2000),
	@DefaultLocale char(3),
	@Created datetime output,
	@Updated datetime output,
	@SourceSystemID int output,
	@DefaultSegmentID INT,
	@MarkingGroup nvarchar(50)
)
as
begin
	DECLARE @UtcDate DateTime
	SET @UtcDate = GetUtcDate()
	SELECT @Created = @UtcDate, @Updated = @UtcDate

	insert into dbo.SourceSystems(OID, SourceSystemVersion, ConnectionURI, DefaultLocale, Created, Updated, DefaultSegmentID, MarkingGroup)
	Values(@OID, @SourceSystemVersion, @ConnectionURI, @DefaultLocale, @Created, @Updated, @DefaultSegmentID, @MarkingGroup)

	SET @SourceSystemID = SCOPE_IDENTITY()
end
go