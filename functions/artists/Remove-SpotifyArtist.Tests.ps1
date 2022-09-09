BeforeAll { 
    . $PSScriptRoot/Remove-SpotifyArtist.ps1
}

# see Add-SpotifyArtist.Tests.ps1

Describe "Remove-SpotifyArtist Syntax" {
    Test-Syntax { Remove-SpotifyArtist -ArtistId "id" }
    Test-Syntax { Remove-SpotifyArtist -ArtistId "id1", "id2" }
    Test-Syntax { Remove-SpotifyArtist -ArtistId @("id1", "id2") }
    Test-Syntax { Remove-SpotifyArtist "id" }
    Test-Syntax { Remove-SpotifyArtist "id1", "id2" }
    Test-Syntax { "id" | Remove-SpotifyArtist }
    Test-Syntax { "id1", "id2" | Remove-SpotifyArtist } 2
    Test-Validation { Remove-SpotifyArtist "" }
    Test-Validation { Remove-SpotifyArtist $null }
    Test-Validation { Remove-SpotifyArtist @() }
    Test-Validation { Remove-SpotifyArtist @("") }
    Test-Validation { Remove-SpotifyArtist @("id", "") }
    Test-PipeAlias { param($p) $p | Remove-SpotifyArtist}
}