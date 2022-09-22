. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/New-SpotifyPlaylist.ps1
}

Describe "New-SpotifyPlaylist" {

    It "Default" {
        $p = New-SpotifyPlaylist -UserId $env:SpotifyUserId -Name "test101" -Description "text"
        $p.type | Should -Be "playlist"
        $p.id | Should -Not -BeNullOrEmpty
        $p.public | Should -Be $false
        $p.collaborative | Should -Be $false
        $p.name | Should -Be "test101"
        $p.description | Should -Be "text"
        $p.PSObject.TypeNames | Should -Contain "spfy.playlist"
    }

    It "Public" -Skip {
        $p = New-SpotifyPlaylist -UserId $env:SpotifyUserId -Name "test102" -Public
        $p.type | Should -Be "playlist"
        $p.id | Should -Not -BeNullOrEmpty
        $p.public | Should -Be $true
        $p.collaborative | Should -Be $false
        $p.name | Should -Be "test102"
        $p.description | Should -BeNullOrEmpty
    }

    It "Collaborative" -Skip {
        $p = New-SpotifyPlaylist -UserId $env:SpotifyUserId -Name "test103" -Collaborative
        $p.type | Should -Be "playlist"
        $p.id | Should -Not -BeNullOrEmpty
        $p.public | Should -Be $false
        $p.collaborative | Should -Be $true
        $p.name | Should -Be "test103"
        $p.description | Should -BeNullOrEmpty
    }
}

Describe "New-SpotifyPlaylist Syntax" {
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Description "desc" }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Description "" }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Description $null }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Public }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Collaborative }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Description "desc" -Public }
    Test-Syntax { New-SpotifyPlaylist -UserId "user" -Name "name" -Description "desc" -Collaborative }
    Test-Validation { New-SpotifyPlaylist "user" "name" }
    Test-Validation { New-SpotifyPlaylist -UserId "" }
    Test-Validation { New-SpotifyPlaylist -UserId $null }
    Test-Validation { New-SpotifyPlaylist -UserId "name" -Name "" }
    Test-Validation { New-SpotifyPlaylist -UserId "name" -Name $null }
}

Describe "New-SpotifyPlaylist Output" -Tag "Output" -Skip {
    Update-CommandOutput { New-SpotifyPlaylist -UserId $env:SpotifyUserId -Name "test" }
}
