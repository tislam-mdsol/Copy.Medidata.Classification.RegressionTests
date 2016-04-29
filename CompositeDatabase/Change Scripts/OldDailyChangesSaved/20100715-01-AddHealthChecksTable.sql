/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Donghan Wang dwang@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

-- Create table
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'HealthChecksR'
		 )

CREATE TABLE HealthChecksR (
	HealthCheckID BIGINT IDENTITY(1,1) NOT NULL,
	SP_Detect VARCHAR(256) NOT NULL,
	SP_Fix VARCHAR(256) NOT NULL,
	Description VARCHAR(256) NOT NULL UNIQUE,
	IsValid BIT NOT NULL constraint DF_HealthChecks_IsValid  default(1),
	CONSTRAINT PK_HealthChecks_HealthCheckID PRIMARY KEY CLUSTERED (HealthCheckID ASC)
)


IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'HealthCheckRuns'
		 )

CREATE TABLE HealthCheckRuns (
	HealthCheckRunID BIGINT IDENTITY(1,1) NOT NULL,
	HealthCheckID BIGINT NOT NULL,
	Created DATETIME NOT NULL CONSTRAINT DF_HealthCheckRuns_Created DEFAULT (GETUTCDATE()),
	TimeEnded DATETIME NOT NULL CONSTRAINT DF_HealthCheckRuns_TimeEnded DEFAULT (GETUTCDATE()),
	CONSTRAINT PK_HealthCheckRuns_HealthCheckRunID PRIMARY KEY CLUSTERED (HealthCheckRunID ASC),
	CONSTRAINT FK_HealthCheckRuns_HealthCheckID FOREIGN KEY(HealthCheckID) references HealthChecksR (HealthCheckID)
)

-- Create table
IF NOT EXISTS 
	(SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'HealthCheckStatistics'
		 )
CREATE TABLE HealthCheckStatistics (
	HealthCheckStatisticsID BIGINT IDENTITY(1,1) not null,
	HealthCheckRunID BIGINT NOT NULL,
	SegmentID INT not null,
	ErrorCount INT not null,
	Created DATETIME not null CONSTRAINT DF_HealthCheckStatistics_Created DEFAULT getutcdate(),
	Updated DATETIME not null CONSTRAINT DF_HealthCheckStatistics_Updated DEFAULT getutcdate(),
	CONSTRAINT PK_HealthCheckStatistics_HealthCheckStatistics primary key clustered (HealthCheckStatisticsID ASC),
	CONSTRAINT FK_HealthCheckStatistics_HealthCheckRunID FOREIGN KEY(HealthCheckRunID) references HealthCheckRuns (HealthCheckRunID)
)


