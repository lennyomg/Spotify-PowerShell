. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyArtist.ps1
}

Describe "Get-SpotifyArtist" {
    It "Defauult <value>" -ForEach @(
        @{ value = "0TnOYISbd1XYRBk9myaseg" }
        @{ value = "00FQb4jTyendYWaN8pK0wa" }
        @{ value = @("00FQb4jTyendYWaN8pK0wa", "0TnOYISbd1XYRBk9myaseg") }
    ) {
        $p = Get-SpotifyArtist -ArtistId $value
        $p.id | Should -Be $value
        $p | ForEach-Object {
            $_.type | Should -Be "artist" 
            $_.PSObject.TypeNames | Should -Contain "spfy.artist"
        }
    }
}

Describe "Get-SpotifyArtist Syntax" {
    Test-Syntax { Get-SpotifyArtist -ArtistId "id" }
    Test-Syntax { Get-SpotifyArtist -ArtistId "id1", "id2" }
    Test-Syntax { Get-SpotifyArtist "id" }
    Test-Syntax { "id" | Get-SpotifyArtist }
    Test-Syntax { "id1", "id2" | Get-SpotifyArtist }
    Test-Syntax { @(1..050) | ForEach-Object { "id{$($_)}" } | Get-SpotifyArtist }
    Test-Syntax { @(1..051) | ForEach-Object { "id{$($_)}" } | Get-SpotifyArtist } 2
    Test-Syntax { @(1..100) | ForEach-Object { "id{$($_)}" } | Get-SpotifyArtist } 2
    Test-Syntax { @(1..120) | ForEach-Object { "id{$($_)}" } | Get-SpotifyArtist } 3
    Test-Validation { Get-SpotifyArtist -ArtistId "" }
    Test-Validation { Get-SpotifyArtist -ArtistId $null }
    Test-Validation { Get-SpotifyArtist -ArtistId @() }
    Test-PipeAlias { param($p) $p | Get-SpotifyArtist }
}

Describe "Get-SpotifyArtist Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyArtist -ArtistId "00FQb4jTyendYWaN8pK0wa" }
}
