BeforeAll { 
    . $PSScriptRoot/Get-SpotifyPlaylistTracks.ps1
}

Describe "Get-SpotifyPlaylistTracks" {
    It "Default <value>" -ForEach @(
        @{ value = "3cEYpjA9oz9GiPac4AsH4n" }
        @{ value = "37i9dQZF1DX1lVhptIYRda" }
    ) {
        $p = Get-SpotifyPlaylistTracks -PlaylistId $value
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.added_at | Should -Not -BeNullOrEmpty
            $_.added_by | Should -Not -BeNullOrEmpty
            $_.type | Should -Be "track"
            $_.id | Should -Not -BeNullOrEmpty
            $_.uri | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyPlaylistTracks Syntax" {
    Test-Syntax { Get-SpotifyPlaylistTracks -PlaylistId "id" }
    Test-Syntax { Get-SpotifyPlaylistTracks "id" }
    Test-Syntax { "id" | Get-SpotifyPlaylistTracks }
    Test-Syntax { "id1", "id2" | Get-SpotifyPlaylistTracks } 2
    Test-Validation { Get-SpotifyPlaylistTracks -PlaylistId "" }
    Test-Validation { Get-SpotifyPlaylistTracks -PlaylistId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyPlaylistTracks }
}

Describe "Get-SpotifyPlaylistTracks Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyPlaylistTracks -PlaylistId "37i9dQZF1DWUgBy0IJPlHq" }
}