. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Set-SpotifyPlaybackVolume.ps1
}

Describe "Set-SpotifyPlaybackVolume DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Set-SpotifyPlaybackVolume -VolumePercent 50
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Set-SpotifyPlaybackVolume -VolumePercent 50 -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Set-SpotifyPlaybackVolume Syntax" {
    Test-Syntax { Set-SpotifyPlaybackVolume -VolumePercent 25 -DeviceId "id" }
    Test-Syntax { Set-SpotifyPlaybackVolume -VolumePercent 25 "id" }
    Test-Syntax { Set-SpotifyPlaybackVolume 25 "id" }
    Test-Syntax { Set-SpotifyPlaybackVolume 0 }
    Test-Syntax { Set-SpotifyPlaybackVolume 50 }
    Test-Syntax { Set-SpotifyPlaybackVolume 100 }
    Test-Validation { Set-SpotifyPlaybackVolume -VolumePercent -1 }
    Test-Validation { Set-SpotifyPlaybackVolume -VolumePercent 101 }
    Test-Validation { Set-SpotifyPlaybackVolume -VolumePercent 50 -DeviceId "" }
    Test-Validation { Set-SpotifyPlaybackVolume -VolumePercent 50 -DeviceId $null }
}
