<#
.SYNOPSIS
Change playlist details.

.DESCRIPTION
Change a playlist's name and public/private state. (The user must, of course, own the playlist.)

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.PARAMETER Name
The new name for the playlist, for example "My New Playlist Title".

.PARAMETER Description
Value for playlist description as displayed in Spotify Clients and in the Web API.

.PARAMETER Public
If true the playlist will be public, if false it will be private.

.PARAMETER Collaborative
If true, the playlist will become collaborative and other users will be able to modify the playlist in their Spotify client. Note: You can only set collaborative to true on non-public playlists.

.EXAMPLE
Update-Playlist -PlaylistId "3cEYpjA9oz9GiPac4AsH4n" -Name "New name" -Public $false

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/change-playlist-details
#>
function Update-SpotifyPlaylist {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter(Mandatory = $false)]
        [bool] $Public,

        [Parameter(Mandatory = $false)]
        [bool] $Collaborative
    )

    $body = @{}

    if ($PSBoundParameters.ContainsKey("Name")) {
        $body.name = $Name
    }

    if ($PSBoundParameters.ContainsKey("Description")) {
        $body.description = if ($Description) { $Description } else { "" }
    }

    if ($PSBoundParameters.ContainsKey("Public")) {
        $body.public = $Public
    }

    if ($PSBoundParameters.ContainsKey("Collaborative")) {
        $body.collaborative = $Collaborative
    }

    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" `
        -Body ([pscustomobject]$body | ConvertTo-Json -Depth 99)
}