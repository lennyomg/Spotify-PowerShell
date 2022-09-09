BeforeAll {
    . $PSScriptRoot/Add-SpotifyPlaylist.ps1
    . $PSScriptRoot/Remove-SpotifyPlaylist.ps1
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
    . $PSScriptRoot/Get-SpotifyPlaylist.ps1
}

Describe "Add-SpotifyPlaylist / Remove-SpotifyPlaylist" {
    It "Default <value>" -ForEach @(
        @{ value = "37i9dQZF1DWUgBy0IJPlHq" }
        @{ value = "37i9dQZF1DX1lVhptIYRda" }
    ) {
        $playlists = { Get-SpotifySavedPlaylists | ForEach-Object { $_.id } }
        $value | Should -Not -BeIn (& $playlists)

        Add-SpotifyPlaylist -PlaylistId $value
        $value | Should -BeIn (& $playlists)

        Remove-SpotifyPlaylist -PlaylistId $value
        $value | Should -Not -BeIn (& $playlists)
    }
}

Describe "Add-SpotifyAlbum Syntax" {
    Test-Syntax { Add-SpotifyPlaylist -PlaylistId "id" }
    Test-Syntax { Add-SpotifyPlaylist "id" }
    Test-Syntax { "id" | Add-SpotifyPlaylist }
    Test-Syntax { "id1", "id2" | Add-SpotifyPlaylist } 2
    Test-Validation { Add-SpotifyPlaylist -PlaylistId "" }
    Test-Validation { Add-SpotifyPlaylist -PlaylistId $null }
    Test-PipeAlias { param($p) $p | Add-SpotifyPlaylist }
}