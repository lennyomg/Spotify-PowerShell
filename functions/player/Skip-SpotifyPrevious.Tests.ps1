BeforeAll {
    . $PSScriptRoot/Skip-SpotifyPrevious.ps1
}

Describe "Skip-SpotifyPrevious DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Skip-SpotifyPrevious
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Skip-SpotifyPrevious -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Skip-SpotifyPrevious Syntax" {
    Test-Syntax { Skip-SpotifyPrevious -DeviceId "id" }
    Test-Syntax { Skip-SpotifyPrevious "id" }
    Test-Syntax { Skip-SpotifyPrevious }
    Test-Validation { Skip-SpotifyPrevious -DeviceId "" }
    Test-Validation { Skip-SpotifyPrevious -DeviceId $null }
}