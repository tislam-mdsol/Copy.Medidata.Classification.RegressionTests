/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Jalal Uddin juddin@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetFullTextWordsExcludeNoiseWords')
	DROP PROCEDURE dbo.spGetFullTextWordsExcludeNoiseWords
GO
create procedure dbo.spGetFullTextWordsExcludeNoiseWords
(
	@termText nvarchar(4000),
	@Lcid int,
	@stopListId int,
	@accentSensitive bit 
)
as
begin
	declare @sql nvarchar(4000), @paramlist nvarchar(1000)
	
	if not exists(select null from sys.fulltext_stoplists where stoplist_Id=@stopListId) begin
		PRINT N'spGetFullTextWordsExcludeNoiseWords.sql - StopListId: ' + cast(@stopListId as varchar) + ' does not exists.'
		return
	end
	
	set @paramlist = '@termText nvarchar(4000), @Lcid int, @stopListId int, @accentSensitive bit'
	select @sql = N'SELECT * FROM sys.dm_fts_parser ( @termText, @Lcid, @stopListId, @accentSensitive ) where special_term != ''Noise Word'''
	
	EXEC sp_executesql @sql, @paramlist, @termText, @Lcid, @stopListId, @accentSensitive
end 