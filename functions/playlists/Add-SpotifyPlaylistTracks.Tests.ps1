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

        $targetTracks = Get-SpotifyPlaylistTracks -PlaylistId "37i9dQZF1DX6VdMW310YC7" | ForEach-Object { $_.id }
        $targetTracks.Count | Should -BeGreaterThan 51

        Add-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist -TrackId $targetTracks
        $sourceTracks = Get-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist | ForEach-Object { $_.id }
        $sourceTracks | Should -BeExactly $targetTracks

        Remove-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist -TrackId $sourceTracks
        $sourceTracks = Get-SpotifyPlaylistTracks -PlaylistId $sourcePlaylist
        $sourceTracks.Count | Should -Be 0
    }
}

Describe "Add-SpotifyPlaylistTracks" {
    It "Grouping" {
        $script:__e = @{ body = [System.Collections.ArrayList]@() }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body.Add(($body | ConvertFrom-Json -Depth 99)) }

        $ids = (@("id1") * 100) + (@("id2") * 100) + (@("id3") * 50);
        Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId $ids

        Assert-MockCalled Invoke-RestMethod -Times 3 -Exactly
        $__e.body[0].uris | Should -BeExactly (@("spotify:track:id1") * 100)
        $__e.body[1].uris | Should -BeExactly (@("spotify:track:id2") * 100)
        $__e.body[2].uris | Should -BeExactly (@("spotify:track:id3") * 50)
    }

    It "Pipe" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        "id1", "id2", "id3" | Add-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.uris | Should -BeExactly "spotify:track:id1", "spotify:track:id2", "spotify:track:id3"
    }

    It "Pipe Alias" {
        $script:__e = @{ body = $null }
        Mock Invoke-RestMethod -MockWith { param($body) $script:__e.body = $body | ConvertFrom-Json }

        $data = @(
            [pscustomobject]@{ id = "id1" }
            [pscustomobject]@{ id = "id2" }
            [pscustomobject]@{ id = "id3" }
        )

        $data | Add-SpotifyPlaylistTracks -PlaylistId "id"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
        $__e.body.uris | Should -BeExactly "spotify:track:id1", "spotify:track:id2", "spotify:track:id3"
    }
}

Describe "Add-SpotifyPlaylistTracks Syntax" {
    Test-Syntax { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId "id1" }
    Test-Syntax { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId "id2", "id2" }
    Test-Syntax { Add-SpotifyPlaylistTracks "id" "id1" }
    Test-Syntax { Add-SpotifyPlaylistTracks "id" "id1", "id2" }
    Test-Syntax { "id1", "id2" | Add-SpotifyPlaylistTracks -PlaylistId "id" }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "" }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId $null }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @() }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("") }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("id", "") }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @($null) }
    Test-Validation { Add-SpotifyPlaylistTracks -PlaylistId "id" -TrackId @("id", $null) }
}
