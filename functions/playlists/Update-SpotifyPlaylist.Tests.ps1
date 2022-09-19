. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Update-SpotifyPlaylist.ps1
    . $PSScriptRoot/Get-SpotifySavedPlaylists.ps1
    . $PSScriptRoot/Get-SpotifyPlaylist.ps1
}

Describe "Update-SpotifyPlaylist" {
    It "Default" {
        $p = Get-SpotifySavedPlaylists | Where-Object { $_.name -eq "ps-test" }
        $desc = (New-Guid).ToString("n")
        
        Update-SpotifyPlaylist -PlaylistId $p.id -Name "new name" -Description $desc -Public $true
        $p = Get-SpotifyPlaylist -PlaylistId $p.id
        $p.name | Should -Be "new name"
        $p.description | Should -Be $desc
        $p.public | Should -Be $true

        $p | Update-SpotifyPlaylist -Name "ps-test" -Public $false
        $p = Get-SpotifyPlaylist -PlaylistId $p.id
        $p.name | Should -Be "ps-test"
        $p.description | Should -Be $desc
        $p.public | Should -Be $false
    }
}

Describe "Update-SpotifyPlaylist Syntax" {
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Name "name" }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Description "desc" }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Public $true }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Public $false }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Collaborative $true }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Collaborative $false }
    Test-Syntax { Update-SpotifyPlaylist -PlaylistId "id" -Name "name" -Description "desc" -Public $true -Collaborative $false }
    Test-Validation { Update-SpotifyPlaylist "user" "name" }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId "" }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId $null }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId "id" -Name "" }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId "id" -Name $null }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId "id" -Description "" }
    Test-Validation { Update-SpotifyPlaylist -PlaylistId "id" -Description $null }
}
