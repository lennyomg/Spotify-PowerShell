#
# Run unit tests and helper functions. Run 
#

<#
.SYNOPSIS
Tests command syntax.

.DESCRIPTION
Executes commands, verifies that there were no error and a web request has been done.

.PARAMETER Command
Script block to execute.

.PARAMETER Times
Verify how many web requests have been done.

.EXAMPLE
Describe "test" {
    Test-Syntax { Get-SpotifyArtist -ArtistId "id" }
}
#>
function Test-Syntax {
    param (
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $Command,

        [Parameter(Position = 1)]
        [int] $Times = 1
    )
    
    Context "Syntax $(@(Get-PSCallStack)[4].InvocationInfo.MyCommand.Name)" {
        It "<c>" -ForEach $( @{ c = $Command; t = $Times }) {
            Mock Invoke-RestMethod
            Invoke-Command $c
            Assert-MockCalled Invoke-RestMethod -Times $t -Exactly
        } }
}

<#
.SYNOPSIS
Tests parameters validation.

.DESCRIPTION
Executes commands, verifies that there was an error and no web requests have been done.

.PARAMETER Command
Script block to execute.

.PARAMETER Times
Verify how many web requests have been done.

.EXAMPLE
Describe "test" {
    Test-Validation { Get-SpotifyArtist -ArtistId $null }
}
#>
function Test-Validation {
    param (
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $Command
    )
    
    Context "Validation $(@(Get-PSCallStack)[4].InvocationInfo.MyCommand.Name)" {
        It "<c>" -ForEach $( @{ c = $Command; t = $Times }) {
            Mock Invoke-RestMethod
            { Invoke-Command $c } | Should -Throw
            Assert-MockCalled Invoke-RestMethod -Times 0
        } }
}

<#
.SYNOPSIS
Tests parameter aliases.

.DESCRIPTION
Tests parameter aliases for pipeline binding.

.PARAMETER Command
Command to execute.

.PARAMETER Times
How many times Invoke-RestMethod should be called. 2 by default.

.PARAMETER Data
Test data for pipeline.

.EXAMPLE
Describe "test" {
    Test-Alias { param($p) $p | Get-SpotifyAlbumTracks }
}
#>
function Test-PipeAlias {
    param (
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $Command,

        [Parameter(Position = 1)]
        [int] $Times = 2,

        [Parameter(Position = 2)]
        $Data = @( 
            [pscustomobject]@{ id = "id1"; dummy = "dummy" }
            [pscustomobject]@{ id = "id2"; dummy = "dummy" }
        )
    )

    Context "Alias $(@(Get-PSCallStack)[4].InvocationInfo.MyCommand.Name)" {
        It "<c>" -ForEach $( @{ c = $Command; d = $Data; t = $Times }) {
            $script:___e = @{ args = $null }
            Mock Invoke-RestMethod -Verifiable -MockWith { $script:___e.args = $args }
            Invoke-Command $c -ArgumentList (, $d)
            $script:___e.args -join " " | Should -Not -BeLike "*dummy*"
            Assert-MockCalled Invoke-RestMethod -Times $t -Exactly
        } }
}

<#
.SYNOPSIS
Saved optimized JSON from a command to the 'outputs' folder.

.DESCRIPTION
Cuts all arrays to 3 elements and removes personal information that is specified in '<repo_root>/pi.txt'.

.PARAMETER Command
Command to execute.

.EXAMPLE
Describe "Get-SpotifySavedPlaylists" -Tag "Output" {
    Update-CommandOutput { Get-SpotifySavedPlaylists }
}
#>
function Update-CommandOutput {
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $Command
    )

    function Shrink($o) { 
        foreach ($p in $o.PSObject.Properties) {
            $v = $o.($p.name)
            switch ($p.TypeNameOfValue) {
                "System.Object[]" { 
                    $v = $v.Count -gt 3 ? ($v[0], $v[1], $v[3]) : $v
                    $o.($p.name) = $v
                    $v | ForEach-Object { Shrink $_ }
                }
                "System.Management.Automation.PSCustomObject" { 
                    Shrink $v 
                }
            }
        }
    }
    $name = ($Command | Out-String).Trim().Split(" ")[0]

    Context "Output" {
        It $name {
            $out = [pscustomobject]@{ item = (& $Command) }
            Shrink $out
            $out = $out.item | ConvertTo-Json -Depth 99 
            Get-Content "$($PSScriptRoot)/pi.txt" -ErrorAction SilentlyContinue | ForEach-Object { $out = $out -replace $_, "REDACTED" } 
            $out | Out-File "$($PSScriptRoot)/outputs/$($name).json"
        }
    }
}

<#
.SYNOPSIS
Runs tests.
#>
function Invoke-SpotifyTests {
    [CmdletBinding()]
    param ()
    
    . $PSScriptRoot/functions/Connect-SpotifyApi.ps1
    Connect-SpotifyApi

    $p = Invoke-Pester $PSScriptRoot/*.Tests.ps1 -Output Normal -PassThru -ExcludeTagFilter Output
    if ($p.result -eq "Failed") {
        throw "Tests failed."
    }
}
