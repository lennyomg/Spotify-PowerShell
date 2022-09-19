. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyAlbumTracks.ps1
}

Describe "Get-SpotifyAlbumTracks" {
    It "Default <value>" -ForEach @(
        @{ value = "4aawyAB9vmqN3uQ7FjRGTy" }
        @{ value = "6BkAzZNlSz80Iz3oTlKHet" }
    ) {
        $p = Get-SpotifyAlbumTracks -AlbumId $value
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object { 
            $_.type | Should -Be "track"
            $_.id | Should -Not -BeNullOrEmpty
            $_.uri | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyAlbumTracks Syntax" {
    Test-Syntax { Get-SpotifyAlbumTracks -AlbumId "id" }
    Test-Syntax { Get-SpotifyAlbumTracks "id" }
    Test-Syntax { "id" | Get-SpotifyAlbumTracks }
    Test-Syntax { "id1", "id2" | Get-SpotifyAlbumTracks } 2
    Test-Validation { Get-SpotifyAlbumTracks -AlbumId "" }
    Test-Validation { Get-SpotifyAlbumTracks -AlbumId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyAlbumTracks }
}

Describe "Get-SpotifyAlbumTracks Output" -Tag "Output" {
    It "Output" {
        Write-SpotifyOutput { Get-SpotifyAlbumTracks -AlbumId "6BkAzZNlSz80Iz3oTlKHet" }
    }
}
