/** 
** Copyright(c) 2009, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Debbie Silberberg  dsilberberg@mdsol.com
**/

if object_id('spLclztnRfrncsBlkSv') is not null
	drop procedure spLclztnRfrncsBlkSv
go

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'LocalizationRefT')
	DROP TYPE LocalizationRefT

GO

CREATE TYPE dbo.LocalizationRefT AS TABLE(
	StringId int NOT NULL,
	PropertyName nvarchar(255) NOT NULL,
	ObjectTypeID int NOT NULL,
	ObjectID int NOT NULL)
	
if object_id('spLclztnDtStrngBlkSv') is not null
	drop procedure spLclztnDtStrngBlkSv
go

IF EXISTS (SELECT 1 FROM SYS.TYPES WHERE NAME = 'LocalizationDataStringT')
	DROP TYPE LocalizationDataStringT

GO

CREATE TYPE dbo.LocalizationDataStringT AS TABLE(
	StringId int NULL,
	String nVARCHAR(4000) NULL,
	Locale nVARCHAR(3) NOT NULL,
	ObjectTypeID int NOT NULL,
	ObjectID int NOT NULL, 
	SegmentId int NOT NULL)	 
GO