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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermSupplementalDelete')
	DROP PROCEDURE spCodingSourceTermSupplementalDelete
GO

CREATE PROCEDURE spCodingSourceTermSupplementalDelete (
	@SourceTermSupplementalId bigint
)
AS

BEGIN
	DELETE FROM dbo.CodingSourceTermSupplementals
	WHERE SourceTermSupplementalId = @SourceTermSupplementalId
END

GO
