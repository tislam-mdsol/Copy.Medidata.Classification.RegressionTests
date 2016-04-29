/** $Workfile: spTrackableObjectsLoad.sql $
**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
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

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spTrackableObjectsLoad')
	DROP PROCEDURE dbo.spTrackableObjectsLoad
GO

create procedure dbo.spTrackableObjectsLoad
as
begin
	select * from TrackableObjects
end
GO