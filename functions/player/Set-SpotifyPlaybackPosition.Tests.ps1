BeforeAll {
    . $PSScriptRoot/Set-SpotifyPlaybackPosition.ps1
}

Describe "Set-SpotifyPlaybackPosition DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Set-SpotifyPlaybackPosition -Position 1000
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Set-SpotifyPlaybackPosition -Position 1000 -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Set-SpotifyPlaybackPosition Syntax" {
    Test-Syntax { Set-SpotifyPlaybackPosition -Position 1000 -DeviceId "id" }
    Test-Syntax { Set-SpotifyPlaybackPosition -Position 1000 "id" }
    Test-Syntax { Set-SpotifyPlaybackPosition 1000 "id" }
    Test-Syntax { Set-SpotifyPlaybackPosition 1000 }
    Test-Validation { Set-SpotifyPlaybackPosition -Position -1 }
    Test-Validation { Set-SpotifyPlaybackPosition -Position 1000 -DeviceId "" }
    Test-Validation { Set-SpotifyPlaybackPosition -Position 1000 -DeviceId $null }
}