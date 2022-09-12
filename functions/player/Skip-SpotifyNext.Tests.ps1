BeforeAll {
    . $PSScriptRoot/Skip-SpotifyNext.ps1
}

Describe "Skip-SpotifyNext DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Skip-SpotifyNext
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Skip-SpotifyNext -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Skip-SpotifyNext Syntax" {
    Test-Syntax { Skip-SpotifyNext -DeviceId "id" }
    Test-Syntax { Skip-SpotifyNext "id" }
    Test-Syntax { Skip-SpotifyNext }
    Test-Validation { Skip-SpotifyNext -DeviceId "" }
    Test-Validation { Skip-SpotifyNext -DeviceId $null }
}