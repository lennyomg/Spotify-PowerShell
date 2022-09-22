<#
.SYNOPSIS
Create playlist.

.DESCRIPTION
Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)

.PARAMETER UserId
The user's Spotify user ID. Example value: "smedjan".

.PARAMETER Name
The name for the new playlist, for example "Your Coolest Playlist". This name does not need to be unique; a user may have several playlists with the same name.

.PARAMETER Description
Value for playlist description as displayed in Spotify Clients and in the Web API.

.PARAMETER Public
Defaults to false. If true the playlist will be public, if false it will be private. To be able to create private playlists, the user must have granted the playlist-modify-private.

.PARAMETER Collaborative
Defaults to false. If true the playlist will be collaborative. Note: to create a collaborative playlist you must also set public to false. To create collaborative playlists you must have granted playlist-modify-private and playlist-modify-public.

.EXAMPLE
$user = Get-SpotifyUser
New-SpotifyPlaylist -UserId $user.id -Name "New playlist" -Description "Awesome songs" -Public

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/create-playlist
#>
function New-SpotifyPlaylist {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $UserId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        
        [Parameter()]
        [string] $Description = $null,

        [Parameter()]
        [switch] $Public,

        [Parameter()]
        [switch] $Collaborative 
    )

    $body = @{
        name          = $Name
        public        = [bool]$Public
        collaborative = [bool]$Collaborative
    }
    
    if ($Description) {
        $body.description = $Description
    }

    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/users/$($UserId)/playlists" `
        -Method Post `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" `
        -Body ($body | ConvertTo-Json -Depth 99)
    | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)"); $_ }
}