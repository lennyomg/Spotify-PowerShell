BeforeAll {
    . $PSScriptRoot/Get-SpotifyAlbum.ps1
    . $PSScriptRoot/Get-SpotifySavedAlbums.ps1
}

Describe "Get-SpotifyAlbum" {
    It "Default <value>" -ForEach @(
        @{ value = "5r36AJ6VOJtp00oxSkBZ5h" }
        @{ value = "5BWl0bB1q0TqyFmkBEupZy" }
    ) {
        $p = Get-SpotifyAlbum -AlbumId $value
        $p.id | Should -Be $value
        $p.type | Should -Be "album"
    }
}

Describe "Get-SpotifyAlbum Syntax" {
    Test-Syntax { Get-SpotifyAlbum -AlbumId "id" }
    Test-Syntax { Get-SpotifyAlbum "id" }
    Test-Syntax { "id" | Get-SpotifyAlbum }
    Test-Syntax { "id1", "id2" | Get-SpotifyAlbum } 2
    Test-Validation { Get-SpotifyAlbum -AlbumId "" }
    Test-Validation { Get-SpotifyAlbum -AlbumId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyAlbum }
}

Describe "Get-SpotifyAlbum Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyAlbum -AlbumId "5BWl0bB1q0TqyFmkBEupZy" }
}