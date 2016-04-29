IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnMinimum')
BEGIN
	DROP FUNCTION dbo.[fnMinimum]
END
GO
CREATE FUNCTION [dbo].[fnMinimum] 
(
	@p1 decimal(10,2),
	@p2 decimal(10,2)
)
RETURNS decimal(10,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal(10,2)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = @p1
	if(@p2 < @p1) set @Result=@p2

	-- Return the result of the function
	RETURN @Result

END
GO