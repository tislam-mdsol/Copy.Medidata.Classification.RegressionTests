IF EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CodingSourceTermReferences'
		 AND COLUMN_NAME = 'ReferenceValue')
	alter table CodingSourceTermReferences 
	alter column ReferenceValue nvarchar(1500) not null

GO
