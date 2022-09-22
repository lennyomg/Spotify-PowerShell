. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyUserTopArtists.ps1    
}

Describe "Get-SpotifyUserTopArtists" {
    It "Default <value>" -ForEach @(
        @{ value = "short_term" }
        @{ value = "medium_term" }
        @{ value = "long_term" }
    ) {
        $p = Get-SpotifyUserTopArtists -Term $value 
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.type | Should -Be "artist"
            $_.id | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.artist"
        }
    }
}

Describe "Get-SpotifyUserTopArtists Syntax" {
    Test-Syntax { Get-SpotifyUserTopArtists }
    Test-Syntax { Get-SpotifyUserTopArtists -Term long_term }
    Test-Syntax { Get-SpotifyUserTopArtists -Term medium_term }
    Test-Syntax { Get-SpotifyUserTopArtists -Term short_term }
    Test-Syntax { Get-SpotifyUserTopArtists long_term }
    Test-Syntax { Get-SpotifyUserTopArtists medium_term }
    Test-Syntax { Get-SpotifyUserTopArtists short_term }
    Test-Validation { Get-SpotifyUserTopArtists -Term "" }
    Test-Validation { Get-SpotifyUserTopArtists -Term $null }
    Test-Validation { Get-SpotifyUserTopArtists -Term "str" }
}

Describe "Get-SpotifyUserTopArtists Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyUserTopArtists }
}
