. $PSScriptRoot/../Tests.ps1

BeforeAll {
    . $PSScriptRoot/New-SpotifyAccessToken.ps1
}

Describe "New-SpotifyAccessToken" {

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

        Mock Write-Host
        Mock Invoke-RestMethod -MockWith { 
            param($Body) $script:TestContext.Body = $Body
            return $script:TestContext.State.Token
        }

        Remove-Item "TestDrive:\state.json" -Force -ErrorAction SilentlyContinue
    }

    It "ClientId" {
        $global:SpotifyToken = "dummy"
        $r = New-SpotifyAccessToken -ClientId "test_id" -StatePath "TestDrive:\state.json"

        Test-Path "TestDrive:\state.json" | Should -BeTrue
        $global:SpotifyToken | Should -BeNullOrEmpty
        $r | Should -BeNullOrEmpty

        $s = Get-Content "TestDrive:\state.json" | ConvertFrom-Json -Depth 99
        $s.ClientId | Should -Be "test_id"
        $s.CodeVerifier | Should -Not -BeNullOrEmpty
        $s.Token | Should -BeNullOrEmpty

        Assert-MockCalled Invoke-RestMethod -Times 0 -Exactly
    }

    It "ClientId Scope" {
        $global:SpotifyToken = "dummy"
        New-SpotifyAccessToken -ClientId "test_id" -Scope "s1", "s2" -StatePath "TestDrive:\state.json"
    }

    It "ClientId PassThru" {
        $global:SpotifyToken = "dummy"
        $r = New-SpotifyAccessToken -ClientId "test_id" -PassThru -StatePath "TestDrive:\state.json"
        $r | Should -Not -BeNullOrEmpty
    }

    It "Code" {
        $global:SpotifyToken = $null

        New-SpotifyAccessToken -ClientId "test_id" -StatePath "TestDrive:\state.json"
        $r = New-SpotifyAccessToken -AuthorizationCode "code" -StatePath "TestDrive:\state.json"

        Test-Path "TestDrive:\state.json" | Should -BeTrue
        $global:SpotifyToken | Should -Not -BeNullOrEmpty
        $r | Should -BeNullOrEmpty

        $s = Get-Content "TestDrive:\state.json" | ConvertFrom-Json -Depth 99
        $s.ClientId | Should -Be "test_id"
        $s.CodeVerifier | Should -BeNullOrEmpty
        $s.Token | Should -Not -BeNullOrEmpty

        Assert-MockCalled Invoke-RestMethod -Times 1 -Exactly
    }
    
    It "Code PassThru" -Skip {
        $global:SpotifyToken = $null
        New-SpotifyAccessToken -ClientId "test_id" -StatePath "TestDrive:\state.json"
        $r = New-SpotifyAccessToken -AuthorizationCode "code" -StatePath "TestDrive:\state.json"
        $r | Should -Not -BeNullOrEmpty
    }
}
