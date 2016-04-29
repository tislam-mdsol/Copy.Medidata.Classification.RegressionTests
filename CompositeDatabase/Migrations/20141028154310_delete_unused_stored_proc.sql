    IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApiCronScheduleDelete')
	DROP PROCEDURE spApiCronScheduleDelete

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApiCronScheduleFetch')
	DROP PROCEDURE spApiCronScheduleFetch

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApiCronScheduleInsert')
	DROP PROCEDURE spApiCronScheduleInsert

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApiCronScheduleLoadByApplicationAdmin')
	DROP PROCEDURE spApiCronScheduleLoadByApplicationAdmin

	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spApiCronScheduleUpdate')
	DROP PROCEDURE spApiCronScheduleUpdate

	IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ApiCronSchedules')
	DROP TABLE ApiCronSchedules

