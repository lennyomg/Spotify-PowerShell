BeforeAll {
    . $PSScriptRoot/Get-SpotifyArtist.ps1
    . $PSScriptRoot/Get-SpotifySavedArtists.ps1
}

Describe "Get-SpotifyArtist" {
    It "Defauult <value>" -ForEach @(
        @{ value = "0TnOYISbd1XYRBk9myaseg" }
        @{ value = "00FQb4jTyendYWaN8pK0wa" }
    ) {
        $p = Get-SpotifyArtist -ArtistId $value
        $p.id | Should -Be $value
        $p.type | Should -Be "artist"
    }
}

Describe "Get-SpotifyArtist Syntax" {
    Test-Syntax { Get-SpotifyArtist -ArtistId "id" }
    Test-Syntax { Get-SpotifyArtist "id" }
    Test-Syntax { "id" | Get-SpotifyArtist }
    Test-Syntax { "id1", "id2" | Get-SpotifyArtist } 2
    Test-Validation { Get-SpotifyArtist -ArtistId "" }
    Test-Validation { Get-SpotifyArtist -ArtistId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyArtist }
}

Describe "Get-SpotifyArtist Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyArtist -ArtistId "00FQb4jTyendYWaN8pK0wa" }
}