/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spResetAnalysis')
	DROP PROCEDURE spResetAnalysis
GO

CREATE PROCEDURE dbo.spResetAnalysis  
AS
BEGIN

	TRUNCATE TABLE VerbatimIdsEng
	TRUNCATE TABLE VerbatimIdsJpn
	TRUNCATE TABLE AffectedGroups
	TRUNCATE TABLE AffectedSynonyms

END 

