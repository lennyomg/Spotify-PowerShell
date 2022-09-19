. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Remove-SpotifyTrack.ps1
}

# Add-SpotifyTrack.Tests.ps1 

Describe "Remove-SpotifyTrack Syntax" {
    Test-Syntax { Remove-SpotifyTrack -TrackId "id" }
    Test-Syntax { Remove-SpotifyTrack "id" }
    Test-Syntax { "id" | Remove-SpotifyTrack }
    Test-Syntax { "id1", "id2" | Remove-SpotifyTrack } 2
    Test-Validation { Remove-SpotifyTrack -TrackId "" }
    Test-Validation { Remove-SpotifyTrack -TrackId $null }
    Test-Validation { Remove-SpotifyTrack -TrackId @() }
    Test-Validation { Remove-SpotifyTrack -TrackId @("") }
    Test-Validation { Remove-SpotifyTrack -TrackId @($null) }
    Test-Validation { Remove-SpotifyTrack -TrackId @("id", "") }
    Test-Validation { Remove-SpotifyTrack -TrackId @("id", $null) }
    Test-Validation { Remove-SpotifyTrack -TrackId (@("id") * 51) }
    Test-PipeAlias { param($p) $p | Remove-SpotifyTrack }
}
