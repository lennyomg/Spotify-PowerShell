BeforeAll { 
    . $PSScriptRoot/Remove-SpotifyAlbum.ps1
}

# see Add-SpotifyAlbum.Tests.ps1

Describe "Remove-SpotifyAlbum Syntax" {
    Test-Syntax { Remove-SpotifyAlbum -AlbumId "id" }
    Test-Syntax { Remove-SpotifyAlbum -AlbumId "id1", "id2" }
    Test-Syntax { Remove-SpotifyAlbum "id" }
    Test-Syntax { Remove-SpotifyAlbum "id1", "id2" }
    Test-Syntax { "id" | Remove-SpotifyAlbum }
    Test-Syntax { "id1", "id2" | Remove-SpotifyAlbum } 2
    Test-Validation { Remove-SpotifyAlbum "" }
    Test-Validation { Remove-SpotifyAlbum $null }
    Test-Validation { Remove-SpotifyAlbum @() }
    Test-Validation { Remove-SpotifyAlbum @("") }
    Test-Validation { Remove-SpotifyAlbum @("id", "") }
    Test-PipeAlias { param($p) $p | Remove-SpotifyAlbum }
}