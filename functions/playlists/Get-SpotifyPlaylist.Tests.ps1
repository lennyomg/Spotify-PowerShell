BeforeAll {
    . $PSScriptRoot/Get-SpotifyPlaylist.ps1
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
}

Describe "Get-SpotifyPlaylist" {
    It "Default <value>" -ForEach @(
        @{ value = "37i9dQZF1DX1lVhptIYRda" }
        @{ value = "37i9dQZF1DWUgBy0IJPlHq" }
    ) {
        $p = Get-SpotifyPlaylist -PlaylistId $value
        $p.id | Should -Be $value
        $p.type | Should -Be "playlist"
    }
}

Describe "Get-SpotifyPlaylist Syntax" {
    Test-Syntax { Get-SpotifyPlaylist -PlaylistId "id" }
    Test-Syntax { Get-SpotifyPlaylist "id" }
    Test-Syntax { "id" | Get-SpotifyPlaylist }
    Test-Syntax { "id1", "id2" | Get-SpotifyPlaylist } 2
    Test-Validation { Get-SpotifyPlaylist -PlaylistId "" }
    Test-Validation { Get-SpotifyPlaylist -PlaylistId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyPlaylist }
}

Describe "Get-SpotifyPlaylist Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyPlaylist -PlaylistId "37i9dQZF1DWUgBy0IJPlHq" }
}