. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Remove-SpotifyPlaylistTracks.ps1
}

# see Add-SpotifyPlaylistTracks.Tests.ps1

Describe "Remove-SpotifyPlaylistTracks" {
    It "Grouping" {
        $script:__e = @{ body = [System.Collections.ArrayList]@() }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body.Add(($body | ConvertFrom-Json -Depth 99)) }

        $ids = (@("uri1") * 100) + (@("uri2") * 100) + (@("uri3") * 50);
        Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri $ids

        Assert-MockCalled Invoke-RestMethod -Times 3 -Exactly
        $__e.body[0].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("uri1") * 100)
        $__e.body[1].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("uri2") * 100)
        $__e.body[2].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("uri3") * 50)
    }

    It "Pipe" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        "uri1", "uri2", "uri3" | Remove-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.tracks | ForEach-Object { $_.uri } | Should -BeExactly "uri1", "uri2", "uri3"
    }

    It "Pipe Alias" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        $data = @(
            [pscustomobject]@{ uri = "uri1" }
            [pscustomobject]@{ uri = "uri2" }
            [pscustomobject]@{ uri = "uri3" }
        )

        $data | Remove-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.tracks | ForEach-Object { $_.uri } | Should -BeExactly "uri1", "uri2", "uri3"
    }
}

Describe "Remove-SpotifyPlaylistTracks Syntax" {
    Test-Syntax { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri "uri1" }
    Test-Syntax { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri "uri2", "uri2" }
    Test-Syntax { Remove-SpotifyPlaylistTracks "id" "uri1" }
    Test-Syntax { Remove-SpotifyPlaylistTracks "id" "uri1", "uri2" }
    Test-Syntax { "uri1", "uri2" | Remove-SpotifyPlaylistTracks -PlaylistId "id" }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "" }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId $null }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @() }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("") }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("uri", "") }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @($null) }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("uri", $null) }
}
