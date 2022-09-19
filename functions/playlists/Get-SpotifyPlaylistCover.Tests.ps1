. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyPlaylistCover.ps1
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
}

Describe "3cEYpjA9oz9GiPac4AsH4n" {
    It "Default <value>" -ForEach @(
        @{ value = "37i9dQZF1DX1lVhptIYRda" }
        @{ value = "37i9dQZF1DWUgBy0IJPlHq" }
    ) {
        $p = Get-SpotifyPlaylistCover -PlaylistId $value
        $p.url | Should -Not -BeNullOrEmpty 
    }
}

Describe "Get-SpotifyPlaylistCover Syntax" {
    Test-Syntax { Get-SpotifyPlaylistCover -PlaylistId "id" }
    Test-Syntax { Get-SpotifyPlaylistCover "id" }
    Test-Syntax { "id" | Get-SpotifyPlaylistCover }
    Test-Syntax { "id1", "id2" | Get-SpotifyPlaylistCover } 2
    Test-Validation { Get-SpotifyPlaylistCover -PlaylistId "" }
    Test-Validation { Get-SpotifyPlaylistCover -PlaylistId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyPlaylistCover }
}

Describe "Get-SpotifyPlaylistCover Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyPlaylistCover -PlaylistId "37i9dQZF1DWUgBy0IJPlHq" }
}
