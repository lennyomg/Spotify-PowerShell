. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Suspend-SpotifyPlayback.ps1
}

Describe "Suspend-SpotifyPlayback DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Suspend-SpotifyPlayback
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Suspend-SpotifyPlayback -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Suspend-SpotifyPlayback Syntax" {
    Test-Syntax { Suspend-SpotifyPlayback -DeviceId "id" }
    Test-Syntax { Suspend-SpotifyPlayback "id" }
    Test-Syntax { Suspend-SpotifyPlayback }
    Test-Validation { Suspend-SpotifyPlayback -DeviceId "" }
    Test-Validation { Suspend-SpotifyPlayback -DeviceId $null }
}
