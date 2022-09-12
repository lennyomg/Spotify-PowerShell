BeforeAll {
    . $PSScriptRoot/Resume-SpotifyPlayback.ps1
}

Describe "Resume-SpotifyPlayback DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Resume-SpotifyPlayback
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Resume-SpotifyPlayback -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Resume-SpotifyPlayback Syntax" {
    Test-Syntax { Resume-SpotifyPlayback -DeviceId "id" }
    Test-Syntax { Resume-SpotifyPlayback "id" }
    Test-Syntax { Resume-SpotifyPlayback }
    Test-Validation { Resume-SpotifyPlayback -DeviceId "" }
    Test-Validation { Resume-SpotifyPlayback -DeviceId $null }
}