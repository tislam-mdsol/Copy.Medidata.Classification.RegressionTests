 --used to create admin user login through change script run on deployed DB
update Users
set Login = 'coderadmin', Email = 'medidatacoder+admin@gmail.com', IMedidataId = 'b6b7a4a6-6081-11e0-ac61-1231390e6521'
where UserID = 2