-- Heap table causes sql server to lock entire table on any row insert/delete,
-- so adding clustered index to reduce this contention
IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
			  WHERE CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME = 'RuntimeLocks')
BEGIN
	ALTER TABLE dbo.RuntimeLocks ADD CONSTRAINT PK_RuntimeLocks
	PRIMARY KEY CLUSTERED (LockString)
END
