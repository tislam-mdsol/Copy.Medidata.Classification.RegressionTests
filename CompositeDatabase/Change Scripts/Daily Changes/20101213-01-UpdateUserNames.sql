
-- update user's FirstName field to hold both First Name and Last Name
UPDATE U 
	SET FirstName = FirstName + ' ' + LastName,
		LastName = 'User'
FROM Users U
WHERE LastName <> 'User' -- dummy value inserted by parser; indicates row has already been updated
GO
 