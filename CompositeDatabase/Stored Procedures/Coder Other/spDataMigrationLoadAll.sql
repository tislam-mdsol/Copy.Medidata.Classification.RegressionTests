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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDataMigrationLoadAll')
	DROP PROCEDURE spDataMigrationLoadAll
GO
CREATE PROCEDURE dbo.spDataMigrationLoadAll
AS
	SELECT DM.*, X.CCount AS TotalCount, RCount AS RemainingCount
	FROM DataMigrations DM
		CROSS APPLY
		(
			SELECT CCount = COUNT(*),
				RCount = SUM(CASE WHEN IsProcessed = 1 THEN 0 ELSE 1 END)
			FROM DataMigrationDetails DMD
			WHERE DMD.DataMigrationId = DM.DataMigrationId
		) AS X
	
GO   