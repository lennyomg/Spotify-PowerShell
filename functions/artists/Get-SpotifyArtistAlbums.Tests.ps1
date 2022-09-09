BeforeAll {
    . $PSScriptRoot/Get-SpotifyArtistAlbums.ps1
}

Describe "Get-SpotifyArtistAlbums" {
    It "Default <value>" -ForEach @(
        @{ value = "0TnOYISbd1XYRBk9myaseg" }
        @{ value = "00FQb4jTyendYWaN8pK0wa" }
    ) {
        $p = Get-SpotifyArtistAlbums -ArtistId $value
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.type | Should -Be "album" 
            $_.id | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyArtistAlbums Syntax" {
    Test-Syntax { Get-SpotifyArtistAlbums -ArtistId "id" }
    Test-Syntax { Get-SpotifyArtistAlbums "id" }
    Test-Syntax { "id" | Get-SpotifyArtistAlbums }
    Test-Syntax { "id1", "id2" | Get-SpotifyArtistAlbums } 2
    Test-Validation { Get-SpotifyArtistAlbums -ArtistId "" }
    Test-Validation { Get-SpotifyArtistAlbums -ArtistId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyArtistAlbums }
}

Describe "Get-SpotifyArtistAlbums Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyArtistAlbums -ArtistId "00FQb4jTyendYWaN8pK0wa" }
}