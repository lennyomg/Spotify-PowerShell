. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifySavedAlbums.ps1
}

Describe "Get-SpotifySavedAlbums" {
    It "Default" {
        $p = Get-SpotifySavedAlbums
        $p | ForEach-Object { 
            $_.added_at | Should -Not -BeNullOrEmpty
            $_.type | Should -Be "album" 
            $_.id | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.album"
        }
    }
}

Describe "Get-SpotifySavedAlbums Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifySavedAlbums }
}
