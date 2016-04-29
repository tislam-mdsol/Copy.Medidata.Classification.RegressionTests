param([string] $targetAppName = "CoderWeb", [string] $targetFolder = "G:\git\coder\CoderWeb\bin", [string] $buildNumber = "-1000") #DEFAULT FOR TESTING ONLY.  THIS SHOULD BE PASSED IN AS AN ARGUMENT.

##################################################################################################
# FUNCTIONS ## ###################################################################################
##################################################################################################

function processTable([string] $table, [string] $targetName, $gitHash, $gitDate, $gitBranch, [string] $typeName, [string] $keyField)
{
    Write-Host "Processing table..." -ForegroundColor Blue
    $text = parseHtmlTable $table;
	$file = New-Item ($PWD.Path + "\working\" + $targetName + "_" + $typeName + ".metrics.log") -ItemType file -Force 	

	Add-Content $file $text                                 # log it to a file
	
	#TODO: get ElasticSearch node up an running and enable it with the method below
	#exportToEs $text $gitHash $gitDate $gitBranch $typeName $keyField #send to ElasticSearch
	
	Import-Csv $file -Delimiter "|"
} 

function parseHtmlTable([string] $table)
{
	$text = $table;
	$text = [System.Text.RegularExpressions.Regex]::Replace($text, ">\s+<", "><");
	$text = [System.Text.RegularExpressions.Regex]::Replace($text, "<td[^>]*>", "|");
    $text = [System.Text.RegularExpressions.Regex]::Replace($text, "</tr[^>]*>", "`n");
    $text = [System.Text.RegularExpressions.Regex]::Replace($text, "</?[^>]+>", "");
	$text = [System.Text.RegularExpressions.Regex]::Replace($text, "(^|`n)\|", "`n");  # remove leading pipes
	
	$text = $text.Trim()
	$text;
}

# Export data to ElasticSearch
function exportToES([string] $data, [string] $hash, [Datetime] $date, [string] $branch, [string] $dataType, [string] $keyField)
{
	Write-Host "Sending to ElasticSearch..." -ForegroundColor Blue
	
	$es = New-Object System.Net.WebClient

	$es.Headers.Add("Content-Type", "application/json");
	
	$mappingMessage = "{ ""$dataType"": { ""_timestamp"": { ""enabled"":true, ""path"": ""date"" } } } ";
	$mappingMessage2 = "{ ""$dataType"": { ""_id"": { ""path"": ""key"" } } } ";
	$response       = $es.UploadString("http://localhost:9200/testindex_a/$dataType/_mapping", "PUT", $mappingMessage);
	$response       = $es.UploadString("http://localhost:9200/testindex_a/$dataType/_mapping", "PUT", $mappingMessage2);
	
	Write-Host $response -ForegroundColor Blue

	$arr = $data.Split("`n") | ForEach-Object { $_.Trim() }

	$names = $arr[0].Split("|");

	for($lineIndex = 1; $lineIndex -lt $arr.Length; $lineIndex++){
		$str  = "{ " + [Environment]::NewLine;
		$vals = $arr[$lineIndex].Split("|");
		
		$keyIndex = [Array]::IndexOf($names, $keyField);
		$key = $hash + $vals[$keyIndex];
		
		$str += """key"":""" + $key + """," + [Environment]::NewLine; # TODO: make sure this is unique key
		
		for($valIndex = 0; $valIndex -le $names.Length; $valIndex++){
			$name = $names[$valIndex];
			$val  = $vals[$valIndex];
			
			if($name -eq $null -or $name.Trim().Length -eq 0){
				continue;}
			
			if($valIndex -gt 1){
				$str += ", " + [Environment]::NewLine;
			}

			[System.Double] $x  = 0;
			[System.Boolean] $y = $false;
			
			if([System.Double]::TryParse($vals[$valIndex], [ref] $x)) #treat as number
			{
				$str += """" + $name + """: " + $val 
			}
			elseif([System.Boolean]::TryParse($vals[$valIndex], [ref] $y)) #treat as boolean
			{
				$str += """" + $name + """: " + $val.ToLower() 
			}
			else #treat as string
			{
			 	$str += """" + $name + """: """ + $val + """"
			}
		}
		
		$str += "," + [Environment]::NewLine + """product"" : ""$targetAppName""";
		$str += "," + [Environment]::NewLine + """datatype"" : ""$dataType""";
		$str += "," + [Environment]::NewLine + """hash"" : ""$hash""";
		$str += "," + [Environment]::NewLine + """branch"" : ""$branch""";
		$str += "," + [Environment]::NewLine + """date"" : """ + $date.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss") + """";
		$str += [Environment]::NewLine + "}";

		try
		{
			$response = $es.UploadString("http://localhost:9200/testindex_a/$typeName", "POST", $str);
			$response = $response.Replace('@', '_');
			Write-Host $response -ForegroundColor DarkGreen;
		}
		catch # for debugging
		{
			$a = 1;
			
			Write-Host $Error -ForegroundColor Red
			Write-Host $str -ForegroundColor Yellow
			
			$Error.Clear()
		}
	}
}

##################################################################################################
# START SCRIPT ###################################################################################
##################################################################################################


#### Prep Environment....

cls
Write-Host "Target App Name  : $targetAppName"  
Write-Host "Target App Folder  : $targetFolder"  

##################################################################################################
# NOTE: Nitriq HTML is malformed, agility pack will fail to parse correctly... 
#       had to resort to regular expressions
#
# $assemblyPath = Resolve-Path "htmlagilitypack.dll";  #was not usable due to malformed html
# [Reflection.Assembly]::LoadFile($assemblyPath);
##################################################################################################

## Get GIT status...

#########The logics has been moved into posh-metrics module, since the dlls being analyzed are copied from those bins and have no git status
		#Push-Location $targetFolder
		#[Environment]::CurrentDirectory = $PWD

		#$gitHash            = (& git rev-parse HEAD) 
		#[datetime] $gitDate = [System.DateTime]::Parse( (& git show --format="%ci" $gitHash) )
		#$gitBranch          = (& git branch)

		#Write-Host "Git hash  : $gitHash"   -ForegroundColor DarkGray
		#Write-Host "Git date  : $gitDate"   -ForegroundColor DarkGray
		#Write-Host "Git branch: $gitBranch" -ForegroundColor DarkGray
#########Pop-Location
		
		
		[Environment]::CurrentDirectory = $PWD
        Write-Host "Current working directory for project $targetAppName is at $PWD"
		Write-Host "Start Examining libraries..."
		#### Start Examining libraries...

		md ($PWD.Path + '\working\project') -Force -ErrorAction SilentlyContinue
		
		Write-Host "Current working directory for project $targetAppName after making working and project path is at $PWD"		
		 
		####$nitriqLib      = $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
		####$nitriqLib      +='\Nitriq.Console.exe';
		
			$nitriqLib  = $PWD.Path + '\Nitriq.Console.exe';
		$nitriqQueries  = $PWD.Path + '\Queries.nq';
		$nitriqOutput   = $PWD.Path + '\working\' + $targetAppName + '_Nitriq.html';

		Write-Host "Current $$nitriqLib for project $targetAppName is at $nitriqLib"	
		Write-Host "Current $$nitriqQueries query for project $targetAppName is at $nitriqQueries"	
		Write-Host "Current $$nitriqOutput for project $targetAppName is at $nitriqOutput"	
		
		$returnCode = "The return code: "
		 
		[System.IO.DirectoryInfo] $folderInfo  = New-Object "System.IO.DirectoryInfo" -ArgumentList $targetFolder
		$fileInfos                             = $folderInfo.GetFiles("*Medidata*.dll");
		$fileInfos                             += $folderInfo.GetFiles("*Coder*.dll");

		#####nitriq analysis on Medidata.iMedidataAuthSupport.dll, exception on System null reference, exclude this dll for now
		$fileInfos = $fileInfos | Where-Object { -not $_.Name.Contains("Test")} | Where-Object { -not $_.Name.Contains("iMedidataAuthSupport")} | Sort-Object -Property Name -Unique

		Write-Host "Displaying all assemblies being processed for project $targetAppNAme, total dlls to be analysed is  $fileInfos.Count  ....."
		$fileInfos #display all assemblies being processed

		$allMethodInfo = @();
		$allTypeInfo = @();
		$allAssemblyInfo = @();
		$allAssemblyThInfo = @();


				for([int] $fileIndex = 0; $fileIndex -lt $fileInfos.Count; $fileIndex++){

					$text          = $fileInfos[$fileIndex].FullName;
					$targetName    = $fileInfos[$fileIndex].Name;
					$nitriqProject = $PWD.Path + "\working\project\"+ $targetAppName +".$targetName.$fileIndex.nitriqProj";

					Write-Host ("Examining library: " + $targetName) -ForegroundColor Blue

					Set-Content $nitriqProject $text -Force # Setting up nitriq project file with path of library
					
					Write-Host "$$nitriqProject is   :  $nitriqProject"
					Write-Host "$$nitriqQueries is   :  $nitriqQueries"
					Write-Host "$$nitriqOutput is   :  $nitriqOutput"
					
					
					& $nitriqLib $nitriqProject $nitriqQueries $nitriqOutput ######executing Nitriq$nitriqLib 

						$nitriqHtml = Get-Content $nitriqOutput
						$tables     = [System.Text.RegularExpressions.Regex]::Matches($nitriqHtml, "<table.*?</table>") | ForEach-Object { $_.Value };
					
						Write-Host "Processing Methods" -ForegroundColor Blue
						$allMethodInfo += processTable $tables[0] $targetName $gitHash $gitDate $gitBranch "Method" "FullName"
						
						Write-Host "Processing Types" -ForegroundColor Blue
						$allTypeInfo += processTable $tables[1] $targetName $gitHash $gitDate $gitBranch "Type" "FullName"
						
						Write-Host "Processing Assemblies" -ForegroundColor Blue
						$allAssemblyInfo += processTable $tables[2] $targetName $gitHash $gitDate $gitBranch "Assembly" "Name"
					
				####Each Rule with results should have a table, last rule in use may not return table in html if nothing queried.
				####If rules violated and a 4th table would be generated, total four rules currently in queries.nq
				    Write-Host "Table counts in processing $targetAppName  is $($tables.Count)" 
					IF ($tables.Count -gt 3) 
					{
						Write-Host "Processing Assemblies with threshold, some rules were violated..." -ForegroundColor Blue
						$returnCode += "Assembly threshold breaks in $targetName, when metrics analysing $targetAppName."
						Write-Host $returnCode
						
						$allAssemblyThInfo += processTable $tables[3] $targetName $gitHash $gitDate $gitBranch "AssemblyThreshold" "Name"
					}
				}
		
		$filePrefix = $PWD.Path + "\" + $targetAppName;
		$allAssemblyInfo  | ConvertTo-Html -Fragment | Set-Content -path ($filePrefix  + "_assembly_metrics.html")
		$allTypeInfo  | ConvertTo-Html -Fragment | Set-Content -path ($filePrefix  + "_type_metrics.html")
		$allMethodInfo  | ConvertTo-Html -Fragment | Set-Content -path ($filePrefix  + "_method_metrics.html")

		### with quotes
		### $allAssemblyInfo  | ConvertTo-Csv | Set-Content -path ($filePrefix  + "_assembly_metrics.csv")
		### without quotes
		$allAssemblyInfo  | ConvertTo-Csv | Foreach-Object {$_ -replace '"', ''} | Set-Content -path ($filePrefix + "_assembly_metrics.csv")
		$allTypeInfo  | ConvertTo-Csv | Set-Content -path ($filePrefix  + "_type_metrics.csv")
		$allMethodInfo  | ConvertTo-Csv | Set-Content -path ($filePrefix  + "_method_metrics.csv")

		###Export assembly metrics csv with build number and date info for aggregation processing
		$currentDate = Get-Date -format mmddyyyy	
		Write-Host "$$currentDate is   :  $currentDate"
		$filePrefixWithBuildNumber = $PWD.Path + "\" + $buildNumber + "_" + $currentDate + "_" + $targetAppName;
		$allAssemblyInfo  | ConvertTo-Csv | Foreach-Object {$_ -replace '"', ''} | Set-Content -path ($filePrefixWithBuildNumber + "_assembly_metrics_aggregate.csv")
				
		Write-Host "After processed all dlls in project $targetAppName , current working directory is at $PWD"
		IF ($allAssemblyThInfo.Count -gt 0) 
		{
			Write-Host "After processed all dlls in project $targetAppName, found some dlls have broken certain rules, collecting these info in threshold directory..."
				
			 IF(-not (Test-Path ($PWD.Path + "\threshold\")))
			 {
			  # making a directory for threshold breakers
				md ($PWD.Path + '\threshold') -Force -ErrorAction SilentlyContinue
			 }
		
			$allAssemblyThInfo | ConvertTo-Html -Fragment | Set-Content -path ($PWD.Path + "\threshold\" + $targetAppName  + "__assembly_threshold_metrics.html")
			$allAssemblyThInfo  | ConvertTo-Csv | Foreach-Object {$_ -replace '"', ''} | Set-Content -path ($PWD.Path + "\threshold\" + $targetAppName  + "__assembly_threshold_metrics.csv")
				
		}	
		
		#### CLEANUP
		$workingDirectory = $PWD.Path + '\working\'
		Remove-Item $workingDirectory -Force -Recurse 

