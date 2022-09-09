BeforeAll {
    . $PSScriptRoot/Get-SpotifySavedTracks.ps1
}

Describe "Get-SpotifySavedTracks" {
    It "Default"{
        $p = Get-SpotifySavedTracks
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object { 
            $_.added_at | Should -Not -BeNullOrEmpty
            $_.track.type | Should -Be "track"
            $_.track.id | Should -Not -BeNullOrEmpty
            $_.track.uri | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifySavedTracks Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifySavedTracks }
}