. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyDevices.ps1
}

Describe "Get-SpotifyDevices" {
    It "Default" {
        Get-SpotifyDevices
    }
}

Describe "Get-SpotifyDevices Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyDevices }
}
