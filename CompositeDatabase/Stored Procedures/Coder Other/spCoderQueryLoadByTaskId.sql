﻿/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2013, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Bonnie Pan bpan@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCoderQueryLoadByTaskId')
	DROP PROCEDURE spCoderQueryLoadByTaskId
GO

CREATE PROCEDURE dbo.spCoderQueryLoadByTaskId
(
	@CodingElementId INT,
	@maxNumber INT
)  
AS  
BEGIN 

    SELECT TOP (@maxNumber) *
	FROM CoderQueries
	WHERE CodingElementId = @CodingElementId
	ORDER BY QueryId Desc 

END
GO
   