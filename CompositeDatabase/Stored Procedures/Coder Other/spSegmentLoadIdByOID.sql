
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

IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spSegmentLoadIdByOID')
	DROP PROCEDURE dbo.spSegmentLoadIdByOID
GO

CREATE procedure [dbo].[spSegmentLoadIdByOID](@OID varchar(50))
as
begin
	declare @SegmentID int
	select @SegmentID = SegmentID from Segments where OID = @OID
	select coalesce(@SegmentID, 0)
end
