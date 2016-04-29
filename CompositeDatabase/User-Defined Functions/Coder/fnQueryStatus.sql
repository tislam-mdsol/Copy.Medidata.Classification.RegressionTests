
if exists (select * from sysobjects where name = 'fnQueryStatus')
	drop function fnQueryStatus
go

CREATE function [dbo].[fnQueryStatus](@statusId int)
returns varchar(20)
begin --fnQueryStatus
	return(case @statusId
		when 0 then 'None'
		when 1 then 'Queued'
		when 2 then 'Open'
		when 3 then 'Answered'
		when 4 then 'Cancelled'
		when 5 then 'Closed'
		else rtrim(cast(@statusId as varchar(4)))
		end)--case
end --fnQueryStatus
go

 
 