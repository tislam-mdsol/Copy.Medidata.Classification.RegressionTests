cls
$rootDir = $args[0]
$regex = '<h1>Test Results Summary</h1>.*?</body>'
$text = ''
Get-ChildItem $rootDir/*.* -Include *.trx.html `
| Get-Content |  % { $text += $_ }

$x = [System.Text.RegularExpressions.Regex]::Matches($text, $regex, [System.Text.RegularExpressions.RegexOptions]::Multiline).Captures `
| % { $_ -replace '</body>', '' }

$text = ''

$x | % { $text += $_ }

cls

$result = '<html xmlns:vs="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
<head>
<style type="text/css">
          input.button {
          color: #fff; background: #0034D0;
          font-size: .8em;
          font-weight:bold;
          font-family: Verdana, Arial, Helvetica, sans-serif;
          border: solid 1px #ffcf31;
          }
        </style>
<script language="JavaScript">
          function toggleMe(a)
          {
          var e=document.getElementById(a);
          if(!e)return true;
          if(e.style.display=="none"){
          e.style.display="block"
          } else {
          e.style.display="none"
          }
          return true;
          }
        </script>
</head>
<body style="font-family:Verdana; font-size:10pt">
' + $text + '
</body>
';

$result >> $rootDir/consolidated_report.html
