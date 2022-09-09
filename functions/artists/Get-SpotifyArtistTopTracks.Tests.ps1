BeforeAll {
    . $PSScriptRoot/Get-SpotifyArtistTopTracks.ps1
}

Describe "Get-SpotifyArtistTopTracks" {
    It "Default <artistId> <market>" -ForEach @(
        @{ artistId = "2ye2Wgw4gimLv2eAKyk1NB"; market = "US" }
        @{ artistId = "6kACVPfCOnqzgfEF5ryl0x"; market = "GB" }
    ) {
        $p = Get-SpotifyArtistTopTracks -ArtistId $artistId -Market $market
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object { 
            $_.type | Should -Be "track" 
            $_.id | Should -Not -BeNullOrEmpty
            $_.uri | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyArtistTopTracks Syntax" {
    Test-Syntax { Get-SpotifyArtistTopTracks -ArtistId "id" }
    Test-Syntax { Get-SpotifyArtistTopTracks -ArtistId "id" -Market "US" }
    Test-Syntax { Get-SpotifyArtistTopTracks "id" }
    Test-Syntax { Get-SpotifyArtistTopTracks "id" -Market "US" }
    Test-Validation { Get-SpotifyArtistTopTracks -ArtistId "" }
    Test-Validation { Get-SpotifyArtistTopTracks -ArtistId $null }
    Test-Validation { Get-SpotifyArtistTopTracks -ArtistId "id" -Market "" }
    Test-Validation { Get-SpotifyArtistTopTracks -ArtistId "id" -Market $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyArtistTopTracks }
}

Describe "Get-SpotifyArtistTopTracks Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyArtistTopTracks -ArtistId "00FQb4jTyendYWaN8pK0wa" }
}