 --add localization strings for existing version numbers
 ;With JPNStrings(StringName, String, ProductName)
 as (
 select StringName, String, ProductName
 from LocalizedStrings
 where Locale='jpn'
 )
 Insert into LocalizedStrings (StringName,String,Locale,StringTypeID,ProductName,TranslationStatus)
 select L.StringName,L.String,'jpn',L.StringTypeID,L.ProductName,L.TranslationStatus 
 from LocalizedStrings L
 left join JPNStrings JPN
 on JPN.StringName=L.StringName
 and JPN.ProductName=L.ProductName
 where JPN.String is null
 and L.Locale='eng'
 and ISNUMERIC(L.String)=1