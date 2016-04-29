/**
** Copyright(c) 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin [juddin@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingElementUpdate')
	DROP PROCEDURE dbo.spCodingElementUpdate
GO
  
CREATE PROCEDURE dbo.spCodingElementUpdate (  
 @CodingElementID bigint,  
 
 -- state control
 @CacheVersion BIGINT,
 @NewCacheVersion BIGINT,
 @WasUpdated BIT OUTPUT,
 @CodingElementGroupID BIGINT,
 @StudyDictionaryVersionId int,
 @DictionaryLevelId INT,
 @VerbatimTerm nvarchar(500),
 @SourceSystemId int,
 @CodingRequestId bigint,
 @IsCompleted bit,  
 @IsClosed bit,
 @CompletionDate datetime,  
 @IsAutoCodeRequired bit,  
 @AutoCodeDate datetime,  
 @SearchType int,
 @SourceIdentifier NVARCHAR(100),
 @IsStillInService BIT, 
 @WorkflowStateId SMALLINT,
 @AssignedSegmentedGroupCodingPatternId INT,
 @Priority TINYINT,
 @AssignedTermText NVARCHAR(900),
 @AssignedTermCode NVARCHAR(100),
 @AssignedCodingPath NVARCHAR(100),
 @SourceField NVARCHAR(450),
 @SourceForm NVARCHAR(450),
 @SourceSubject NVARCHAR(100),
 @IsInvalidTask BIT,
 @AssignedTermKey NVARCHAR(100), 
 @Created datetime,  
 @Updated datetime output,
 @UUID NVARCHAR(100),
 @CodingContextURI NVARCHAR(4000),
 @QueryStatus TINYINT,
 @UpdatedTimeStamp BIGINT,
 @MarkingGroup NVARCHAR(450),
 @BatchOID NVARCHAR(450)
)  
AS  
BEGIN

 DECLARE @UtcDate DateTime  
 SET @UtcDate = GetUtcDate()  
 SET @Updated = @UtcDate
 
 UPDATE dbo.CodingElements SET  
  CacheVersion                          = @NewCacheVersion,
  StudyDictionaryVersionId              = @StudyDictionaryVersionId,
  DictionaryLevelId						= @DictionaryLevelId,
  
  IsCompleted                           = @IsCompleted,  
  IsClosed                              = @IsClosed,  
  CompletionDate                        = @CompletionDate,  
  IsAutoCodeRequired                    = @IsAutoCodeRequired,  
  AutoCodeDate                          = @AutoCodeDate,  
  IsStillInService                      = @IsStillInService,
  WorkflowStateId                       = @WorkflowStateId,
  AssignedSegmentedGroupCodingPatternId = @AssignedSegmentedGroupCodingPatternId,
  AssignedTermText                      = @AssignedTermText,
  
  AssignedTermCode                      = @AssignedTermCode,
  AssignedCodingPath                    = @AssignedCodingPath,
  IsInvalidTask                         = @IsInvalidTask,
  
  AssignedTermKey                       = @AssignedTermKey,
  Updated                               = @UtcDate,
  UUID                                  = @UUID,
  CodingContextURI                      = @CodingContextURI,
  UpdatedTimeStamp                      = @UpdatedTimeStamp,

  VerbatimTerm                          = @VerbatimTerm,
  CodingRequestId                       = @CodingRequestId,
  CodingElementGroupID                  = @CodingElementGroupID,
  Priority                              = @Priority,

  QueryStatus                           = @QueryStatus,
  MarkingGroup                          = @MarkingGroup,
  BatchOID                              = @BatchOID
  -- The following are immutable properties
  --SourceSystemId = @SourceSystemId,
  --SourceField = @SourceField,
  --SourceForm = @SourceForm,
  --SourceSubject = @SourceSubject,
  --SearchType = @SearchType,
  --SourceIdentifier = @SourceIdentifier,
  --Created = Created

 WHERE CodingElementID = @CodingElementID
	AND CacheVersion = @CacheVersion
	
 -- check if we updated
 IF (@@ROWCOUNT = 0)
	SET @WasUpdated = 0
 ELSE
	SET @WasUpdated = 1
 
END  
  
GO
