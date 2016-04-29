IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'CMP_FixDuplicateEmptyVerbatimsDebug')
	DROP PROCEDURE CMP_FixDuplicateEmptyVerbatimsDebug
GO

CREATE PROCEDURE dbo.CMP_FixDuplicateEmptyVerbatimsDebug
AS  
BEGIN

	EXEC dbo.CMP_FixDuplicateEmptyVerbatims 0

END