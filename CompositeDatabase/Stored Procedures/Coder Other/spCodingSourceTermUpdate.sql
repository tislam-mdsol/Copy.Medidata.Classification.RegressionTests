--/** $Workfile: spMedicalDictionaryTermComponentSearch.sql $
--**
--** Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
--**
--** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
--** this file may not be disclosed to third parties, copied or duplicated in 
--** any form, in whole or in part, without the prior written permission of
--** Medidata Solutions, Inc.
--**
--** Author: Jalal Uddin [juddin@mdsol.com]
--**
--** Complete history on bottom of file
--**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermUpdate')
	DROP PROCEDURE dbo.spCodingSourceTermUpdate
GO

--CREATE PROCEDURE dbo.spCodingSourceTermUpdate (
--	@CodingSourceTermId bigint,
--	@CodingElementId bigint,
--	@TrackableObjectId bigint,
--	@SourceSystemId int,
--	@ExternalID nvarchar(100),
--	@CodingSourceAlgorithmID int,
--	@DictionaryVersionId int,
--	@DictionaryLevelId int,
--	@DictionaryLocale char(3),
--	@Term nvarchar(510),
--	@TermLevel nvarchar(100),
--	@Priority int,
--	@IsAutoCode bit,
--	@IsProductionData bit,
--	@IsAddToKnowledgeBase bit,
--	@SubmissionDate datetime,
--	@Created datetime,  
--	@Updated datetime output,
--	@SegmentId int
--)
--AS  
  
--BEGIN  
-- DECLARE @UtcDate DateTime  
-- SET @UtcDate = GetUtcDate()  
-- SET @Updated = @UtcDate  
  
-- UPDATE dbo.CodingSourceTerms SET  
--  CodingElementID = @CodingElementID, 
--  TrackableObjectId = @TrackableObjectId,
--  SourceSystemId = @SourceSystemId,
--  ExternalID = @ExternalID,
--  SegmentId = @SegmentId,
--  CodingSourceAlgorithmID = @CodingSourceAlgorithmID,
--  DictionaryVersionId = @DictionaryVersionId,
--  DictionaryLevelId = @DictionaryLevelId,
--  DictionaryLocale = @DictionaryLocale,
--  Term = @Term,  
--  TermLevel = @TermLevel,  
--  Priority = @Priority,  
--  IsAutoCode = @IsAutoCode,  
--  IsProductionData = @IsProductionData,  
--  IsAddToKnowledgeBase = @IsAddToKnowledgeBase, 
--  SubmissionDate = @SubmissionDate,   
--  Created = Created, 
--  Updated = @UtcDate  
-- WHERE CodingSourceTermID = @CodingSourceTermID  
--END  
--GO
