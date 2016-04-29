IF object_id('spSearch') is not null
	drop procedure spSearch
go

create procedure spSearch
	@NameFilter nvarchar (50),
	@SiteNumberFilter nvarchar(50),
	@Locale char(3),
	@PageSize int,
	@PageNumber int,
	@SiteGroupID int,
	@SortExpression varchar(50),
	@SortOrder tinyint = 1, --ASC
	@Count int output --Return the total count for first time execution, and then use the same for the subsequent executions

AS

SET @SiteNumberFilter = REPLACE(@SiteNumberFilter, '*', '%')
IF(@SiteGroupID < 0 OR @SiteGroupID IS NULL) SET @SiteGroupID = 1 -- assume root site group IF none specIFied.

DECLARE @StartSeq int
DECLARE @EndSeq int
SELECT @StartSeq = StartSeq, @EndSeq = EndSeq FROM SiteGroups WHERE SiteGroupID = @SiteGroupID

if @Count IS NULL --If the total count is passed in, don't get it again from db
	SELECT @Count=count(1) 
		FROM sites inner join sitegroups on sitegroups.sitegroupid = sites.sitegroupid
		WHERE (dbo.fnLDS(SiteNameID, @Locale) like '%'+@NameFilter+'%'  or @NameFilter is null) and StartSeq between @StartSeq and @EndSeq and (@SiteNumberFilter IS NULL OR @SiteNumberFilter = '' OR sites.sitenumber like '%' + @SiteNumberFilter + '%');


With SQLPaging
AS
(
SELECT dbo.fnLDS(SiteNameID, @Locale) as SiteName,dbo.fnLDS(SiteGroupNameID, @Locale) as SiteGroupName,dbo.fnStudyNameBySite(sites.SiteId,@Locale) as StudyName,sites.* 
	FROM sites inner join sitegroups on sitegroups.sitegroupid = sites.sitegroupid
	WHERE (dbo.fnLDS(SiteNameID, @Locale) like '%'+@NameFilter+'%'  or @NameFilter is null) and StartSeq between @StartSeq and @EndSeq and (@SiteNumberFilter IS NULL OR @SiteNumberFilter = '' OR sites.sitenumber like '%' + @SiteNumberFilter + '%')
)
SELECT  * FROM 
	(SELECT  ROW_NUMBER() OVER 
	(ORDER BY case when @SortExpression='StudyName' and @SortOrder=1 then StudyName end asc,
	case when @SortExpression='StudyName' and @SortOrder=2 then StudyName end desc,
	case when @SortExpression='SiteName' and @SortOrder=1 then SiteName end asc,
	case when @SortExpression='SiteName' and @SortOrder=2 then SiteName end desc,
	case when @SortExpression='SiteNumber' and @SortOrder=1 then SiteNumber end asc,
	case when @SortExpression='SiteNumber' and @SortOrder=2 then SiteNumber end desc,
	case when @SortExpression='SiteGroupName' and @SortOrder=1 then SiteGroupName end asc,
	case when @SortExpression='SiteGroupName' and @SortOrder=2 then SiteGroupName end desc,
	case when @SortExpression='SiteActive' and @SortOrder=1 then SiteActive end asc,
	case when @SortExpression='SiteActive' and @SortOrder=2 then SiteActive end desc) 
AS Row,  TS.*  FROM SQLPaging TS) AS SitesWithRowNumbers
	WHERE  Row BETWEEN (@PageNumber) * @PageSize + 1 AND (@PageNumber+1)*@PageSize

