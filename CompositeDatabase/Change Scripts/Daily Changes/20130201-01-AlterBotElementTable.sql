﻿ IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BOTElements'
		 AND COLUMN_NAME = 'CommentReason' AND DATA_TYPE = 'varchar')
BEGIN
	ALTER TABLE BOTElements 
	ALTER COLUMN CommentReason NVARCHAR(500)
END
GO  

  