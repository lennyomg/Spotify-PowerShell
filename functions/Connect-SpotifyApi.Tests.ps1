. $PSScriptRoot/../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Connect-SpotifyApi.ps1
}

Describe "Connect-SpotifyApi" {

    BeforeEach {
        $global:SpotifyToken = $null
        
        $script:TestContext = @{
            State = [pscustomobject]@{
                Credential = New-Object System.Management.Automation.PSCredential("test_id", (ConvertTo-SecureString -String "test_secret" -AsPlainText)) 
                Token      = [pscustomobject]@{ 
                    access_token  = "test_access_token"
                    refresh_token = "test_refresh_token" 
                }
            } 
        }

        Mock Pause
        Mock Write-Host
        Remove-Item "TestDrive:\state.xml" -Force -ErrorAction SilentlyContinue

        Mock Get-Credential -MockWith { 
            param ($UserName) $script:TestContext.UserName = $UserName
            return $script:TestContext.State.Credential 
        }

        Mock Start-Process -MockWith { 
            param ($FilePath) $script:TestContext.FilePath = $FilePath
            Set-Clipboard -Value "test-code"
        }
         
        Mock Invoke-RestMethod -MockWith { 
            param($Body) $script:TestContext.Body = $Body
            return $script:TestContext.State.Token
        }
    }

    It "New" {
        Connect-SpotifyApi -StatePath "TestDrive:\state.xml"

        Test-Path "TestDrive:\state.xml" | Should -BeTrue
        $global:SpotifyToken | Should -Not -BeNullOrEmpty
        $script:TestContext.Body | Should -BeLike "*test-code*"

        Assert-MockCalled Get-Credential -Times 1 -Exactly
        Assert-MockCalled Start-Process -Times 1 -Exactly
        Assert-MockCalled Pause -Times 1 -Exactly
        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
    }

    It "Force" {
        $script:TestContext.State | Export-Clixml "TestDrive:\state.xml"

        Connect-SpotifyApi -StatePath "TestDrive:\state.xml" -Force

        Test-Path "TestDrive:\state.xml" | Should -BeTrue
        $global:SpotifyToken | Should -Not -BeNullOrEmpty
        $script:TestContext.Body | Should -BeLike "*test-code*"

        Assert-MockCalled Get-Credential -Times 1 -Exactly
        Assert-MockCalled Start-Process -Times 1 -Exactly
        Assert-MockCalled Pause -Times 1 -Exactly
        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
    }

    It "Existing" {
        $script:TestContext.State | Export-Clixml "TestDrive:\state.xml"
        
        Connect-SpotifyApi -StatePath "TestDrive:\state.xml"

        $global:SpotifyToken | Should -Not -BeNullOrEmpty
        $script:TestContext.Body | Should -BeLike "*test_refresh_token*"

        Assert-MockCalled Get-Credential -Times 0 -Exactly
        Assert-MockCalled Start-Process -Times 0 -Exactly
        Assert-MockCalled Pause -Times 0 -Exactly
        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
    }

    It "ClientId / Scope" {
        Connect-SpotifyApi -StatePath "TestDrive:\state.xml" -ClientId "test-client-id" -Scope "s1", "s2", "s3"

        $script:TestContext.UserName | Should -Be "test-client-id"
        $script:TestContext.FilePath | Should -BeLike "*s1 s2 s3*"
    }
}
