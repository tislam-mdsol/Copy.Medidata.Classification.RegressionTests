/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementAnyTaskInServiceForStudyVersion')
	DROP PROCEDURE spCodingElementAnyTaskInServiceForStudyVersion
GO
CREATE PROCEDURE dbo.spCodingElementAnyTaskInServiceForStudyVersion
(
	@StudyVersionId INT,
	@AnyInService BIT OUTPUT
)
AS

	SET @AnyInService = 0
	
	IF EXISTS (SELECT NULL FROM CodingElements
			WHERE StudyDictionaryVersionId = @StudyVersionId
				AND IsStillInService = 1)
		SET @AnyInService = 1


GO
