/** $Workfile: spMedDictVerLocLoadByDictIdAndLoc $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spMedDictVerLocLoadByDictIdAndLoc')
	DROP PROCEDURE dbo.spMedDictVerLocLoadByDictIdAndLoc
GO

CREATE PROCEDURE dbo.spMedDictVerLocLoadByDictIdAndLoc (@MedicalDictionaryId INT, @Locale CHAR(3))
AS
BEGIN
SET NOCOUNT ON
                                                                                                       
	SELECT * from MedicalDictVerLocaleStatus   
	WHERE MedicalDictionaryId = @MedicalDictionaryId
		AND Locale = @Locale
		AND OldVersionOrdinal IS NULL
		AND VersionStatus = 8
	ORDER BY MedicalDictionaryId, NewVersionOrdinal

END

GO 