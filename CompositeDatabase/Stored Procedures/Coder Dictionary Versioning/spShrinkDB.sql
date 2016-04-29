/* Copyright© 2010, Medidata Solutions Worldwide, All Rights Reserved.

 This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
 this file may not be disclosed to third parties, copied or duplicated in 
 any form, in whole or in part, without the prior written permission of
 Medidata Solutions Worldwide.

 Author: Altin Vardhami avardhami@mdsol.com
*/

IF OBJECT_ID('spShrinkDB') IS NOT NULL
	DROP PROCEDURE spShrinkDB
GO

CREATE PROCEDURE spShrinkDB
(
	@ShrinkLogOnly BIT
)
AS
BEGIN

	DECLARE @dbName NVARCHAR(128), @logFileID INT, @logFileName NVARCHAR(256)
	
	SELECT @dbName = db_name()

	SELECT @logFileID = file_id,
		@logFileName = name
	FROM sys.database_files
	WHERE type_desc = 'LOG'

	IF (@ShrinkLogOnly = 1)
	BEGIN
		PRINT N'START SHRINKING LOG FILE_NAME['+@logFileName+'] FOR DB_NAME['+ @dbName +']' + CONVERT(NVARCHAR,GETUTCDATE(),21)
		
		DBCC SHRINKFILE (@logFileID, 0);
		
		PRINT N'END SHRINKING LOG FILE_NAME['+@logFileName+'] FOR DB_NAME['+ @dbName +']' + CONVERT(NVARCHAR,GETUTCDATE(),21)
	END
	ELSE
	BEGIN
		PRINT N'START SHRINKING DATABASE FOR DB_NAME['+ @dbName +']' + CONVERT(NVARCHAR,GETUTCDATE(),21)

		DBCC SHRINKDATABASE (0, 10);

		PRINT N'END SHRINKING DATABASE FOR DB_NAME['+ @dbName +']' + CONVERT(NVARCHAR,GETUTCDATE(),21)
	END

END
GO 