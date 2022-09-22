. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyNewReleases.ps1
}

Describe "Get-SpotifyNewReleases" {
    It "Default" {
        $p = Get-SpotifyNewReleases
        $p | ForEach-Object {
            $_.type | Should -Be "album"
            $_.id | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.album"
        }
    }
}

Describe "Get-SpotifyNewReleases Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyNewReleases }
}
