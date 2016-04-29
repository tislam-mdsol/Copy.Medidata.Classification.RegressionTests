/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spMedDictTermSearchSynonymsPaged')
	DROP PROCEDURE dbo.spMedDictTermSearchSynonymsPaged
GO
Create PROCEDURE [dbo].[spMedDictTermSearchSynonymsPaged]
(	
	@dictionaryId INT, 
	@versionOrdinal INT, 
	@locale CHAR(3), 
	@statusId INT, 
	@searchString VARCHAR(100), 
	@pageSize INT, 
	@pageNumber INT, 
	@SortExpression varchar(50),
	@SortOrder tinyint = 1, --ASC
	@Count int output, --Return the total count for first time execution, and then use the same for the subsequent executions
	@segmentId INT
)
AS

	DECLARE @ignoreSearchString BIT

	IF (@SearchString is null OR Len(@SearchString) = 0) SET @ignoreSearchString = 1
	ELSE SET @ignoreSearchString = 0

	BEGIN TRY

	IF (@Locale = 'eng')
	BEGIN

		SELECT @Count = COUNT(*)
		FROM MedicalDictionaryTerm
		WHERE MedicalDictionaryId = @DictionaryId
			AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
			AND TERM_ENG <> ''
			AND SegmentId = @SegmentId
			AND (TermStatus = @StatusId OR @StatusId = -1)
			AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
			AND (@ignoreSearchString = 1 OR (Term_ENG like N'%' + @SearchString + N'%'))
		
		-- check whether the page requested is valid for the count
		IF (@Count < @pageSize * @pageNumber) 
			SET @pageNumber = @Count / @pageSize;
		
		WITH SQLPaging
		AS
		(
			SELECT *
			FROM MedicalDictionaryTerm
			WHERE MedicalDictionaryId = @DictionaryId
				AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
				AND TERM_ENG <> ''
				AND SegmentId = @SegmentId
				AND (TermStatus = @StatusId OR @StatusId = -1)
				AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
				AND (@ignoreSearchString = 1 OR (Term_ENG like N'%' + @SearchString + N'%'))
		)
		
		SELECT * FROM 
			(SELECT  ROW_NUMBER() OVER 
			(ORDER BY case when @SortExpression='TermLiteral' and @SortOrder=1 then TERM_ENG end asc,
			case when @SortExpression='TermLiteral' and @SortOrder=2 then TERM_ENG end desc,
			case when @SortExpression='TermStatus' and @SortOrder=1 then TermStatus end asc,
			case when @SortExpression='TermStatus' and @SortOrder=2 then TermStatus end desc
			) 
		AS Row,  TS.*  FROM SQLPaging TS) AS SynonymsWithRowNumbers
			WHERE  Row BETWEEN (@PageNumber) * @PageSize + 1 AND (@PageNumber+1)*@PageSize
		
	END
	ELSE IF (@Locale = 'jpn')
	BEGIN

		SELECT @Count = COUNT(*)
		FROM MedicalDictionaryTerm
		WHERE MedicalDictionaryId = @DictionaryId
			AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
			AND TERM_JPN <> ''
			AND SegmentId = @SegmentId
			AND (TermStatus = @StatusId OR @StatusId = -1)
			AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
			AND (@ignoreSearchString = 1 OR (Term_JPN like N'%' + @SearchString + N'%'))

		-- check whether the page requested is valid for the count
		IF (@Count < @pageSize * @pageNumber) 
			SET @pageNumber = @Count / @pageSize;
		

		WITH SQLPaging
		AS
		(
			SELECT *
			FROM MedicalDictionaryTerm
			WHERE MedicalDictionaryId = @DictionaryId
				AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
				AND TERM_JPN <> ''
				AND SegmentId = @SegmentId
				AND (TermStatus = @StatusId OR @StatusId = -1)
				AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
				AND (@ignoreSearchString = 1 OR (TERM_JPN like N'%' + @SearchString + N'%'))
		)
		
		SELECT * FROM 
			(SELECT ROW_NUMBER() OVER 
			(ORDER BY case when @SortExpression='TermLiteral' and @SortOrder=1 then TERM_JPN end asc,
			case when @SortExpression='TermLiteral' and @SortOrder=2 then TERM_JPN end desc,
			case when @SortExpression='TermStatus' and @SortOrder=1 then TermStatus end asc,
			case when @SortExpression='TermStatus' and @SortOrder=2 then TermStatus end desc
			) 
		AS Row,  TS.*  FROM SQLPaging TS) AS SynonymsWithRowNumbers
			WHERE  Row BETWEEN (@PageNumber) * @PageSize + 1 AND (@PageNumber+1)*@PageSize

	END
	ELSE IF (@Locale = 'loc')
	BEGIN

		SELECT @Count = COUNT(*)
		FROM MedicalDictionaryTerm
		WHERE MedicalDictionaryID = @DictionaryId
			AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
			AND TERM_LOC <> ''
			AND SegmentId = @SegmentId
			AND (TermStatus = @StatusId OR @StatusId = -1)
			AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
			AND (@ignoreSearchString = 1 OR (Term_LOC like N'%' + @SearchString + N'%'))

		-- check whether the page requested is valid for the count
		IF (@Count < @pageSize * @pageNumber) 
			SET @pageNumber = @Count / @pageSize;

		WITH SQLPaging
		AS
		(
			SELECT *
			FROM MedicalDictionaryTerm
			WHERE MedicalDictionaryId = @DictionaryId
				AND MasterTermId > 0 AND TermType IN (0,3) -- only synonyms
				AND TERM_LOC <> ''
				AND SegmentId = @SegmentId
				AND (TermStatus = @StatusId OR @StatusId = -1)
				AND @VersionOrdinal BETWEEN FromVersionOrdinal AND ToVersionOrdinal
				AND (@ignoreSearchString = 1 OR (TERM_LOC like N'%' + @SearchString + N'%'))
		)
		
		SELECT * FROM 
			(SELECT  ROW_NUMBER() OVER 
			(ORDER BY case when @SortExpression='TermLiteral' and @SortOrder=1 then Term_LOC end asc,
			case when @SortExpression='TermLiteral' and @SortOrder=2 then Term_LOC end desc,
			case when @SortExpression='TermStatus' and @SortOrder=1 then TermStatus end asc,
			case when @SortExpression='TermStatus' and @SortOrder=2 then TermStatus end desc
			) 
		AS Row,  TS.*  FROM SQLPaging TS) AS SynonymsWithRowNumbers
			WHERE  Row BETWEEN (@PageNumber) * @PageSize + 1 AND (@PageNumber+1)*@PageSize
			
	END

	END try
	
	BEGIN catch
		
		DECLARE	@ErrorSeverity int, 
				@ErrorState int,
				@ErrorLine int,
				@ErrorMessage nvarchar(4000),
				@ErrorProc nvarchar(4000)

		SELECT @ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorLine = ERROR_LINE(),
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorProc = ERROR_PROCEDURE()
		SELECT @ErrorMessage = coalesce(@ErrorProc, 'spMedDictTermSearchSynonymsPaged.sql') + ' in Locale:[' + @Locale + ' (' + cast(@ErrorLine as nvarchar) + '): ' + @ErrorMessage
		-- TODO : LOG information instead of throwing error
		--raiserror (@ErrorMessage,  @ErrorSeverity, @ErrorState);
	END catch