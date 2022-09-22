. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Remove-SpotifyPlaylistTracks.ps1
}

# see Add-SpotifyPlaylistTracks.Tests.ps1

Describe "Remove-SpotifyPlaylistTracks" {
    It "Grouping" {
        $script:__e = @{ body = [System.Collections.ArrayList]@() }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body.Add(($body | ConvertFrom-Json -Depth 99)) }

        $ids = (@("id1") * 100) + (@("id2") * 100) + (@("id3") * 50);
        Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId $ids

        Assert-MockCalled Invoke-RestMethod -Times 3 -Exactly
        $__e.body[0].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("spotify:track:id1") * 100)
        $__e.body[1].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("spotify:track:id2") * 100)
        $__e.body[2].tracks | ForEach-Object { $_.uri } | Should -BeExactly (@("spotify:track:id3") * 50)
    }

    It "Pipe" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        "id1", "id2", "id3" | Remove-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.tracks | ForEach-Object { $_.uri } | Should -BeExactly "spotify:track:id1", "spotify:track:id2", "spotify:track:id3"
    }

    It "Pipe Alias" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        $data = @(
            [pscustomobject]@{ id = "id1" }
            [pscustomobject]@{ id = "id2" }
            [pscustomobject]@{ id = "id3" }
        )

        $data | Remove-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.tracks | ForEach-Object { $_.uri } | Should -BeExactly "spotify:track:id1", "spotify:track:id2", "spotify:track:id3"
    }
}

Describe "Remove-SpotifyPlaylistTracks Syntax" {
    Test-Syntax { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId "id1" }
    Test-Syntax { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId "id2", "id2" }
    Test-Syntax { Remove-SpotifyPlaylistTracks "id" "id1" }
    Test-Syntax { Remove-SpotifyPlaylistTracks "id" "id1", "id2" }
    Test-Syntax { "id1", "id2" | Remove-SpotifyPlaylistTracks -PlaylistId "id" }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "" }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId $null }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @() }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("") }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("id", "") }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @($null) }
    Test-Validation { Remove-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("id", $null) }
}
