UPDATE WR
SET WR.RoleName = LDS.String
FROM WorkflowRoles WR
	JOIN LocalizedDataStringPKs LPK
		ON WR.RoleNameID = LPK.StringId
    JOIN dbo.LocalizedDataStrings lds 
		ON WR.RoleNameID = lds.StringID
        AND lds.Locale = LPK.InsertedInLocale

