BeforeAll {
    . $PSScriptRoot/Get-SpotifyGenres.ps1
}

Describe "Get-SpotifyGenres" {
    It "Default" {
        $p = Get-SpotifyGenres
        "pop" | Should -BeIn $p
    }
}

Describe "Get-SpotifyGenres Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyGenres }
}