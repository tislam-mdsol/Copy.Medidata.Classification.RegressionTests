/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// ------------------------------------------------------------------------------------------------------*/

--SELECT * FROM dbo.fnCheckTableRelations(0,0,1)

-- THIS FUNCTION will check the following:
-- 1. The existence of PRIMARY KEY defintions and PK naming conformance to convention
----- ACTION : generate Statements logging all warnings
-- 2. The existence of NULLABLE Columns on Foreign Key relations (they should not be NULLABLE)
----- ACTION : generate SQL code to UPDATE columns, ALTER tables to make them NOT NULLABLE
----- WARNING : running this CODE may affect code which expects NULL(s) - BEWARE!
-- 3. The existence of Indexes for each Foreign Key Definitions
----- ACTION : generate SQL code to create missing indexes (it WON't DROP existing indexes, so wrong INDEX names will cause problems to persist)


IF object_id('fnCheckTableRelations') IS NOT NULL
	DROP FUNCTION fnCheckTableRelations
GO
CREATE FUNCTION fnCheckTableRelations
(
	@CheckPrimaryKey BIT,
	@CheckForeignKeyIndex BIT,
	@CheckForeignKeyNullable BIT
)
RETURNS @sqlCodes TABLE(SqlCodeEntry VARCHAR(4001))
AS
BEGIN

	DECLARE @userTables TABLE(TableName VARCHAR(256), ObjectID INT PRIMARY KEY)
	DECLARE @ixName VARCHAR(500)
	
	-- get all the tables
	INSERT INTO @userTables(TableName, ObjectID)
	SELECT name, object_id
	FROM sys.tables
	WHERE type_desc = 'USER_TABLE'
	
	-- Foreach Table
	DECLARE tableCursor CURSOR FAST_FORWARD FOR
	SELECT TableName, ObjectID
	FROM @userTables
	
	DECLARE @tableName VARCHAR(256), @objID INT,
		@IsMissingPrimaryKey BIT, @IsPKNameConformant BIT,
		@PKName VARCHAR(256)
	
	OPEN tableCursor
	FETCH NEXT FROM tableCursor INTO @tableName, @objID
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
	
		---- 1. Check Primary Key constraint
		IF (@CheckPrimaryKey = 1)
		BEGIN
		
			SET @PKName = NULL
			
			SELECT @PKName = name
			FROM sys.key_constraints
			WHERE parent_object_id = @objID
				AND type_desc = 'PRIMARY_KEY_CONSTRAINT'
			
			IF (@PKName IS NULL)
			BEGIN
				SET @IsMissingPrimaryKey = 1
				SET @IsPKNameConformant = 1
			END
			ELSE
			BEGIN

				SET @IsMissingPrimaryKey = 0
				IF (@PKName = 'PK_'+@tableName)
					SET @IsPKNameConformant = 1
				ELSE
					SET @IsPKNameConformant = 0
			END

			-- log the problems		
			IF (@IsMissingPrimaryKey = 1 OR @IsPKNameConformant = 0)
			BEGIN
		
				DECLARE @warningMSG VARCHAR(500)
				
				SET @warningMSG = 'TABLE:['+@tableName+'] '
				IF (@IsMissingPrimaryKey = 1)
					SET @warningMSG = @warningMSG + 'DOES NOT HAVE A PRIMARY KEY'
				ELSE
					SET @warningMSG = @warningMSG + 'HAS A PRIMARY KEY, BUT IT DOES NOT CONFORM TO THE NAMING CONVENTION'
		
				INSERT INTO @sqlCodes (SqlCodeEntry)
				VALUES(@warningMSG)
			
			
				-- DO NOT AUTO-CREATE PKs (code below for reference)
				--IF (@IsPKNameConformant = 0)
				--BEGIN
				--	-- drop the non-conformant PK
				--	INSERT INTO @sqlCodes (SqlCodeEntry)
				--	VALUES('IF NOT EXISTS (SELECT NULL FROM sysobjects WHERE name = '''+ @PKName +''')')

				--	INSERT INTO @sqlCodes (SqlCodeEntry)
				--	VALUES('	ALTER TABLE ' + @tableName)
				--	INSERT INTO @sqlCodes (SqlCodeEntry)
				--	VALUES('	DROP CONSTRAINT ' + @PKName)
					
				--	INSERT INTO @sqlCodes (SqlCodeEntry)
				--	VALUES('GO')		
					
				--END
			

				--DECLARE @IDColName VARCHAR(256)
				
				--SET @ixName = 'PK_'+ @tableName
				---- get the 1st column def for primary key
				--SELECT @IDColName = name
				--FROM sys.columns
				--WHERE object_id = OBJECT_ID(@tableName)
				--	AND column_id = 1
				
				--INSERT INTO @sqlCodes (SqlCodeEntry)
				--VALUES('IF NOT EXISTS (SELECT NULL FROM sysobjects WHERE name = '''+ @ixName +''')')

				--INSERT INTO @sqlCodes (SqlCodeEntry)
				--VALUES('	ALTER TABLE  ' + @tableName)
				--INSERT INTO @sqlCodes (SqlCodeEntry)
				--VALUES('	ADD CONSTRAINT  ' + @ixName)
				--INSERT INTO @sqlCodes (SqlCodeEntry)
				--VALUES('	PRIMARY KEY CLUSTERED (' + @IDColName + ')')

				--INSERT INTO @sqlCodes (SqlCodeEntry)
				--VALUES('GO')		
				
			END
		END
		
		
		-- 2. Check Foreign Keys and Indices on foreign keys
		DECLARE constraintCursor CURSOR FAST_FORWARD FOR
		SELECT SFK.name, SC_Parent.name, SC_Parent.Is_Nullable, ST_Ref.name, SC_Ref.name, SC_Ref.Is_Nullable,
			SC_Parent.system_type_id,
			CASE WHEN EXISTS (
				SELECT SI.name, COUNT(*) 
				FROM sys.index_columns SIC
				JOIN sys.indexes SI
					ON SIC.object_id = SI.object_id
					AND SIC.index_id = SI.index_id
					AND SIC.object_id = SFK.parent_object_id
					AND SI.is_primary_key = 0
					AND SFKC.parent_column_id IN (SELECT SIX.column_id
							  FROM sys.index_columns SIX
							  WHERE SIX.object_id = SI.object_id
								AND SIX.index_id = SI.index_id)
				GROUP BY SI.name
				HAVING COUNT(*) = 1) THEN 0
			ELSE 1
			END AS Problem
		FROM sys.foreign_keys SFK
			JOIN sys.foreign_key_columns SFKC
				ON SFKC.constraint_object_id = SFK.object_id
				AND SFK.type_desc = 'FOREIGN_KEY_CONSTRAINT'
				AND SFK.parent_object_id = @objId
			JOIN sys.columns SC_Parent
				ON SC_Parent.object_id = @objId
				AND SC_Parent.column_id = SFKC.parent_column_id
			JOIN sys.columns SC_Ref
				ON SC_Ref.object_id = SFKC.referenced_object_id
				AND SC_Ref.column_id = SFKC.referenced_column_id
			JOIN sys.tables ST_Ref
				ON SFKC.referenced_object_id = ST_Ref.object_id
		
		DECLARE @fkName VARCHAR(256), @colName VARCHAR(256), @IsMissingIndex BIT,
			@refTableName VARCHAR(256), @refColName VARCHAR(256),
			@IsColNullable BIT, @IsRefColNullable BIT, @sysTypeID INT
		
		OPEN constraintCursor
		FETCH NEXT FROM constraintCursor INTO @fkName, @colName, @IsColNullable, @refTableName, @refColName, @IsRefColNullable, @sysTypeID, @IsMissingIndex
		
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
		
			-- a. Fix the NULLABLE Column problem (only current table)
			IF ((@IsColNullable = 1 OR @IsRefColNullable = 1) AND @CheckForeignKeyNullable = 1)
			BEGIN
			
				DECLARE @typeName VARCHAR(20)
				
				SELECT @typeName = name
				FROM sys.types
				WHERE @sysTypeID = system_type_id
			
				-- GENERATE SQL ONLY IF ref TABLE IS NON_NULLABLE 
				-- AND THE DATATYPE IS INTEGER VARIANT
				IF (@IsRefColNullable = 0
					AND
					@typeName IN ('tinyint', 'smallint', 'int', 'bigint')
				)
				BEGIN
					
					--UPDATE THE TABLE, set all NULLS TO -1
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('UPDATE '+@tableName)
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('SET ' + @colName + ' = -1')
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('WHERE ' + @colName + ' IS NULL')
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('GO')
					
					-- ALTER TABLE
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('ALTER TABLE '+@tableName)
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('ALTER COLUMN '+ @colName+' '+@typeName+' NOT NULL')
					INSERT INTO @sqlCodes (SqlCodeEntry)					
					VALUES('GO')
				
				END
				ELSE
				BEGIN
				
					INSERT INTO @sqlCodes (SqlCodeEntry)
					VALUES('NULLABLE FK COLUMNS IN TBL.COL('+CAST(@IsColNullable AS VARCHAR)+'):['+ @tableName+'.'+ @colName+'] REF TBL.COL('+CAST(@IsRefColNullable AS VARCHAR)+'):['+ @refTableName+'.'+ @refColName+']')
				
				END
			
			END
			
			-- b. Fix the Missing Indexes
			IF (@CheckForeignKeyIndex = 1 AND @IsMissingIndex = 1)
			BEGIN

				SET @ixName = 'IX_'+ @tableName + '_' + @colName
				
				INSERT INTO @sqlCodes (SqlCodeEntry)
				VALUES('IF NOT EXISTS (SELECT NULL FROM sysindexes WHERE name = '''+ @ixName +''')')

				INSERT INTO @sqlCodes (SqlCodeEntry)
				VALUES('	CREATE INDEX ' + @ixName +' ON ' + @tableName+'(' +@colName + ')')

				INSERT INTO @sqlCodes (SqlCodeEntry)
				VALUES('GO')
			
			END			
			
			FETCH NEXT FROM constraintCursor INTO @fkName, @colName, @IsColNullable, @refTableName, @refColName, @IsRefColNullable, @sysTypeID, @IsMissingIndex

		END

		CLOSE constraintCursor
		DEALLOCATE constraintCursor
		
		FETCH NEXT FROM tableCursor INTO @tableName, @objID

	END
	
	CLOSE tableCursor
	DEALLOCATE tableCursor
	
	RETURN
	
END

