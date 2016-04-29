 /*
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
S** Medidata Solutions, Inc.
**
** Author: Mark Hwe [mhwe@mdsol.com]
**/ 

SET NOCOUNT ON
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnHasSynonyms')
	DROP FUNCTION dbo.fnHasSynonyms
GO
CREATE FUNCTION dbo.fnHasSynonyms
(
	@TermID bigint,
	@VersionOrdinal INT
) RETURNS bit
AS
BEGIN
	DECLARE @SynonymExists bit
	select @SynonymExists = case when exists(
		select null from MedicalDictionaryTerm
		where MasterTermId = @TermID and @VersionOrdinal between FromVersionOrdinal and ToVersionOrdinal
	) then 1 else 0 end

	RETURN @SynonymExists
END
GO

SET NOCOUNT OFF
GO
