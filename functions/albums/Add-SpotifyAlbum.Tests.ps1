BeforeAll { 
    . $PSScriptRoot/Add-SpotifyAlbum.ps1
    . $PSScriptRoot/Remove-SpotifyAlbum.ps1
    . $PSScriptRoot/Get-SpotifySavedAlbums.ps1
    . $PSScriptRoot/Get-SpotifyAlbum.ps1
}

Describe "Add-SpotifyAlbum / Remove-SpotifyAlbum" {
    It "Default <value>" -ForEach @(
        @{ value = "5r36AJ6VOJtp00oxSkBZ5h" } 
        @{ value = "5BWl0bB1q0TqyFmkBEupZy" }
        @{ value = "5r36AJ6VOJtp00oxSkBZ5h", "5BWl0bB1q0TqyFmkBEupZy" }
    ) {
        $albums = { Get-SpotifySavedAlbums | ForEach-Object { $_.id } }
        $value | Should -Not -BeIn (& $albums)

        Add-SpotifyAlbum -AlbumId $value
        $value | Should -BeIn (& $albums)

        Remove-SpotifyAlbum -AlbumId $value
        $value | Should -Not -BeIn (& $albums)
    }
}

Describe "Add-SpotifyAlbum Syntax" {
    Test-Syntax { Add-SpotifyAlbum -AlbumId "id" }
    Test-Syntax { Add-SpotifyAlbum -AlbumId "id1", "id2" }
    Test-Syntax { Add-SpotifyAlbum "id" }
    Test-Syntax { Add-SpotifyAlbum "id1", "id2" }
    Test-Syntax { "id" | Add-SpotifyAlbum }
    Test-Syntax { "id1", "id2" | Add-SpotifyAlbum } 2
    Test-Validation { Add-SpotifyAlbum "" }
    Test-Validation { Add-SpotifyAlbum $null }
    Test-Validation { Add-SpotifyAlbum @() }
    Test-Validation { Add-SpotifyAlbum @("") }
    Test-Validation { Add-SpotifyAlbum @("id", "") }
    Test-PipeAlias { param($p) $p | Add-SpotifyAlbum }
}