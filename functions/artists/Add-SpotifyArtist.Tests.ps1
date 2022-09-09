BeforeAll { 
    . $PSScriptRoot/Add-SpotifyArtist.ps1
    . $PSScriptRoot/Remove-SpotifyArtist.ps1
    . $PSScriptRoot/Get-SpotifySavedArtists.ps1
}

Describe "Add-SpotifyArtist / Remove-SpotifyArtist" {
    It "Default <value>" -ForEach @(
        @{ value = "6kACVPfCOnqzgfEF5ryl0x" } 
        @{ value = "2ye2Wgw4gimLv2eAKyk1NB" }
        @{ value = "2ye2Wgw4gimLv2eAKyk1NB", "6kACVPfCOnqzgfEF5ryl0x" }
    ) {
        $artists = { Get-SpotifySavedArtists | ForEach-Object { $_.id } }
        $value | Should -Not -BeIn (& $artists)

        Add-SpotifyArtist -ArtistId $value
        $value | Should -BeIn (& $artists)

        Remove-SpotifyArtist -ArtistId $value
        $value | Should -Not -BeIn (& $artists)
    }
}

Describe "Add-SpotifyArtist Syntax" {
    Test-Syntax { Add-SpotifyArtist -ArtistId "id" }
    Test-Syntax { Add-SpotifyArtist -ArtistId "id1", "id2" }
    Test-Syntax { Add-SpotifyArtist -ArtistId @("id1", "id2") }
    Test-Syntax { Add-SpotifyArtist "id" }
    Test-Syntax { Add-SpotifyArtist "id1", "id2" }
    Test-Syntax { "id" | Add-SpotifyArtist }
    Test-Syntax { "id1", "id2" | Add-SpotifyArtist } 2
    Test-Validation { Add-SpotifyArtist "" }
    Test-Validation { Add-SpotifyArtist $null }
    Test-Validation { Add-SpotifyArtist @() }
    Test-Validation { Add-SpotifyArtist @("") }
    Test-Validation { Add-SpotifyArtist @("id", "") }
    Test-PipeAlias { param($p) $p | Add-SpotifyArtist }
}