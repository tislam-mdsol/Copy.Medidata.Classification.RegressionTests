CREATE TABLE [dbo].[WorkflowRunnerServiceHeartBeat](
	[WorkflowRunnerServiceHeartBeatID] [bigint] IDENTITY(1,1) NOT NULL,
	[QueueSize] [int] NOT NULL,
    LastCPULoad [int] NOT NULL,

    TotalRequests [int] NOT NULL,
    TotalTasks [int] NOT NULL,
    TotalCPUBlocks [int] NOT NULL,
    TotalThreadPoolBlocks [int] NOT NULL,
    ConcurrentThreads [int] NOT NULL,
    IsMainThreadAlive BIT NOT NULL,
	[Created] [datetime] NOT NULL,
	[Updated] [datetime] NOT NULL,
 CONSTRAINT [PK_WorkflowRunnerServiceHeartBeat] PRIMARY KEY CLUSTERED 
(
	[WorkflowRunnerServiceHeartBeatID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO 

ALTER TABLE [dbo].[WorkflowRunnerServiceHeartBeat] 
ADD  CONSTRAINT [DF_WorkflowRunnerServiceHeartBeat_Created]  DEFAULT (getutcdate()) FOR [Created]
GO

ALTER TABLE [dbo].[WorkflowRunnerServiceHeartBeat]
ADD  CONSTRAINT [DF_WorkflowRunnerServiceHeartBeat_Updated]  DEFAULT (getutcdate()) FOR [Updated]
GO
