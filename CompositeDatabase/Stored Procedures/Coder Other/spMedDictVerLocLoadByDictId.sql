 /** $Workfile: spMedicalDictVerLocaleStatusLoadByDictionaryId.sql $
**
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**
**/

if exists (select * from sysobjects where id = object_id(N'dbo.spMedDictVerLocLoadByDictId') and objectproperty(id, N'IsProcedure') = 1)
    drop procedure dbo.spMedDictVerLocLoadByDictId
go

CREATE PROCEDURE [dbo].[spMedDictVerLocLoadByDictId](@dictionaryId int) 
AS

	SELECT * 
	FROM MedicalDictVerLocaleStatus
	WHERE MedicalDictionaryId = @dictionaryId
		AND OldVersionOrdinal IS NULL AND VersionStatus = 8
	ORDER BY MedicalDictionaryId, NewVersionOrdinal

Go
 