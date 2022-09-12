BeforeAll {
    Get-ChildItem *.ps1 -Exclude *.Tests.* | ForEach-Object { . $_.FullName }
}

Describe "Get-SpotifyPlaybackState" -Tag "Playback" {

    BeforeEach {
        $env:SpotifyDeviceId | Should -Not -BeNullOrEmpty
        $d = Get-SpotifyDevices
        $d.id | Should -Contain $env:SpotifyDeviceId
    }

    It "All" {
        
        # start playback

        Start-SpotifyPlayback `
            -DeviceId $env:SpotifyDeviceId `
            -ContextUri "spotify:album:0r9awI5WRCZpwk0aVQ4bKO" `
            -Offset 1 `
            -Position 2000

        sleep 3
        $s = Get-SpotifyPlaybackState
        $s.device.id | Should -Be $env:SpotifyDeviceId
        $s.is_playing | Should -Be $true
        $s.item.type | Should -Be "track"
        $s.item.id | Should -Be "0nys6GusuHnjSYLW0PYYb7"
        $s.shuffle_state | Should -Be $false
        $s.repeat_state | Should -Be "off"
        $s.progress_ms | Should -BeGreaterThan 1900

        # pause

        Suspend-SpotifyPlayback

        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.is_playing | Should -Be $false

        # repeat on

        Set-SpotifyPlaybackRepeat track
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.repeat_state | Should -Be "track"

        # shuffle on

        Set-SpotifyPlaybackShuffle $true
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.shuffle_state | Should -Be $true

        # repeat shuffle off

        Set-SpotifyPlaybackRepeat off
        Set-SpotifyPlaybackShuffle $false
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.repeat_state | Should -Be "off"
        $s.shuffle_state | Should -Be $false

        # resume

        Resume-SpotifyPlayback
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.is_playing | Should -Be $true

        # next

        Skip-SpotifyNext
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.item.type | Should -Be "track"
        $s.item.id | Should -Be "3EwTIu5qka2l5ZekB0b6QC"

        # position

        Set-SpotifyPlaybackPosition 25000
        sleep 2
        $s = Get-SpotifyPlaybackState
        $s.progress_ms | Should -BeGreaterThan 20000
        $s.progress_ms | Should -BeLessThan 35000
        
        # previous

        Skip-SpotifyPrevious
        sleep 1
        $s = Get-SpotifyPlaybackState
        $s.item.type | Should -Be "track"
        $s.item.id | Should -Be "0nys6GusuHnjSYLW0PYYb7"

        # currently playing

        $c = Get-SpotifyCurrentlyPlaying
        $c.item.id | Should -Be $s.item.id

        # volume
        
        Set-SpotifyPlaybackVolume 0
        sleep 1
        Set-SpotifyPlaybackVolume 100
        sleep 1
        Set-SpotifyPlaybackVolume 25
        sleep 1

        # queue

        Add-SpotifyQueueItem -ItemUri "spotify:track:1Wn0A9wVEQXj2JVbdsclpi"
        $q = Get-SpotifyQueue
        $q.queue.id | Should -Contain "1Wn0A9wVEQXj2JVbdsclpi"

        # pause

        Suspend-SpotifyPlayback -DeviceId $env:SpotifyDeviceId
    }

    It "Tracks" {
        Start-SpotifyPlayback `
            -TrackUri "spotify:track:6dOuyNJIAQC7ws10eEk0G9", "spotify:track:2Eqv3lSPNQCbtHfHTIlyKK", "spotify:track:4Xz2mxHREzWiEr0AyCJuU6" `
            -Offset "spotify:track:2Eqv3lSPNQCbtHfHTIlyKK" `
            -Position 5000 `
            -DeviceId $env:SpotifyDeviceId

        sleep 3
        $s = Get-SpotifyPlaybackState
        $s.device.id | Should -Be $env:SpotifyDeviceId
        $s.is_playing | Should -Be $true
        $s.item.type | Should -Be "track"
        $s.item.id | Should -Be "2Eqv3lSPNQCbtHfHTIlyKK"

        Suspend-SpotifyPlayback -DeviceId $env:SpotifyDeviceId
    }
}

Describe "Get-SpotifyPlaybackState Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyPlaybackState }
}