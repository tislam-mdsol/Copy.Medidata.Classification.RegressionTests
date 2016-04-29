/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGroupVerbatimJpnInsert')
	DROP PROCEDURE spGroupVerbatimJpnInsert
GO

CREATE PROCEDURE dbo.spGroupVerbatimJpnInsert 
(
	@GroupVerbatimId INT OUTPUT,  
	@VerbatimText NVARCHAR(450),	
	@Created DATETIME OUTPUT
)  
AS  
  
BEGIN  

	SET @Created = GETUTCDATE()  

	--from http://stackoverflow.com/questions/3407857/only-inserting-a-row-if-its-not-already-there
	INSERT INTO dbo.GroupVerbatimJpn 
	SELECT
		@VerbatimText,
		@Created
	 WHERE
		NOT EXISTS
		(SELECT NULL FROM dbo.GroupVerbatimJpn WITH (UPDLOCK, HOLDLOCK)
		WHERE VerbatimText=@VerbatimText)
	 
	 SELECT @GroupVerbatimId = gv.GroupVerbatimID
		, @Created = gv.Created
	 FROM dbo.GroupVerbatimJpn as gv
	 WHERE VerbatimText=@VerbatimText
END	   

GO   