. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyUser.ps1
}

Describe "Get-SpotifyUser" {
    It "Default" {
        $p = Get-SpotifyUser
        $p.id | Should -Not -BeNullOrEmpty
        $p.email | Should -Not -BeNullOrEmpty
    }
}

Describe "Get-SpotifyUser Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyUser }
}
