
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[developer].[spVersionDifferencePostProcessingV1_1]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [developer].[spVersionDifferencePostProcessingV1_1]
GO
