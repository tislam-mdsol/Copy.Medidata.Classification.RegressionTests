--/** $Workfile: spCodingSourceTermFetch.sql $
--**
--** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
--**
--** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
--** this file may not be disclosed to third parties, copied or duplicated in 
--** any form, in whole or in part, without the prior written permission of
--** Medidata Solutions, Inc.
--**
--** Author: Mark Hwe [mhwe@mdsol.com]
--**
--** Complete history on bottom of file
--**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermFetch')
	DROP PROCEDURE spCodingSourceTermFetch
GO

--CREATE PROCEDURE dbo.spCodingSourceTermFetch (@CodingSourceTermId bigint,
--	@SegmentID INT)
--AS

--BEGIN
--	SELECT *
--	FROM dbo.CodingSourceTerms
--	WHERE CodingSourceTermId = @CodingSourceTermId
--END

--GO
 