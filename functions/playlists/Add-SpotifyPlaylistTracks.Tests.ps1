. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Add-SpotifyPlaylistTracks.ps1
    . $PSScriptRoot/Remove-SpotifyPlaylistTracks.ps1
    . $PSScriptRoot/Get-SpotifyPlaylistTracks.ps1
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
}

Describe "Add-SpotifyPlaylistTracks / Remove-SpotifyPlaylistTracks" {
    It "Default" {
        $sourcePlaylist = (Get-SpotifySavedPlaylists | Where-Object { $_.name -eq "ps-test" }).id
        $sourcePlaylist | Should -Not -BeNullOrEmpty

        $sourceTracks = Get-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist
        $sourceTracks.Count | Should -Be 0

        $targetTracks = Get-SpotifyPlaylistTracks -PlaylistId "37i9dQZF1DX6VdMW310YC7" | ForEach-Object { $_.uri }
        $targetTracks.Count | Should -BeGreaterThan 100

        Add-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist -TrackUri $targetTracks
        $sourceTracks = Get-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist | ForEach-Object { $_.uri }
        $sourceTracks | Should -BeExactly $targetTracks

        Remove-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist -TrackUri $sourceTracks
        $sourceTracks = Get-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist
        $sourceTracks.Count | Should -Be 0
    }
}

Describe "Add-SpotifyPlaylistTracks" {
    It "Grouping" {
        $script:__e = @{ body = [System.Collections.ArrayList]@() }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body.Add(($body | ConvertFrom-Json -Depth 99)) }

        $ids = (@("uri1") * 100) + (@("uri2") * 100) + (@("uri3") * 50);
        Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri $ids

        Assert-MockCalled Invoke-RestMethod -Times 3 -Exactly
        $__e.body[0].uris | Should -BeExactly (@("uri1") * 100)
        $__e.body[1].uris | Should -BeExactly (@("uri2") * 100)
        $__e.body[2].uris | Should -BeExactly (@("uri3") * 50)
    }

    It "Pipe" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        "uri1", "uri2", "uri3" | Add-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.uris | Should -BeExactly "uri1", "uri2", "uri3"
    }

    It "Pipe Alias" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        $data = @(
            [pscustomobject]@{ uri = "uri1" }
            [pscustomobject]@{ uri = "uri2" }
            [pscustomobject]@{ uri = "uri3" }
        )

        $data | Add-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.uris | Should -BeExactly "uri1", "uri2", "uri3"
    }
}

Describe "Add-SpotifyPlaylistTracks Syntax" {
    Test-Syntax { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri "uri1" }
    Test-Syntax { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri "uri2", "uri2" }
    Test-Syntax { Add-SpotifyPlaylistTracks "id" "uri1" }
    Test-Syntax { Add-SpotifyPlaylistTracks "id" "uri1", "uri2" }
    Test-Syntax { "uri1", "uri2" | Add-SpotifyPlaylistTracks -PlaylistId "id" }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "" }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId $null }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @() }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("") }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("uri", "") }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @($null) }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackUri @("uri", $null) }
}
