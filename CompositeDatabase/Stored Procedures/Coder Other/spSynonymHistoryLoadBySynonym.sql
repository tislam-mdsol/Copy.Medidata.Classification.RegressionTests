/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSynonymHistoryLoadBySynonym')
	DROP PROCEDURE spSynonymHistoryLoadBySynonym
GO
CREATE PROCEDURE dbo.spSynonymHistoryLoadBySynonym(@SynonymTermId INT)
AS

	BEGIN TRY

		;WITH synHistoryCTE (SynonymHistoryID, SynonymTermID, PriorSynonymTermID)
		AS
		(
			SELECT SynonymHistoryID, SynonymTermID, PriorSynonymTermID
			FROM SynonymHistory
			WHERE SynonymTermID = @SynonymTermId
			
			UNION ALL
			
			SELECT synHistory.SynonymHistoryID, synHistory.SynonymTermID, synHistory.PriorSynonymTermID
			FROM synHistoryCTE cte
				JOIN SynonymHistory synHistory
					ON cte.PriorSynonymTermID = synHistory.SynonymTermID
		)

		SELECT synHistory.*
		FROM SynonymHistory synHistory
			JOIN synHistoryCTE cte
				ON cte.SynonymHistoryID = synHistory.SynonymHistoryID
		OPTION (MAXRECURSION 200) -- not more than 200 recursions
	
	END TRY
	BEGIN CATCH

		IF ERROR_NUMBER() <> 530
		BEGIN
			DECLARE	@ErrorSeverity int, 
					@ErrorState int,
					@ErrorLine int,
					@ErrorMessage nvarchar(4000),
					@ErrorProc nvarchar(4000)

			SELECT @ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE(),
					@ErrorLine = ERROR_LINE(),
					@ErrorMessage = ERROR_MESSAGE(),
					@ErrorProc = ERROR_PROCEDURE()
			SELECT @ErrorMessage = coalesce(@ErrorProc, 'spSynonymHistoryLoadBySynonym.sql - Exception thrown :') + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage + CONVERT(VARCHAR,GETUTCDATE(),21)
			RAISERROR (@ErrorMessage,  @ErrorSeverity, @ErrorState);
		END

	END CATCH
GO
