. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyCurrentlyPlaying.ps1
}

Describe "Get-SpotifyCurrentlyPlaying" {
    It "Default" {
        Get-SpotifyCurrentlyPlaying
    }
}

Describe "Get-SpotifyCurrentlyPlaying Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyCurrentlyPlaying }
}
