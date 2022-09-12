BeforeAll {
    . $PSScriptRoot/Get-SpotifyQueue.ps1
}

Describe "Get-SpotifyQueue" {
    It "Default" {
        Get-SpotifyQueue
    }
}

Describe "Get-SpotifyQueue Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyQueue }
}