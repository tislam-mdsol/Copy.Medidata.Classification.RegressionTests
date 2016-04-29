IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetFullTextStopWords')
	DROP PROCEDURE dbo.spGetFullTextStopWords