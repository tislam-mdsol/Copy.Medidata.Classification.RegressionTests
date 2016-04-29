 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- Workflow Localization

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTranslateLocalizationDataStrings')
	DROP PROCEDURE dbo.[spTranslateLocalizationDataStrings]
GO
CREATE procedure [dbo].[spTranslateLocalizationDataStrings]
	@SourceString nvarchar(4000),
	@TargetString nvarchar(4000),
	@SourceLocale varchar(3) ,
	@TargetLocale varchar(3),
	@SegmentId int,
	@StringID int output 
AS

declare @Count int, @Err varchar(100)
set @StringId = null
--search the string

	if not exists(select null from Localizations where Locale = @TargetLocale) 
	begin		
		--set @StringID = 0
		--set @Err = 'Locale "' + @TargetLocale + '" does not exist in the system'        
		--set @Err = 'Locale does not exist in the system' 
		--raiserror (@Err, 16, 1)        
		return
	end
	
	if not exists(select null from Localizations where Locale = @SourceLocale) 
	begin		
		set @StringID = 0
		set @Err = 'Locale "' + @SourceLocale + '" does not exist in the system'        
		raiserror (@Err, 16, 1)        
		return
	end
	else
	begin
	select @StringId = StringId from LocalizedDataStrings 
	where String = @SourceString and Locale = @SourceLocale and SegmentId = @SegmentId
	--if found 
	if (@StringId is not null)
		begin  --insert the string
		if not exists(Select null from LocalizedDataStrings where StringID = @StringID and SegmentID = @SegmentId and Locale = @TargetLocale)
		begin
			insert LocalizedDataStrings(
				StringID,
				String,
				Locale,
				TranslationStatus,
				SegmentID)
			Values 
				(@StringID,
				@TargetString, 
				@TargetLocale,
				2,
				@SegmentId)
		end	
		else
		begin
			Update LocalizedDataStrings
				set String = @TargetString				
			where StringID = @StringID and SegmentID = @SegmentId and Locale = @TargetLocale
		end
	end
end
GO

-- 1) Localize workflow for existing segments
-- i) Write change script for LOC
-- ii) Write change script for JPN 


declare @StringID int, @Locale char(3), @TargetSegmentID int

declare curSegments cursor for  
select SegmentID from Segments   
    
open curSegments  
fetch curSegments into @TargetSegmentID 
while (@@FETCH_STATUS = 0) 
begin      
	-- i) Change script for LOC
	
	-- Workflows
	exec [spTranslateLocalizationDataStrings] 'DEFAULT','LDEFAULT' ,'eng','loc', @TargetSegmentID, null

	-- Workflow Actions
	exec [spTranslateLocalizationDataStrings] 'Add Comment', 'LAdd Comment' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Approve', 'LApprove' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Code', 'LCode' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Leave As Is', 'LLeave As Is' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Recode',  'Recode','eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reconsider', 'Reconsider','eng', 'loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reject Coding Decision', 'LReject Coding Decision', 'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Open Query', 'LOpen Query' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reclassify', 'LReclassify' ,'eng','loc', @TargetSegmentID, null

	-- Workflow States
	exec [spTranslateLocalizationDataStrings] 'Start', 'LStart' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Manual Code', 'LWaiting Manual Code' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Approval', 'LWaiting Approval', 'eng','loc',@TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Transmission', 'LWaiting Transmission', 'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Completed', 'LCompleted','eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reconsider', 'LReconsider','eng', 'loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Start Auto Code', 'LStart Auto Code' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Retry Auto Code', 'LRetry Auto Code' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'AutoApproveInternal', 'LAutoApproveInternal' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Transmit', 'LTransmit' ,'eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'CompleteWithoutTransmission', 'LCompleteWithoutTransmission', 'eng','loc', @TargetSegmentID, null


	-- Browser Templates

	exec [spTranslateLocalizationDataStrings] 'Low to High', 'LLow to High','eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'High to Low',	'LHigh to Low','eng', 'loc', @TargetSegmentID, null

	exec [spTranslateLocalizationDataStrings] 'SOC-PT-LLT', 'LSOC-PT-LLT','eng','loc', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'LLT-PT-SOC', 'LLLT-PT-SOC', 'eng','loc', @TargetSegmentID, null

	-- ii) Change script for JPN

	-- Workflows
	exec [spTranslateLocalizationDataStrings] 'DEFAULT',N'デフォルト' ,'eng','jpn', @TargetSegmentID, null

	-- Workflow Actions
	exec [spTranslateLocalizationDataStrings] 'Add Comment', N'コメントを追加' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Approve', N'承認' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Code', N'コーディング' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Leave As Is', N'現在の選択を採用' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Recode',  N'再コーディング','eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reconsider', N'再検討','eng', 'jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reject Coding Decision', N'コーディング選択却下','eng', 'jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Open Query', N'クエリを発行','eng','jpn', @TargetSegmentID, null	
	exec [spTranslateLocalizationDataStrings] 'Start Auto Code', N'自動コーディング開始' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Retry Auto Code', N'自動コーディング再試行' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'AutoApproveInternal', N'内部自動承認' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Transmit', N'送信' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'CompleteWithoutTransmission', N'送信せずに完了', 'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reclassify', N'再分類', 'eng','jpn', @TargetSegmentID, null

	-- Workflow States
	exec [spTranslateLocalizationDataStrings] 'Start', N'開始' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Manual Code', N'マニュアルコーディング待ち' ,'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Approval', N'承認待ち','eng','jpn' ,@TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Waiting Transmission', N'送信待ち', 'eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Completed', N'完了','eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'Reconsider', N'再検討','eng', 'jpn', @TargetSegmentID, null

	-- Browser Templates

	exec [spTranslateLocalizationDataStrings] 'Low to High', N'昇順','eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'High to Low', N'降順','eng', 'jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'SOC-PT-LLT', N'SOC-PT-LLT','eng','jpn', @TargetSegmentID, null
	exec [spTranslateLocalizationDataStrings] 'LLT-PT-SOC', N'LLT-PT-SOC','eng', 'jpn', @TargetSegmentID, null

 
fetch curSegments into @TargetSegmentID 
end  
close curSegments  
deallocate curSegments 

DROP PROCEDURE dbo.[spTranslateLocalizationDataStrings] 


----------------**************************** THE END ********************************----------------------------------

