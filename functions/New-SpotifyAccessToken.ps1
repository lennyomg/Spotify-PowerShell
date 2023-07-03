<#
.SYNOPSIS
Requests a new authorization token for Spotify Web API.

.PARAMETER ClientId
Application client id (copy from Spotify dashboard).

.PARAMETER AuthorizationCode
Autorization code which you get after completing authentication.

.PARAMETER PassThru
Write results to pipeline.

.PARAMETER StatePath
Path to a file to store client information and autorization token.

.PARAMETER Scope
Predefined list of scopes. Full access by default.

.EXAMPLE
New-SpotifyAccessToken -ClientId "id" -Scope "playlist-modify-private", "user-follow-read"

.EXAMPLE
New-SpotifyAccessToken -AutorizationCode "code"

.EXAMPLE
$code_url = New-SpotifyAccessToken -ClientId "id" -PassThru

.FUNCTIONALITY
Base

.LINK
https://developer.spotify.com/dashboard/applications

.LINK
https://developer.spotify.com/documentation/general/guides/authorization/scopes
#>
function New-SpotifyAccessToken {
    [CmdletBinding(PositionalBinding = $false)]
    param(

        [Parameter(Mandatory = $true, ParameterSetName = "Init")]
        [string] $ClientId,
        
        [Parameter(ParameterSetName = "Init")]
        [string[]] $Scope = @(
            "ugc-image-upload",
            "user-modify-playback-state",
            "user-read-playback-state",
            "user-read-currently-playing",
            "user-follow-modify",
            "user-follow-read",
            "user-read-recently-played",
            "user-read-playback-position",
            "user-top-read",
            "playlist-read-collaborative",
            "playlist-modify-public",
            "playlist-read-private",
            "playlist-modify-private",
            "app-remote-control",
            "streaming",
            "user-read-email",
            "user-read-private",
            "user-library-modify",
            "user-library-read"),

        [Parameter(Mandatory = $true, ParameterSetName = "Code")]
        [string] $AuthorizationCode,

        [switch] $PassThru,

        [string] $StatePath = "$HOME/.spotify-pwsh-state"
    )

    if (!$AuthorizationCode) {
        $state = [PSCustomObject]@{
            ClientId     = $ClientId
            CodeVerifier = "{0:N}{1:N}" -f (New-Guid), (New-Guid)
            Token        = $null
        }

        $sha256 = [System.Security.Cryptography.HashAlgorithm]::Create("sha256")
        $challenge = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($state.CodeVerifier))

        $challengeBase64 = [Convert]::ToBase64String($challenge)
        $challengeBase64 = $challengeBase64.Replace("+", "-")
        $challengeBase64 = $challengeBase64.Replace("/", "_")
        $challengeBase64 = $challengeBase64.TrimEnd("=")

        $url = "https://accounts.spotify.com/authorize?client_id=$($ClientId)&response_type=code&scope=$($Scope)&redirect_uri=https://lennyomg.github.io/Spotify-PowerShell/index.html&code_challenge_method=S256&code_challenge=$($challengeBase64)" -replace " ", "%20"
        
        if ($PassThru) {
            Write-Output $url
        }
        else {
            Write-Host "Open the link in your browser and authenticate in Spotify."
            Write-Host ""
            Write-Host $url
            Write-Host ""
        }

        $global:SpotifyToken = $null
    }
    else {
        $state = Get-Content $StatePath | ConvertFrom-Json -Depth 99
        $state.Token = Invoke-RestMethod `
            -Uri "https://accounts.spotify.com/api/token" `
            -Method Post `
            -Body "grant_type=authorization_code&code=$($AuthorizationCode)&redirect_uri=https://lennyomg.github.io/Spotify-PowerShell/index.html&client_id=$($state.ClientId)&code_verifier=$($state.CodeVerifier)" `
            -ContentType "application/x-www-form-urlencoded"

        $global:SpotifyToken = ConvertTo-SecureString $state.Token.access_token -AsPlainText -Force
        $state.CodeVerifier = $null

        if ($PassThru) {
            Write-Output $state.Token
        }
    }

    $state | ConvertTo-Json -Depth 99 | Out-File -Path $StatePath -Force
}