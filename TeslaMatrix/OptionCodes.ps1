[hashtable]$teslaOptionCodeLookup = @{}
$data = Import-Csv -Header Key, Value -Path $PSScriptRoot\optioncode.csv 
$data | ForEach-Object {$teslaOptionCodeLookup += @{$_.Key.Trim()=$_.Value}}
