IF EXISTS (SELECT null FROM SYSOBJECTS WHERE type = 'P' AND name = 'spCodingAssignmentLoadByCodingElementId')
	DROP PROCEDURE dbo.spCodingAssignmentLoadByCodingElementId
GO

CREATE PROCEDURE dbo.spCodingAssignmentLoadByCodingElementId 
(
	@codingElementID bigint
)
AS
BEGIN
                                                                                                       
	select * 
	from CodingAssignment 
	where CodingElementID=@codingElementID 
	order by CodingAssignmentId desc

END
GO
