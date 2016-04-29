/** $Workfile: spCreateCoderAdminLogin.sql $
**
** Copyright(c) 2010, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Jalal Uddin [juddin@mdsol.com]
**
** Complete history on bottom of file
**/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCreateCoderAdminLogin')
	DROP PROCEDURE spCreateCoderAdminLogin
GO

create procedure spCreateCoderAdminLogin  
(  
	@FirstName nvarchar(250),  
	@LastName nvarchar(250),  
	@Email nvarchar(250),  
	@Login nvarchar(50), --'coderadmin'  
	@IMedidataId varchar(50),  
	@DefaultSegmentID int,  
	@UserId int output  
)  
as  
begin  
	if exists (select null from Users where LOGIN=@Login) begin  
		select @UserId=UserId from Users where LOGIN=@Login  
	end  
	else begin  
		INSERT INTO [dbo].[Users]  
		   ([FirstName]  
		   ,[MiddleName]  
		   ,[LastName]  
		   ,[Title]  
		   ,[Email]  
		   ,[Login]  
		   ,[PIN]  
		   ,[Password]  
		   ,[PasswordExpires]  
		   ,[IsEnabled]  
		   ,[IsTrainingSigned]  
		   ,[Locale]  
		   ,[GlobalRoleID]  
		   ,[ExternalID]  
		   ,[IsSponsorApprovalRequired]  
		   ,[AccountActivation]  
		   ,[IsLockedOut]  
		   ,[Credentials]  
		   ,[Salutation]  
		   ,[Active]  
		   ,[Created]  
		   ,[Updated]  
		   ,[Guid]  
		   ,[DEANumber]  
		   ,[IsTrainingOnly]  
		   ,[EULADate]  
		   ,[IsClinicalUser]  
		   ,[IsReadOnly]  
		   ,[AuthenticatorID]  
		   ,[CreatedBy]  
		   ,[AuthenticationSourceID]  
		   ,[Salt]  
		   ,[UserDeactivated]  
		   ,[Deleted]  
		   ,[DefaultSegmentID]  
		   ,[IMedidataId])  
		VALUES  
		   (@FirstName  
		   ,null  
		   ,@LastName  
		   ,null  
		   ,@Email  
		   ,@Login --login  
		   ,null  
		   ,null  
		   ,DATEADD(YEAR, 1000, GETUTCDATE())  
		   ,1  
		   ,1  
		   ,'eng'  
		   ,0  
		   ,@IMedidataId  
		   ,0  
		   ,1  
		   ,0  
		   ,null  
		   ,null  
		   ,1  
		   ,GETUTCDATE()  
		   ,GETUTCDATE()  
		   ,'e0c6ede2-c69e-4ab0-b8e6-14bc916576bf'  
		   ,null  
		   ,0  
		   ,null  
		   ,0  
		   ,0  
		   ,null  
		   ,null  
		   ,null  
		   ,null  
		   ,0  
		   ,0  
		   ,@DefaultSegmentID  
		   ,@IMedidataId)  
		     
		select @UserId = SCOPE_IDENTITY()  
	end  
		
end
go