if Object_Id('spSgmntsLdAll') is not null
	drop procedure spSgmntsLdAll
go
create procedure spSgmntsLdAll
as
begin
	select * from Segments
end
go
