/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2014, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com
//
// ------------------------------------------------------------------------------------------------------*/

-- EXEC spCheckStudySync 'Mediflexs1 (Dev)', '7ffc5882-a328-11e0-9761-1231381b4ca1'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckStudySync')
	DROP PROCEDURE spCheckStudySync
GO

CREATE PROCEDURE dbo.spCheckStudySync
(
	@StudyName NVARCHAR(50),
	@IMedidataId VARCHAR(50)
)
AS 
BEGIN

	SELECT 'Studies Matching Name', TOS.TrackableObjectID, TOS.ExternalObjectName, TOS.ExternalObjectId, S.SegmentName
	FROM TrackableObjects TOS
		JOIN Segments S
			ON TOS.SegmentID = S.SegmentID
	WHERE TOS.ExternalObjectName = @StudyName

	SELECT 'Studies Matching ImedidataID', TOS.TrackableObjectID, TOS.ExternalObjectName, TOS.ExternalObjectId, S.SegmentName
	FROM TrackableObjects TOS
		JOIN Segments S
			ON TOS.SegmentID = S.SegmentID
	WHERE TOS.ExternalObjectId = @IMedidataId

END
