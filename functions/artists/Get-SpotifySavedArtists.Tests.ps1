BeforeAll {
    . $PSScriptRoot/Get-SpotifySavedArtists.ps1
}

Describe "Get-SpotifySavedArtists" {
    It "Default" {
        $p = Get-SpotifySavedArtists
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object { 
            $_.type | Should -Be "artist"
            $_.id | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifySavedArtists Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifySavedArtists }
}