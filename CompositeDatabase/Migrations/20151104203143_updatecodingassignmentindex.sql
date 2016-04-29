IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CodingAssignment]') AND name = N'Ix_CodingAssignment_CodingElementID')
DROP INDEX [Ix_CodingAssignment_CodingElementID] ON [dbo].[CodingAssignment] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [Ix_CodingAssignment_CodingElementID]    Script Date: 11/04/2015 20:19:01 ******/
CREATE NONCLUSTERED INDEX [Ix_CodingAssignment_CodingElementID] ON [dbo].[CodingAssignment] 
(
[CodingElementID] ASC
)
INCLUDE ( [Active]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO