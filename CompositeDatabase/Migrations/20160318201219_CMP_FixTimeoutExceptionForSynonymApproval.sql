IF EXISTS ( SELECT  *
            FROM    sys.indexes
            WHERE   name = 'IX_SegmentedGroupCodingPatterns_ForSynonymApproval'
                    And object_id = Object_ID('SegmentedGroupCodingPatterns')) 
    Drop Index [SegmentedGroupCodingPatterns].[IX_SegmentedGroupCodingPatterns_ForSynonymApproval]

GO

CREATE NONCLUSTERED INDEX [IX_SegmentedGroupCodingPatterns_ForSynonymApproval]
ON [dbo].[SegmentedGroupCodingPatterns] ([SynonymManagementID],[SynonymStatus],[Updated])
INCLUDE ([SegmentedGroupCodingPatternID],[CodingElementGroupID])