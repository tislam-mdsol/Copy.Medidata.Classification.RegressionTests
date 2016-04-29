/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// ------------------------------------------------------------------------------------------------------*/
 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSuggestionLoadByTermIdsAndCodingElement')
	DROP PROCEDURE spCodingSuggestionLoadByTermIdsAndCodingElement
GO
CREATE PROCEDURE dbo.spCodingSuggestionLoadByTermIdsAndCodingElement
(
	@SuggestedTermIds VARCHAR(MAX),----Suggested Term IDs [comma separeted]
	@CodingElementId BIGINT
)
AS
	SELECT CS.*
	FROM
	(SELECT CAST(Item AS BIGINT) AS TermID
	FROM dbo.fnParseDelimitedString(@SuggestedTermIds,',')) T
		JOIN CodingSuggestions CS
			ON CS.MedicalDictionaryTermID = T.TermID
			AND CodingElementId = @CodingElementId
	
GO   