BeforeAll {
    . $PSScriptRoot/Find-SpotifyItem.ps1   
}

Describe "Find-SpotifyItem" {
    It "Default 1" {
        $p = Find-SpotifyItem "mark hoppus"
        $p.Count | Should -BeGreaterThan 0

        ($p | Where-Object { $_.type -eq "track" }).Count | Should -BeGreaterThan 0
        ($p | Where-Object { $_.type -eq "album" }).Count | Should -BeGreaterThan 0
        ($p | Where-Object { $_.type -eq "artist" }).Count | Should -BeGreaterThan 0
        ($p | Where-Object { $_.type -eq "playlist" }).Count | Should -BeGreaterThan 0
        ($p | Where-Object { $_.type -eq "shows" }).Count | Should -Be 0
        ($p | Where-Object { $_.type -eq "episodes" }).Count | Should -Be 0
    }

    It "Default 2" {
        $p = Find-SpotifyItem "metallica" -Type artist
        $p.Count | Should -BeGreaterThan 0

        ($p | Where-Object { $_.type -eq "artist" }).Count | Should -BeGreaterThan 0
        ($p | Where-Object { $_.type -eq "track" }).Count | Should -Be 0
        ($p | Where-Object { $_.type -eq "album" }).Count | Should -Be 0
        ($p | Where-Object { $_.type -eq "playlist" }).Count | Should -Be 0
    }
}

Describe "Find-SpotifyItem Syntax" {
    Test-Syntax { Find-SpotifyItem "q" }
    Test-Syntax { Find-SpotifyItem -Query "q" }
    Test-Syntax { Find-SpotifyItem -Query "q" -Type album }
    Test-Syntax { Find-SpotifyItem -Query "q" -Type album, artist, album, playlist, show, episode }
    Test-Validation { Find-SpotifyItem -Query "" }
    Test-Validation { Find-SpotifyItem -Query $null }
    Test-Validation { Find-SpotifyItem -Query "q" -Type "" }
    Test-Validation { Find-SpotifyItem -Query "q" -Type $null }
    Test-Validation { Find-SpotifyItem -Query "q" -Type @() }
    Test-Validation { Find-SpotifyItem -Query "q" -Type @("") }
    Test-Validation { Find-SpotifyItem -Query "q" -Type "type" }
    Test-Validation { Find-SpotifyItem -Query "q" -Type album, type }
}

Describe "Find-SpotifyItem Output" -Tag "Output" {
    Update-CommandOutput { Find-SpotifyItem -Query "mark hoppus" }
}