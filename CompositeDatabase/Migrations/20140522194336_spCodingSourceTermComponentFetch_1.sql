/** $Workfile: spMedicalDictionaryTermComponentSearch.sql $
**
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

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingSourceTermComponentFetch')
	DROP PROCEDURE dbo.spCodingSourceTermComponentFetch
GO
  
CREATE PROCEDURE dbo.spCodingSourceTermComponentFetch (@SourceTermComponentID bigint)  
AS  
  
BEGIN  
 SELECT *  
 FROM dbo.CodingSourceTermComponents  
 WHERE SourceTermComponentID = @SourceTermComponentID  
END  
  
GO

/**
** Revision History:
** $Log:  $
** 
** 
** $Header: $
** $Workfile: $
**/ 
 