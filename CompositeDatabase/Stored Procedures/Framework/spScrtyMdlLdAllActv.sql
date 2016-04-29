/*
** Copyright(c) 2006, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Bernardo Pontes (BPontes@mdsol.com)
**/

-- WORK IN PROGRESS

if object_id('spScrtyMdlLdAllActv') is not null
	drop procedure spScrtyMdlLdAllActv
go

create procedure spScrtyMdlLdAllActv
as
begin
	select * from modulesr where Active = 1
end