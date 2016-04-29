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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spFixGroupVerbatims')
	DROP PROCEDURE spFixGroupVerbatims
GO

CREATE PROCEDURE dbo.spFixGroupVerbatims
AS
BEGIN

	-- 1. remove unnecessary group verbatims
	DELETE GVE
	FROM GroupVerbatimEng GVE
		JOIN VerbatimIdsEng VE
			ON GVE.GroupVerbatimID = VE.Id
			-- except for the entries to keep!
			AND GVE.GroupVerbatimID <> VE.TargetID

	DELETE GVJ
	FROM GroupVerbatimJpn GVJ
		JOIN VerbatimIdsJpn VJ
			ON GVJ.GroupVerbatimID = VJ.Id
			-- except for the entries to keep!
			AND GVJ.GroupVerbatimID <> VJ.TargetID


	-- 2. Verbatim updates
	UPDATE GVE
	SET GVE.VerbatimText = VE.Verbatim
	FROM GroupVerbatimEng GVE
		JOIN VerbatimIdsEng VE
			ON GVE.GroupVerbatimID = VE.TargetId

	UPDATE GVJ
	SET GVJ.VerbatimText = VJ.Verbatim
	FROM GroupVerbatimJpn GVJ
		JOIN VerbatimIdsJpn VJ
			ON GVJ.GroupVerbatimID = VJ.TargetId

END