
UPDATE CE
SET CE.EDCDataId = EDC.EDCDataId
FROM EDCData EDC
	JOIN CodingElements CE
		ON EDC.AuxiliaryID = CE.CodingElementId


