/*
** Copyright© 2008, Medidata Solutions, Inc., All Rights Reserved.
**
** This is PROPRIETARY SOURCE CODE of Medidata Solutions, Inc. The contents of 
** this file may not be disclosed to third parties, copied or duplicated in 
** any form, in whole or in part, without the prior written permission of
** Medidata Solutions, Inc.
**
** Author: Madalina Tanasie mtanasie@mdsol.com
**
*/

-- WORK IN PROGRESS

if object_id('spUsrLdByFltrAndPg') is not null
	drop procedure spUsrLdByFltrAndPg
go

create procedure spUsrLdByFltrAndPg
	@FirstNameFilter nvarchar(255),
	@LastNameFilter nvarchar(255),
	@EmailFilter nvarchar(255),
	@LoginFilter nvarchar(255),
	@RoleID int,
	@ProjectID int,
	@SiteNameFilter nvarchar(255),
	@StudyId int,
	@SiteGroupId int,
	@Locale char(3),
	@PageSize int,
	@PageNumber int,
	@Count int output
		
AS
	if @Count IS NULL --If the total count is passed in, don't get it again from db
	SELECT @Count=count(1)
			FROM Users U			
			INNER JOIN UserObjectRole UOR ON UOR.GrantToObjectTypeID = 17 AND U.UserID = UOR.GrantToObjectID  --User
			LEFT JOIN UserStudySites USS ON U.UserID = USS.UserID
			INNER JOIN StudySites SS ON USS.StudySiteID = SS.StudySiteID
			INNER JOIN Studies S ON SS.StudyID = S.StudyID
			INNER JOIN Sites St ON  SS.SiteID = St.SiteID	
	WHERE 
			U.UserID > 0
			AND ((@FirstNameFilter is null) or (U.FirstName like '%' + @FirstNameFilter + '%'))
			AND ((@LastNameFilter is null) or (U.LastName like '%' + @LastNameFilter + '%'))			
			AND ((@LoginFilter is null) or (U.[Login] like '%' + @LoginFilter + '%'))
			AND ((@RoleID is null) OR (UOR.RoleID=@RoleID))
			AND ((@ProjectID is null) OR (S.ProjectID=@ProjectID))
			AND ((@SiteNameFilter is null) OR (dbo.fnLDS(St.SiteNameID, @Locale) like '%' + @SiteNameFilter + '%'))
			AND ((@StudyID is null) OR (S.StudyID=@StudyID));	
			/*AND ((@SiteGroupId is null) OR (U.InitialSiteGroupID=@SiteGroupId)) 
			TODO:- InitialSiteGroupID is removed from Users hence need to take this line out.
					But needs to be reviewed again since now the users cannot be filtered by SiteGroupId
			*/
	
	With SQLPaging
	AS
	(
		SELECT DISTINCT  U.* 
				FROM Users U			
				INNER JOIN UserObjectRole UOR ON UOR.GrantToObjectTypeID = 17 AND U.UserID = UOR.GrantToObjectID  --User
				LEFT JOIN UserStudySites USS ON U.UserID = USS.UserID
				INNER JOIN StudySites SS ON USS.StudySiteID = SS.StudySiteID
				INNER JOIN Studies S ON SS.StudyID = S.StudyID
				INNER JOIN Sites St ON  SS.SiteID = St.SiteID	
		WHERE 
				U.UserID > 0
				AND ((@FirstNameFilter is null) or (U.FirstName like '%' + @FirstNameFilter + '%'))
				AND ((@LastNameFilter is null) or (U.LastName like '%' + @LastNameFilter + '%'))			
				AND ((@LoginFilter is null) or (U.[Login] like '%' + @LoginFilter + '%'))
				AND ((@RoleID is null) OR (UOR.RoleID=@RoleID))
				AND ((@ProjectID is null) OR (S.ProjectID=@ProjectID))
				AND ((@SiteNameFilter is null) OR (dbo.fnLDS(St.SiteNameID, @Locale) like '%' + @SiteNameFilter + '%'))
				AND ((@StudyID is null) OR (S.StudyID=@StudyID))
				/*AND ((@SiteGroupId is null) OR (U.InitialSiteGroupID=@SiteGroupId)) 
				TODO:- InitialSiteGroupID is removed from Users hence need to take this line out.
						But needs to be reviewed again since now the users cannot be filtered by SiteGroupId
				*/
	)
	SELECT  * FROM 
	(SELECT  ROW_NUMBER() OVER (ORDER BY LastName ASC) AS Row, TU.*  FROM SQLPaging TU) AS UsersWithRowNumbers
	WHERE  Row BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber*@PageSize		
			
GO
