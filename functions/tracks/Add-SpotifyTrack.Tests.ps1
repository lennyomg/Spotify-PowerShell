. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Add-SpotifyTrack.ps1
    . $PSScriptRoot/Remove-SpotifyTrack.ps1
    . $PSScriptRoot/Get-SpotifyTrack.ps1
    . $PSScriptRoot/Get-SpotifySavedTracks.ps1
}

Describe "Add-SpotifyTrack / Remove-SpotifyTrack" {
    It "Default <value>" -ForEach @(
        @{ value = "4iV5W9uYEdYUVa79Axb7Rh" }
        @{ value = "1301WleyT98MSxVHPZCA6M" }
        @{ value = "1301WleyT98MSxVHPZCA6M", "4iV5W9uYEdYUVa79Axb7Rh" }
    ) {
        $tracks = { Get-SpotifySavedTracks | ForEach-Object { $_.id } }
        $value | Should -Not -BeIn (& $tracks)

        Add-SpotifyTrack -TrackId $value
        $value | Should -BeIn (& $tracks)

        Remove-SpotifyTrack -TrackId $value
        $value | Should -Not -BeIn (& $tracks)
    }
}

Describe "Add-SpotifyTrack Syntax" {
    Test-Syntax { Add-SpotifyTrack -TrackId "id" }
    Test-Syntax { Add-SpotifyTrack "id" }
    Test-Syntax { "id" | Add-SpotifyTrack }
    Test-Syntax { "id1", "id2" | Add-SpotifyTrack } 2
    Test-Validation { Add-SpotifyTrack -TrackId "" }
    Test-Validation { Add-SpotifyTrack -TrackId $null }
    Test-Validation { Add-SpotifyTrack -TrackId @() }
    Test-Validation { Add-SpotifyTrack -TrackId @("") }
    Test-Validation { Add-SpotifyTrack -TrackId @($null) }
    Test-Validation { Add-SpotifyTrack -TrackId @("id", "") }
    Test-Validation { Add-SpotifyTrack -TrackId @("id", $null) }
    Test-Validation { Add-SpotifyTrack -TrackId (@("id") * 51) }
    Test-PipeAlias { param($p) $p | Add-SpotifyTrack }
}
