. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
}

Describe "Get-SpotifySavedPlaylists" {
    It "Default" {
        $p = Get-SpotifySavedPlaylists
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object { 
            $_.type | Should -Be "playlist"
            $_.id | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.playlist"
        }
    }
}

Describe "Get-SpotifySavedPlaylists Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifySavedPlaylists }
}
