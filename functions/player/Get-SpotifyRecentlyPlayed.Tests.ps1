BeforeAll {
    . $PSScriptRoot/Get-SpotifyRecentlyPlayed.ps1
}

Describe "Get-SpotifyRecentlyPlayed" {
    It "Default" {
        $p = Get-SpotifyRecentlyPlayed
        $p | ForEach-Object { 
            $_.played_at | Should -Not -BeNullOrEmpty
            $_.type | Should -Be "track"
            $_.id | Should -Not -BeNullOrEmpty
            $_.uri | Should -Not -BeNullOrEmpty
            
        }
    }
}

Describe "Get-SpotifyRecentlyPlayed Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyRecentlyPlayed }
}