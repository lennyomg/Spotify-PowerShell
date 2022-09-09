BeforeAll {
    . $PSScriptRoot/Remove-SpotifyPlaylist.ps1
}

# see Add-SpotifyPlaylist.Tests.ps1

Describe "Remove-SpotifyPlaylist Syntax" {
    Test-Syntax { Remove-SpotifyPlaylist -PlaylistId "id" }
    Test-Syntax { Remove-SpotifyPlaylist "id" }
    Test-Syntax { "id" | Remove-SpotifyPlaylist }
    Test-Syntax { "id1", "id2" | Remove-SpotifyPlaylist } 2
    Test-Validation { Remove-SpotifyPlaylist -PlaylistId "" }
    Test-Validation { Remove-SpotifyPlaylist -PlaylistId $null }
    Test-PipeAlias { param($p) $p | Remove-SpotifyPlaylist }
}