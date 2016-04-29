/**
** Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Bonnie Pan [bpan@mdsol.com]
**
**/

if exists (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedDictVerDiffLocRefLoadByDictId')
    drop procedure dbo.spMedDictVerDiffLocRefLoadByDictId
go

CREATE PROCEDURE dbo.spMedDictVerDiffLocRefLoadByDictId
(
	@dictionaryId INT,
	@fromVersionId INT, 
	@toVersionId INT
) 
AS

	-- if fromVersionId is -1 we're searching for versions given the toVersionId
	-- likewise if toVersionId is -1 we're searching for versions given the fromVersionId
	-- if both -1, then we want all

	;WITH versionsCTE (VersionId, Locale) AS
	(
		SELECT DISTINCT(NewVersionId), Locale FROM DictionaryVersionLocaleRef
		WHERE DictionaryRefID = @dictionaryId
			AND @toVersionId = -1
			AND @fromVersionId IN (-1, OldVersionId)
			AND VersionStatus = 10
		UNION
		SELECT DISTINCT(OldVersionId), Locale FROM DictionaryVersionLocaleRef
		WHERE DictionaryRefID = @dictionaryId
			AND @toVersionId IN (-1, NewVersionId)
			AND @fromVersionId = -1
			AND VersionStatus = 10
		
	)
	
	SELECT * FROM 
	DictionaryVersionLocaleRef D
	JOIN versionsCTE V
		ON D.NewVersionId = V.VersionId
		AND OldVersionOrdinal IS NULL
		AND VersionStatus = 8
		AND DictionaryRefID = @dictionaryId
		AND D.Locale = V.Locale
	ORDER BY DictionaryRefID, NewVersionId
	
GO
