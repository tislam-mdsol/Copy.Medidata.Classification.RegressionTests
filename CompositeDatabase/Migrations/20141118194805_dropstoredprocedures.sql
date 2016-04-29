IF object_id('spRlActnUpdtImplByRl') is not null
		DROP  Procedure  spRlActnUpdtImplByRl
GO

IF object_id('spRlDlt') is not null
	drop procedure spRlDlt
go

IF object_id('spRlIsNmUnq') is not null
	drop procedure spRlIsNmUnq
go

IF object_id('spRlLdByMdlId') is not null
	drop procedure spRlLdByMdlId
GO

if object_id('spUsrObjctRlLd') is not null
	drop procedure spUsrObjctRlLd
go

if object_id('spUsrObjctRlLdFrUsrObjct') is not null
	drop procedure spUsrObjctRlLdFrUsrObjct
go

IF OBJECT_ID('spUsrObjctRlLdFrUsrObjctMdl') IS NOT NULL
	DROP PROCEDURE spUsrObjctRlLdFrUsrObjctMdl
GO

if object_id('fnRoleHasActionType') is not null
	drop function fnRoleHasActionType
go

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RolesAllModules')
	DROP TABLE RolesAllModules
GO