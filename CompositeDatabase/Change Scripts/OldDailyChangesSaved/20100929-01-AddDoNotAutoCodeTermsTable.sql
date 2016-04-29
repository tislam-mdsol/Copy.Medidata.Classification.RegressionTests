/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Donghan (Jarod) Wang dwang@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF (NOT EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_NAME = 'DoNotAutoCodeTerms'))
BEGIN
	CREATE TABLE [dbo].[DoNotAutoCodeTerms](
		[DoNotAutoCodeTermId]	INT IDENTITY(1,1) NOT NULL,
		
		-- Dictionary References
		[MedicalDictionaryId]	SMALLINT NOT NULL,
		[Locale]				CHAR(3) NOT NULL,
		[DictionaryVersionId]	INT NOT NULL,
		
		-- Term References
		[TermId]				INT NOT NULL,
		[Term]					NVARCHAR(500) NOT NULL,
		[DictionaryLevelId]		INT NOT NULL,
		
		-- Term spesific Properties
		[Active]				BIT NOT NULL,
		[UserId]				INT NOT NULL,
		[SegmentId]				INT NOT NULL,
		[Created] [datetime]	NOT NULL CONSTRAINT DF_DoNotAutoCodeTerms_Created DEFAULT (GETUTCDATE()),
		[Updated] [datetime]	NOT NULL CONSTRAINT DF_DoNotAutoCodeTerms_Updated DEFAULT (GETUTCDATE()),
		
	)
	
	-- Foreign Constraints
	ALTER TABLE [dbo].[DoNotAutoCodeTerms]  WITH CHECK ADD
		CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionary] FOREIGN KEY([MedicalDictionaryId])
			REFERENCES [dbo].[MedicalDictionary] ([MedicalDictionaryId]),
		CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryVersion] FOREIGN KEY([DictionaryVersionId])
			REFERENCES [dbo].[MedicalDictionaryVersion] ([DictionaryVersionId]),
		CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryLevel] FOREIGN KEY([DictionaryLevelId])
			REFERENCES [dbo].[MedicalDictionaryLevel] ([DictionaryLevelId]),
		CONSTRAINT [FK_DoNotAutoCodeTerms_Users] FOREIGN KEY([UserId])
			REFERENCES [dbo].[Users] ([UserID]),
		CONSTRAINT [FK_DoNotAutoCodeTerms_Segments] FOREIGN KEY([SegmentId])
			REFERENCES [dbo].[Segments] ([SegmentId]),
		CONSTRAINT [FK_DoNotAutoCodeTerms_MedicalDictionaryTerm] FOREIGN KEY([TermId])
			REFERENCES [dbo].[MedicalDictionaryTerm] ([TermId])

	-- Default Constraints
	ALTER TABLE [dbo].[DoNotAutoCodeTerms] ADD CONSTRAINT [DF_DoNotAutoCodeTerms_Active] DEFAULT ((1)) FOR [Active]

	-- Unique Constraints
	-- A conditional unique constraints
	CREATE UNIQUE NONCLUSTERED INDEX [UIX_DoNotAutoCodeTerms_SinglePerTerm] 
	ON [dbo].[DoNotAutoCodeTerms] 
	(
		MedicalDictionaryID ASC,
		DictionaryVersionID ASC,
		TermID ASC,
		Locale ASC,
		SegmentID ASC
	)
	WHERE (Active=1)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	
END
GO
