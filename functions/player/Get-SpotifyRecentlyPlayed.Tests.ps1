BeforeAll {
    . $PSScriptRoot/Get-SpotifyRecentlyPlayed.ps1
}

Describe "Get-SpotifyRecentlyPlayed" {
    It "Default" {
        $p = Get-SpotifyRecentlyPlayed
        $p | ForEach-Object { 
            $_.played_at | Should -Not -BeNullOrEmpty
            $_.track.type | Should -Be "track"
            $_.track.id | Should -Not -BeNullOrEmpty
            $_.track.uri | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyRecentlyPlayed Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyRecentlyPlayed }
}