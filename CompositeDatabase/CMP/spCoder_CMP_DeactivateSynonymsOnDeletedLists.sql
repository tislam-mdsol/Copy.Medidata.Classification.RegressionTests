/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2015, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Eric Grun egrun@mdsol.com
//
// Update status on synonyms for deleted synonym lists so that they will no longer show up on the Synonym Approval page.
//
// This CMP can be retired with Coder Release 2015.2.0
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoder_CMP_DeactivateSynonymsOnDeletedLists')
	DROP PROCEDURE dbo.spCoder_CMP_DeactivateSynonymsOnDeletedLists
GO

CREATE PROCEDURE dbo.spCoder_CMP_DeactivateSynonymsOnDeletedLists
(
	@SegmentName NVARCHAR(450)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NumDeactivatees INT, @errorString NVARCHAR(MAX), @successString NVARCHAR(MAX)
	DECLARE @SegmentId INT

	SELECT @SegmentId = SegmentId
	FROM Segments 
	WHERE SegmentName = @SegmentName

	IF (@SegmentId IS NULL)
	BEGIN
	    SET @errorString = N'ERROR: No such segment found!'
		PRINT @errorString
		RAISERROR(@errorString, 16, 1)
		RETURN 1
	END

	update sgcp
	set sgcp.SynonymStatus = 0
	from SegmentedGroupCodingPatterns sgcp
	join SynonymMigrationMngmt smm on sgcp.SynonymManagementId = smm.SynonymMigrationMngmtId
	join Segments s on s.SegmentId = sgcp.SegmentID
	where smm.Deleted = 1
	and sgcp.SynonymStatus = 1
	and s.SegmentId=@SegmentId
	select @NumDeactivatees = @@ROWCOUNT

	SET @successString = N'Success! '+CONVERT(VARCHAR,@NumDeactivatees) +' synonyms deactivated from '+@SegmentName
	PRINT @successString
END