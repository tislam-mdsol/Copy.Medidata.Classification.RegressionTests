----Update rejected tasks to the right DictionaryVersionId after its corresponding study was migrated
----requires StudyDictionaryVersion VersionOrdinal to VersionId transition(20120425-02-AutomationChangesTwo.sql)
 UPDATE CE
 SET CE.DictionaryVersionId = SDV.DictionaryVersionId
 FROM CodingElements CE
	JOIN CodingRejections CR 
		On CE.CodingElementID = CR.CodingElementID
	JOIN MedicalDictionaryVersion MDV 
		ON CE.DictionaryVersionId =MDV.DictionaryVersionId
	JOIN StudyDictionaryVersion SDV 
		ON SDV.SegmentID = CE.SegmentId
		AND SDV.StudyID = CE.TrackableObjectId
	    AND SDV.MedicalDictionaryID =MDV.MedicalDictionaryId	