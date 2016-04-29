--alter default value from 1 to 0 for column IsStillInService 
DECLARE @Command NVARCHAR(400),@ConstraintName NVARCHAR(50)
SELECT  @Command = 'ALTER TABLE CodingElements DROP CONSTRAINT ' + d.name, @ConstraintName=d.name
FROM sys.tables t
JOIN sys.default_constraints d 
ON d.parent_object_id=t.object_id
JOIN sys.columns c 
ON c.object_id =t.object_id AND d.parent_column_id=c.column_id
WHERE t.name ='CodingElements'
AND c.name ='IsStillInService'

IF (@ConstraintName IS NOT NULL)
BEGIN
execute(@Command)
END

IF NOT EXISTS(SELECT NULL FROM sys.default_constraints 
     WHERE object_id=OBJECT_ID('DF_CodingElements_IsStillInService'))
BEGIN
	ALTER TABLE CodingElements
	ADD CONSTRAINT DF_CodingElements_IsStillInService
	DEFAUlT 0 FOR IsStillInService
END

IF NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingElements'
	AND COLUMN_NAME = 'FailureCount')
BEGIN
	ALTER TABLE CodingElements
	ADD FailureCount INT 
	CONSTRAINT DF_CodingElements_FailureCount DEFAULT 0 NOT NULL
END





