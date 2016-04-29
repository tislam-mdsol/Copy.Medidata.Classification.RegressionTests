
UPDATE CE
SET CE.SourceSite = CSTR_Site.ReferenceValue,
	CE.SourceLine = CSTR_Line.ReferenceValue,
	CE.SourceEvent = CSTR_Event.ReferenceValue
FROM CodingElements CE
	JOIN CodingSourceTermReferences CSTR_Site
		ON CE.CodingElementId = CSTR_Site.CodingSourceTermId
		AND CSTR_Site.ReferenceName = 'Site'
	JOIN CodingSourceTermReferences CSTR_Line
		ON CE.CodingElementId = CSTR_Line.CodingSourceTermId
		AND CSTR_Line.ReferenceName = 'Line'
	JOIN CodingSourceTermReferences CSTR_Event
		ON CE.CodingElementId = CSTR_Event.CodingSourceTermId
		AND CSTR_Event.ReferenceName = 'Event'
