. $PSScriptRoot/../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Update-SpotifyAccessToken.ps1
}

Describe "Update-SpotifyAccessToken" {

    BeforeEach {
        $global:SpotifyToken = $null
        
        $script:TestContext = @{
            State = [pscustomobject]@{
                ClientId = "test_id"
                Token    = [pscustomobject]@{ 
                    access_token  = "test_access_token"
                    refresh_token = "test_refresh_token" 
                }
            } 
        }
        Mock Invoke-RestMethod -MockWith { 
            param($Body) $script:TestContext.Body = $Body
            return [pscustomobject]@{
                access_token  = "new_test_access_token"
                refresh_token = "new_test_refresh_token" 
            }
        }
    }

    It "Default" {
        $script:TestContext.State | ConvertTo-Json | Out-File "TestDrive:\state.json"
        $r = Update-SpotifyAccessToken -StatePath "TestDrive:\state.json"

        $global:SpotifyToken | Should -Not -BeNullOrEmpty
        $script:TestContext.Body | Should -BeLike "*test_refresh_token*"
        $r | Should -BeNullOrEmpty

        $s = Get-Content "TestDrive:\state.json" | ConvertFrom-Json -Depth 99
        $s.ClientId | Should -Be "test_id"
        $s.Token | Should -Not -BeNullOrEmpty
        $s.Token.access_token | Should -Be "new_test_access_token"
        $s.Token.refresh_token | Should -Be "new_test_refresh_token"

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
    }

    It "PassThru" {
        $script:TestContext.State | ConvertTo-Json | Out-File "TestDrive:\state.json"
        $r = Update-SpotifyAccessToken -StatePath "TestDrive:\state.json" -PassThru
        $r | Should -Not -BeNullOrEmpty
    }
}
