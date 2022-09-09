# FILES

$files = Get-ChildItem -Path $PSScriptRoot/functions/*.ps1 -Exclude *.Tests.ps1 -Recurse | Sort-Object -Property FullName

# PSM1

@"
# ---------
# DO NOT EDIT THIS FILE. This file is auto-generated by Build.ps1.
# ---------

"@ | Set-Content "./Spotify.psm1"

$files
| ForEach-Object { (Get-Content $_.FullName | Out-String).Trim() }
| Join-String -Separator "`n`n"
| Add-Content "./Spotify.psm1"
 
# PSD1

$m = Test-ModuleManifest "./Spotify.psd1"
Update-ModuleManifest `
    -Path "./Spotify.psd1" `
    -FunctionsToExport ($files | ForEach-Object { $_.BaseName }) `
    -ModuleVersion "$($m.Version.Major).$($m.Version.Minor).$($m.Version.Build + 1)" 

