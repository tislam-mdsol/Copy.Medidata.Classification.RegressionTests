/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spRemoveUnreferencedGroup')
	DROP PROCEDURE spRemoveUnreferencedGroup
GO

-- EXEC spRemoveUnreferencedGroup 91670

CREATE PROCEDURE dbo.spRemoveUnreferencedGroup
(  
	@groupId INT
)  
AS 
BEGIN

	DECLARE @errorMessage NVARCHAR(MAX)

	BEGIN TRANSACTION
	BEGIN TRY

		IF EXISTS (	
			SELECT *
			FROM CodingElementGroups CEG
				LEFT JOIN SegmentedGroupCodingPatterns SGCP
					ON CEG.CodingElementGroupID = SGCP.CodingElementGroupID
				LEFT JOIN CodingElements CE
					ON CEG.CodingElementGroupID = CE.CodingElementGroupID
			WHERE CEG.CodingElementGroupID = @groupId AND
				(SGCP.CodingElementGroupID IS NOT NULL
				OR CE.CodingElementGroupID IS NOT NULL)
			)
		BEGIN
			SET @errorMessage = N'Related found wired to this group - aborting!'  
			PRINT @errorMessage
			RAISERROR (@ErrorMessage,  1, 16);
			RETURN
		END

		DELETE CEG
		FROM CodingElementGroups CEG
			LEFT JOIN SegmentedGroupCodingPatterns SGCP
				ON CEG.CodingElementGroupID = SGCP.CodingElementGroupID
			LEFT JOIN CodingElements CE
				ON CEG.CodingElementGroupID = CE.CodingElementGroupID
		WHERE CEG.CodingElementGroupID = @groupId
			AND SGCP.CodingElementGroupID IS NULL
			AND CE.CodingElementGroupID IS NULL
	
		IF (@@ROWCOUNT <> 1)
		BEGIN
			SET @errorMessage = N'Failed to remove only the single group - aborting!'  
			PRINT @errorMessage
			RAISERROR (@ErrorMessage,  1, 16);
			RETURN
		END
	
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
	
		ROLLBACK TRANSACTION
	
		DECLARE	@ErrorSeverity int, 
				@ErrorState int

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE()
			
		RAISERROR (@errorMessage,  @ErrorSeverity, @ErrorState);

	END CATCH

END