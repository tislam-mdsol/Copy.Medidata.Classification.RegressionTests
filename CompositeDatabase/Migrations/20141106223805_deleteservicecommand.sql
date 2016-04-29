IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandLogInsert')
	DROP PROCEDURE spServiceCommandLogInsert
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandLogUpdate')
	DROP PROCEDURE spServiceCommandLogUpdate
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandLogGetLatestCommands')
	DROP PROCEDURE spServiceCommandLogGetLatestCommands
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandLogFetch')
	DROP PROCEDURE spServiceCommandLogFetch
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandFetch')
	DROP PROCEDURE spServiceCommandFetch
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spServiceCommandLoadAll')
	DROP PROCEDURE spServiceCommandLoadAll
GO

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'ServiceCommandLogs'))
BEGIN
DROP TABLE ServiceCommandLogs
END

IF (EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'ServiceCommands'))
BEGIN
DROP TABLE ServiceCommands
END