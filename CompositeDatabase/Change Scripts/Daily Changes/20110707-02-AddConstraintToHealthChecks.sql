IF NOT EXISTS (SELECT NULL
	FROM sys.default_constraints
	WHERE name = 'DF_HealthCheckStatistics_Updated')
	ALTER TABLE [dbo].[HealthCheckStatistics] 
	ADD  CONSTRAINT [DF_HealthCheckStatistics_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO 

IF NOT EXISTS (SELECT NULL
	FROM sys.default_constraints
	WHERE name = 'DF_HealthCheckRuns_Updated')
	ALTER TABLE [dbo].[HealthCheckRuns] 
	ADD  CONSTRAINT [DF_HealthCheckRuns_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO 