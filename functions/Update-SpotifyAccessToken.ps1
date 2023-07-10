
<#
.SYNOPSIS
Refreshes authorization token for Spotify Web API.

.DESCRIPTION
Refreshes the existing authorization token and configures global variables. 
Call this command if you get the "401 token expired" error. 
Put this command at the top of your script.

.PARAMETER StatePath
Path to a file to store client information and authorization token. 

.EXAMPLE
Update-SpotifyAccessToken

.FUNCTIONALITY
Base

.LINK
https://developer.spotify.com/dashboard/applications

#>
function Update-SpotifyAccessToken {
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [switch] $PassThru,    
        [string] $StatePath = $global:SpotifyTokenPath ?? "$HOME/.spotify-pwsh-state"
    )
    try {
        $state = Get-Content $StatePath | ConvertFrom-Json -Depth 99
        $token = Invoke-RestMethod `
            -Uri "https://accounts.spotify.com/api/token" `
            -Method Post `
            -Body "grant_type=refresh_token&refresh_token=$($state.Token.refresh_token)&client_id=$($state.ClientId)" `
            -ContentType "application/x-www-form-urlencoded" `
            -ErrorAction Stop

        $state.Token = $token
        $state | ConvertTo-Json -Depth 99 | Out-File $StatePath -Force
        $global:SpotifyToken = ConvertTo-SecureString $token.access_token -AsPlainText -Force

        if ($PassThru) {
            Write-Output $token
        }
    }
    catch {
        throw $_
    }
}
