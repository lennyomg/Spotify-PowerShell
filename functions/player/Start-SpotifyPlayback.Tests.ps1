. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Start-SpotifyPlayback.ps1
}

Describe "Start-SpotifyPlayback DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Start-SpotifyPlayback
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Start-SpotifyPlayback -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Start-SpotifyPlayback Syntax" {
    Test-Syntax { Start-SpotifyPlayback -ContextUri "uri" }
    Test-Syntax { Start-SpotifyPlayback -TrackUri "uri" }
    Test-Syntax { Start-SpotifyPlayback -TrackUri "uri1", "uri2" }
    Test-Syntax { Start-SpotifyPlayback -Offset 5 }
    Test-Syntax { Start-SpotifyPlayback -Offset "spotify:uri:id" }
    Test-Syntax { Start-SpotifyPlayback -Position 5000 }
    Test-Syntax { Start-SpotifyPlayback -DeviceId "id" -ContextUri "uri" }
    Test-Validation { Suspend-SpotifyPlayback -DeviceId "" }
    Test-Validation { Suspend-SpotifyPlayback -DeviceId $null }
    Test-Validation { Suspend-SpotifyPlayback -ContextUri "" }
    Test-Validation { Suspend-SpotifyPlayback -ContextUri $null }
    Test-Validation { Suspend-SpotifyPlayback -TrackUri "" }
    Test-Validation { Suspend-SpotifyPlayback -TrackUri $null }
    Test-Validation { Suspend-SpotifyPlayback -TrackUri @("uri", "") }
    Test-Validation { Suspend-SpotifyPlayback -TrackUri @("uri", $null) }
    Test-Validation { Suspend-SpotifyPlayback -TrackUri @() }
    Test-Validation { Suspend-SpotifyPlayback -Offset "" }
    Test-Validation { Suspend-SpotifyPlayback -Offset $null }
    Test-Validation { Suspend-SpotifyPlayback -Position "" }
    Test-Validation { Suspend-SpotifyPlayback -Position $null }
}
