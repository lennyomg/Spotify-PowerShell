. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyArtistRelatedArtists.ps1
}

Describe "Get-SpotifyArtistRelatedArtists" {
    It "Default <value>" -ForEach @(
        @{ value = "2ye2Wgw4gimLv2eAKyk1NB" }
        @{ value = "6kACVPfCOnqzgfEF5ryl0x" }
    ) {
        $p = Get-SpotifyArtistRelatedArtists -ArtistId $value
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.type | Should -Be "artist"
            $_.id | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyArtistRelatedArtists Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyArtistRelatedArtists -ArtistId "00FQb4jTyendYWaN8pK0wa" }
}
