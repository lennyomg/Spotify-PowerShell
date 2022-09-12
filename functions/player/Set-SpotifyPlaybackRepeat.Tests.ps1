BeforeAll {
    . $PSScriptRoot/Set-SpotifyPlaybackRepeat.ps1
}

Describe "Set-SpotifyPlaybackRepeat DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Set-SpotifyPlaybackRepeat -State off
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Set-SpotifyPlaybackRepeat -State off -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Set-SpotifyPlaybackRepeat Syntax" {
    Test-Syntax { Set-SpotifyPlaybackRepeat -State "off" -DeviceId "id" }
    Test-Syntax { Set-SpotifyPlaybackRepeat -State "off" "id" }
    Test-Syntax { Set-SpotifyPlaybackRepeat "off" "id" }
    Test-Syntax { Set-SpotifyPlaybackRepeat track }
    Test-Syntax { Set-SpotifyPlaybackRepeat context }
    Test-Syntax { Set-SpotifyPlaybackRepeat off }
    Test-Validation { Set-SpotifyPlaybackRepeat -State "none" }
    Test-Validation { Set-SpotifyPlaybackRepeat -State 1000 -DeviceId "" }
    Test-Validation { Set-SpotifyPlaybackRepeat -State 1000 -DeviceId $null }
}