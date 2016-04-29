 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- obsolete

--IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingAssignmentGetByCreatedSynonym')
--	DROP PROCEDURE spCodingAssignmentGetByCreatedSynonym
--GO
--CREATE PROCEDURE dbo.spCodingAssignmentGetByCreatedSynonym(@synonymTermId BIGINT,
--	@SegmentID INT)
--AS
--	SELECT * 
--	FROM CodingAssignment 
--	WHERE SynonymTermId = @synonymTermId
--GO 
