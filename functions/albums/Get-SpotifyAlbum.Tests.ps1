. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyAlbum.ps1
}

Describe "Get-SpotifyAlbum" {
    It "Default <value>" -ForEach @(
        @{ value = "5r36AJ6VOJtp00oxSkBZ5h" }
        @{ value = "5BWl0bB1q0TqyFmkBEupZy" }
        @{ value = @("5BWl0bB1q0TqyFmkBEupZy", "5r36AJ6VOJtp00oxSkBZ5h") }
    ) {
        $p = Get-SpotifyAlbum -AlbumId $value
        $p.id | Should -Be $value
        $p | ForEach-Object {
            $_.type | Should -Be "album"
            $_.PSObject.TypeNames | Should -Contain "spfy.album"
        }
    }
}

Describe "Get-SpotifyAlbum Syntax" {
    Test-Syntax { Get-SpotifyAlbum -AlbumId "id" }
    Test-Syntax { Get-SpotifyAlbum "id" }
    Test-Syntax { "id" | Get-SpotifyAlbum }
    Test-Syntax { "id1", "id2" | Get-SpotifyAlbum }
    Test-Syntax { @(1..20) | ForEach-Object { "id{$($_)}" } | Get-SpotifyAlbum }
    Test-Syntax { @(1..21) | ForEach-Object { "id{$($_)}" } | Get-SpotifyAlbum } 2
    Test-Syntax { @(1..40) | ForEach-Object { "id{$($_)}" } | Get-SpotifyAlbum } 2
    Test-Syntax { @(1..45) | ForEach-Object { "id{$($_)}" } | Get-SpotifyAlbum } 3
    Test-Validation { Get-SpotifyAlbum -AlbumId "" }
    Test-Validation { Get-SpotifyAlbum -AlbumId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyAlbum }
}

Describe "Get-SpotifyAlbum Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyAlbum -AlbumId "5BWl0bB1q0TqyFmkBEupZy" }
}
