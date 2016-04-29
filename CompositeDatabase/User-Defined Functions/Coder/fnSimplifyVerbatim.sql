/* 
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Altin Vardhami [avardhami@mdsol.com]
**/ 


SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnSimplifyVerbatim')
	DROP FUNCTION dbo.fnSimplifyVerbatim
GO
CREATE FUNCTION dbo.fnSimplifyVerbatim
(
	@Term NVARCHAR(450)
) RETURNS NVARCHAR(450)
AS
BEGIN

		
	-- process the verbatims so that quoted ones are handled exactly the same as unquoted ones
	DECLARE @simplifiedVerbatim NVARCHAR(450), @length INT, @idx INT, @toCont BIT, @toContUpper BIT
	DECLARE @firstChar NCHAR(1), @lastChar NCHAR(1)

	SELECT @simplifiedVerbatim  = LTRIM(RTRIM(@Term)),
		@toContUpper = 1

	WHILE (@toContUpper = 1)
	BEGIN
		
		SELECT @length = LEN(@simplifiedVerbatim)+1,
			@idx = 1,
			@toCont = 1

		WHILE (@toCont = 1)
		BEGIN
			SELECT @firstChar = SUBSTRING(@simplifiedVerbatim, @idx, 1),
				@lastChar = SUBSTRING(@simplifiedVerbatim, @length-@idx, 1)

			IF (@firstChar = @lastChar AND @lastChar IN ('''', '"'))
				SET @idx = @idx + 1
			ELSE
				SET @toCont = 0
		END

		SET @simplifiedVerbatim = SUBSTRING(@simplifiedVerbatim, @idx, @length - 2*@idx + 1)
			
		SET @length = LEN(@simplifiedVerbatim)
		SET @simplifiedVerbatim = LTRIM(RTRIM(@simplifiedVerbatim))
		
		IF (@length = LEN(@simplifiedVerbatim))
			SET @toContUpper = 0		

	END 
	
	RETURN @simplifiedVerbatim
	
END
GO

SET NOCOUNT OFF
GO
     		
