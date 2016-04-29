---make all existing group verbatims uppercase
UPDATE GroupVerbatimJpn
	SET VerbatimText=UPPER(VerbatimText)
UPDATE GroupVerbatimEng
    SET VerbatimText=UPPER(VerbatimText)