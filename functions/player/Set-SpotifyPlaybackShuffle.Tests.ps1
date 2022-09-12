BeforeAll {
    . $PSScriptRoot/Set-SpotifyPlaybackShuffle.ps1
}

Describe "Set-SpotifyPlaybackShuffle DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Set-SpotifyPlaybackShuffle -State $false
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Set-SpotifyPlaybackShuffle -State $false -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Set-SpotifyPlaybackShuffle Syntax" {
    Test-Syntax { Set-SpotifyPlaybackShuffle -State $false -DeviceId "id" }
    Test-Syntax { Set-SpotifyPlaybackShuffle -State $false "id" }
    Test-Syntax { Set-SpotifyPlaybackShuffle $true "id" }
    Test-Syntax { Set-SpotifyPlaybackShuffle $true }
    Test-Validation { Set-SpotifyPlaybackShuffle -State "none" }
    Test-Validation { Set-SpotifyPlaybackShuffle -State $true -DeviceId "" }
    Test-Validation { Set-SpotifyPlaybackShuffle -State $false -DeviceId $null }
}