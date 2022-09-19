. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyMarkets.ps1
}

Describe "Get-SpotifyMarkets" {
    It "Default" {
        $p = Get-SpotifyMarkets
        "US" | Should -BeIn $p
    }
}

Describe "Get-SpotifyMarkets Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyMarkets }
}
