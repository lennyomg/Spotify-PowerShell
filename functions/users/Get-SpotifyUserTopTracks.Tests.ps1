. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyUserTopTracks.ps1    
}

Describe "Get-SpotifyUserTopTracks" {
    It "Default <value>" -ForEach @(
        @{ value = "short_term" }
        @{ value = "medium_term" }
        @{ value = "long_term" }
    ) {
        $p = Get-SpotifyUserTopTracks -Term $value
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.type | Should -Be "track"
            $_.id | Should -Not -BeNullOrEmpty
            $_.uri | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.track"
        }
    }
}

Describe "Get-SpotifyUserTopTracks Syntax" {
    Test-Syntax { Get-SpotifyUserTopTracks }
    Test-Syntax { Get-SpotifyUserTopTracks -Term long_term }
    Test-Syntax { Get-SpotifyUserTopTracks -Term medium_term }
    Test-Syntax { Get-SpotifyUserTopTracks -Term short_term }
    Test-Syntax { Get-SpotifyUserTopTracks long_term }
    Test-Syntax { Get-SpotifyUserTopTracks medium_term }
    Test-Syntax { Get-SpotifyUserTopTracks short_term }
    Test-Validation { Get-SpotifyUserTopTracks -Term "" }
    Test-Validation { Get-SpotifyUserTopTracks -Term $null }
    Test-Validation { Get-SpotifyUserTopTracks -Term "str" }
}

Describe "Get-SpotifyUserTopTracks Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyUserTopTracks }
}
