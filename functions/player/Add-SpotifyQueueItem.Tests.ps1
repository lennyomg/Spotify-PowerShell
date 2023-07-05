. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Add-SpotifyQueueItem.ps1
}

Describe "Add-SpotifyQueueItem DeviceId" {
    BeforeEach {
        $script:e = @{}
        Mock Invoke-RestMethod -Verifiable -MockWith { param($uri) $script:e.uri = $uri }
    }

    It "Args Default" {
        Add-SpotifyQueueItem -ItemUri "uri"
        $script:e.uri | Should -Not -BeLike "*device_id*"
    }

    It "Args DeviceId" {
        Add-SpotifyQueueItem -ItemUri "uri" -DeviceId "214354"
        $script:e.uri | Should -BeLike "*device_id=214354"
    }
}

Describe "Add-SpotifyQueueItem Syntax" {
    Test-Syntax { Add-SpotifyQueueItem -ItemUri "uri" }
    Test-Syntax { Add-SpotifyQueueItem -ItemUri "uri" -DeviceId "id" }
    Test-Syntax { Add-SpotifyQueueItem "uri" "id" }
    Test-Syntax { "uri1", "uri2" | Add-SpotifyQueueItem } 2
    Test-Syntax { "uri1", "uri2" | Add-SpotifyQueueItem -DeviceId "id" } 2
    Test-Validation { Add-SpotifyQueueItem -DeviceId "" }
    Test-Validation { Add-SpotifyQueueItem -DeviceId $null }
    Test-Validation { Add-SpotifyQueueItem -ItemUri "" }
    Test-Validation { Add-SpotifyQueueItem -ItemUri $null }
    Test-PipeAlias { param($p) $p | Add-SpotifyQueueItem } @([pscustomobject]@{ uri = "uri1"; dummy = "dummy" }, [pscustomobject]@{ uri = "uri2"; dummy = "dummy" })
}
