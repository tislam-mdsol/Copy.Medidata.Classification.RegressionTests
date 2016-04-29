UPDATE Us
SET Us.TimeZoneInfo = UP.TimeZoneInfo
FROM Users Us 
	CROSS APPLY
	(
		SELECT ISNULL(MAX (TimeZoneInfoId), '') AS TimeZoneInfo
		FROM UserPreferences UP
		WHERE us.UserID = UP.UserId
	) AS UP
