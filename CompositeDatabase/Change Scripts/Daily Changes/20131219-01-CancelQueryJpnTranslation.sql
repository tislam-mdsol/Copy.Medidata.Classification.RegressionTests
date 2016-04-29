/*
Cancel query was created as a workflow action without adding the jpn translation.
This script will add the jpn translation data string for all the Cancel Queries
that do not have the jpn version.

Due to the magic that is segment creation, if the template segment
has the jpn version any new segment will get it also.

-- Connor Ross
*/
INSERT INTO LocalizedDataStrings (StringId, String, Locale, Updated, Created, TranslationStatus, SegmentID)
select StringId, N'クエリを取消', 'jpn', GETUTCDATE(), GETUTCDATE(), TranslationStatus, SegmentID
from LocalizedDataStrings eng
where String = 'Cancel Query'
AND Locale = 'eng'
AND NOT Exists(
  select null
  from LocalizedDataStrings jpn 
  where jpn.StringID = eng.StringId AND Locale = 'jpn')