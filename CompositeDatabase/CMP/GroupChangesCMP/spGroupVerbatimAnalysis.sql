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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimAnalysis')
	DROP PROCEDURE spGroupVerbatimAnalysis
GO

CREATE PROCEDURE dbo.spGroupVerbatimAnalysis  
AS
BEGIN

	DECLARE @c13 CHAR(1) = CHAR(13), @c10 CHAR(1) = CHAR(10), @c9 CHAR(1) = CHAR(9)

	-- *** Find the group verbatims ***

	-- 1. English
	INSERT INTO VerbatimIdsEng(Id, Verbatim)
	SELECT GroupVerbatimID, dbo.fnRemoveWhiteSpace(VerbatimText)
	FROM GroupVerbatimEng
	WHERE CHARINDEX(@c10, VerbatimText, 0) > 0
		OR CHARINDEX(@c13, VerbatimText, 0) > 0
		OR CHARINDEX(@c9, VerbatimText, 0) > 0
		OR LTRIM(RTRIM(VerbatimText)) <> VerbatimText
		OR CHARINDEX('  ', VerbatimText, 0) > 0

	-- existing ones
	UPDATE V
	SET V.TargetId = GVE.GroupVerbatimID
	FROM VerbatimIdsEng V
		JOIN GroupVerbatimEng GVE
			ON GVE.VerbatimText = V.Verbatim

	-- insert new ones for nonexisting (generate ids beyond the table max)
	;WITH xC AS
	(
		SELECT MIN(Id) AS TId, Verbatim
		FROM VerbatimIdsEng
		WHERE TargetId < 0
		GROUP BY Verbatim
		-- ignore single ones
		HAVING COUNT(*) > 1
	)
	
	UPDATE V
	SET TargetId = TId 
	FROM VerbatimIdsEng V 
		JOIN xC
			ON V.Verbatim = xC.Verbatim

	-- immediately fix single ones (no need for cascade)
	UPDATE GVE
	SET GVE.VerbatimText = VE.Verbatim
	FROM GroupVerbatimEng GVE
		JOIN VerbatimIdsEng VE
			ON GVE.GroupVerbatimID = VE.Id
			AND VE.TargetId = -1

	DELETE FROM VerbatimIdsEng
	WHERE TargetId = -1

	-- 2. Japanese
	INSERT INTO VerbatimIdsJpn(Id, Verbatim)
	SELECT GroupVerbatimID, dbo.fnRemoveWhiteSpace(VerbatimText)
	FROM GroupVerbatimJpn
	WHERE CHARINDEX(@c10, VerbatimText, 0) > 0
		OR CHARINDEX(@c13, VerbatimText, 0) > 0
		OR CHARINDEX(@c9, VerbatimText, 0) > 0
		OR LTRIM(RTRIM(VerbatimText)) <> VerbatimText
		OR CHARINDEX('  ', VerbatimText, 0) > 0

	-- existing ones
	UPDATE V
	SET V.TargetId = GVJ.GroupVerbatimID
	FROM VerbatimIdsJpn V
		JOIN GroupVerbatimJpn GVJ
			ON GVJ.VerbatimText = V.Verbatim

	-- update new ones for nonexisting
	;WITH xC AS
	(
		SELECT MIN(Id) AS TId, Verbatim
		FROM VerbatimIdsJpn
		WHERE TargetId < 0
		GROUP BY Verbatim
		-- ignore single ones
		HAVING COUNT(*) > 1
	)
	
	UPDATE V
	SET TargetId = TId 
	FROM VerbatimIdsJpn V 
		JOIN xC
			ON V.Verbatim = xC.Verbatim

	-- immediately fix single ones (no need for cascade)
	UPDATE GVJ
	SET GVJ.VerbatimText = VJ.Verbatim
	FROM GroupVerbatimJpn GVJ
		JOIN VerbatimIdsJpn VJ
			ON GVJ.GroupVerbatimID = VJ.Id
			AND VJ.TargetId = -1

	DELETE FROM VerbatimIdsJpn
	WHERE TargetId = -1

	SELECT COUNT(*), 'GroupVerbatim ENG entries found'
	FROM VerbatimIdsEng

	SELECT COUNT(*), 'GroupVerbatim JPN entries found'
	FROM VerbatimIdsJpn

END 

