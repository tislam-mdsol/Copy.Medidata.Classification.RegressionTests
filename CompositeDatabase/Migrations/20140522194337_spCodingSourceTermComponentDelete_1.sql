/*
**
** Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** AuthorConnor Ross cross@mdsol.com
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermComponentDelete')
	DROP PROCEDURE spCodingSourceTermComponentDelete
GO

CREATE PROCEDURE spCodingSourceTermComponentDelete (
	@SourceTermComponentID bigint
)
AS

BEGIN
	DELETE FROM dbo.CodingSourceTermComponents
	WHERE SourceTermComponentID = @SourceTermComponentID
END

GO
