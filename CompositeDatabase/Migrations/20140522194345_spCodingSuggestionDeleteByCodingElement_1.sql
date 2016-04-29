/** 
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSuggestionDeleteByCodingElement')
	DROP PROCEDURE dbo.spCodingSuggestionDeleteByCodingElement
GO

CREATE PROCEDURE dbo.spCodingSuggestionDeleteByCodingElement (
	@codingElementId BIGINT
)
AS
BEGIN

	DELETE FROM CodingSuggestions
	WHERE CodingElementID = @codingElementId

END

GO
  