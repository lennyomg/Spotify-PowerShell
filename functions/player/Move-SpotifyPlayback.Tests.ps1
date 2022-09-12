BeforeAll {
    Get-ChildItem *.ps1 -Exclude *.Tests.* | ForEach-Object { . $_.FullName }
}

Describe "Move-SpotifyPlayback" -Tag "Playback" {
    It "Default" {
        $env:SpotifyDeviceId | Should -Not -BeNullOrEmpty
        $env:SpotifyDeviceId2 | Should -Not -BeNullOrEmpty

        $d = Get-SpotifyDevices
        $d.id | Should -Contain $env:SpotifyDeviceId
        $d.id | Should -Contain $env:SpotifyDeviceId2

        Start-SpotifyPlayback -DeviceId $env:SpotifyDeviceId -ContextUri "spotify:playlist:37i9dQZF1DX6VdMW310YC7" 
        sleep 3

        Move-SpotifyPlayback -DeviceId $env:SpotifyDeviceId2
        sleep 3

        $s = Get-SpotifyPlaybackState
        $s.device.id | Should -Be $env:SpotifyDeviceId2
    }
}

Describe "Move-SpotifyPlayback Syntax" {
    Test-Syntax { Move-SpotifyPlayback -DeviceId "id" }
    Test-Syntax { Move-SpotifyPlayback "id" }
    Test-Validation { Move-SpotifyPlayback -DeviceId "" }
    Test-Validation { Move-SpotifyPlayback -DeviceId $null }
}