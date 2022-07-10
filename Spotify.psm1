
#region Connect-SpotifyApi

<#
.SYNOPSIS
Creates a new spotify token or refreshes the existing one and configures global variables.

.DESCRIPTION
For the initial authentication you will need to provide client id, client secret and autherization scopes. 

.PARAMETER StatePath
Path to a file to store client information and authentication token.

.PARAMETER Force
Forces a new authentication.

.PARAMETER ClientId
Predefined client Id (optional).

.PARAMETER Scope
Predefined list of scopes. Full access by default.

.LINK
https://developer.spotify.com/dashboard/applications

.LINK
https://developer.spotify.com/documentation/general/guides/authorization/scopes

#>
function Connect-SpotifyApi {
    param(
        [Parameter(Position = 0)]
        [string] $StatePath = "$HOME/spotify-pwsh-state.xml",
        [switch] $Force,
        [string] $ClientId = $null,
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
            "user-library-read")
    )

    if (!(Test-Path -Path $StatePath) -or $Force) {

        $state = [PSCustomObject]@{
            Credential = Get-Credential -UserName $ClientId -Message "Enter client id as username and client secret as password."
            Scope      = $Scope | Join-String -Separator " "
            Token      = $null
            Date       = Get-Date 
        }

        Start-Process "https://accounts.spotify.com/authorize?client_id=$($state.Credential.UserName)&response_type=code&scope=$($state.Scope)&redirect_uri=http://lennyomg.github.io/WebRequestDump" | Out-Null
        Write-Host "Proceed in a browser and copy the autorization code ('code' GET paramater) to the clipboard."
        Pause
    
        $state.Token = Invoke-RestMethod `
            -Uri "https://accounts.spotify.com/api/token" `
            -Method Post `
            -Body "grant_type=authorization_code&code=$(Get-Clipboard)&redirect_uri=http://lennyomg.github.io/WebRequestDump" `
            -Authentication Basic `
            -Credential $state.Credential `
            -ContentType "application/x-www-form-urlencoded"
    
        $global:SpotifyToken = ConvertTo-SecureString $state.Token.access_token -AsPlainText -Force
        $state | Export-Clixml -Path $StatePath
        $file = Get-Item -Path $StatePath -Force
        $file.Attributes = "Hidden"
    }
    else {
        
        $state = Import-Clixml -Path $StatePath
        $token = Invoke-RestMethod `
            -Uri "https://accounts.spotify.com/api/token" `
            -Method Post `
            -Body "grant_type=refresh_token&refresh_token=$($state.Token.refresh_token)" `
            -ContentType "application/x-www-form-urlencoded" `
            -Authentication Basic `
            -Credential $state.Credential

        $global:SpotifyToken = ConvertTo-SecureString $token.access_token -AsPlainText -Force
    }
}

#endregion

#region Get-SpotifyPlaylistTracks

<#
.SYNOPSIS
Get playlist items.

.DESCRIPTION
Get full details of the items of a playlist owned by a Spotify user.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks
#>
function Get-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [Alias("id")]
        [string] $PlaylistId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks?limit=100" }
        & { while ($r.next) {
                $r = Invoke-RestMethod `
                    -Uri $r.next `
                    -Method Get `
                    -Authentication Bearer `
                    -Token $global:SpotifyToken `
                    -ContentType "application/json"; $r 
            } 
        } | Select-Object -ExpandProperty items
    }
}

#endregion

#region Get-SpotifyPlaylist

<#
.SYNOPSIS
Get playlist.

.DESCRIPTION 
Get a playlist owned by a Spotify user.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist
#>
function Get-SpotifyPlaylist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)] 
        [string] $PlaylistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}

#endregion

#region Remove-SpotifyPlaylistTracks

<#
.SYNOPSIS
Remove playlist items.

.DESCRIPTION
Remove one or more items from a user's playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.PARAMETER TrackUri
An array of Spotify URIs of the tracks or episodes to remove. For example: @("spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M").

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/remove-tracks-playlist
#>
function Remove-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $PlaylistId,

        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $TrackUri
    )
    end {
        $list = @($input)
        if ($list.Count) { $TrackUri = $list } 
        
        $c = [pscustomobject]@{ i = 0 }
        $TrackUri   
        | Group-Object -Property { [System.Math]::Floor($c.i++ / 100) }
        | ForEach-Object { [pscustomobject]@{ tracks = $_.Group | ForEach-Object { [pscustomobject]@{ uri = $_ } } } }
        | ForEach-Object {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks" `
                -Method Delete `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -Body ($_ | ConvertTo-Json -Depth 99)
        } 
        | Out-Null
    }
}

#endregion

#region Add-SpotifyPlaylistTracks

<#
.SYNOPSIS
Add items to playlist.

.DESCRIPTION
Add one or more items to a user's playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.PARAMETER TrackUri
An array of Spotify URIs of the tracks or episodes to remove. For example: @("spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M").

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/add-tracks-to-playlist
#>
function Add-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $PlaylistId,

        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $TrackUri
    )
    end {
        $list = @($input)
        if ($list.Count) { $TrackUri = $list } 
        
        $c = [pscustomobject]@{ i = 0 }
        $TrackUri   
        | Group-Object -Property { [System.Math]::Floor($c.i++ / 100) }
        | ForEach-Object { [pscustomobject]@{ uris = $_.Group } }
        | ForEach-Object {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks" `
                -Method Post `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -Body ($_ | ConvertTo-Json -Depth 99)
        } 
        | Out-Null
    }
}

#endregion

#region Update-SpotifyPlaylist

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

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/change-playlist-details
#>
function Update-SpotifyPlaylist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [string] $PlaylistId,
        [string] $Name = $null,
        [string] $Description = $null,
        $Public = $null,
        $Collaborative = $null
    )

    $body = @{}

    if ($Name) {
        $body.name = $Name
    }

    if ($Description) {
        $body.description = $Description
    }

    if ($null -ne $Public) {
        $body.public = $Public
    }

    if ($null -ne $Collaborative) {
        $body.collaborative = $Collaborative
    }

    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" `
        -Body ([pscustomobject]$body | ConvertTo-Json -Depth 99)
}

#endregion

#region Get-SpotifySavedPlaylists

<#
.SYNOPSIS
Get current user's playlists.

.DESCRIPTION
Get a list of the playlists owned or followed by the current Spotify user.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists
#>
function Get-SpotifySavedPlaylists {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/playlists?limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"; $r 
        } 
    } | Select-Object -ExpandProperty items
}

#endregion

#region Get-SpotifySavedAlbums

<#
.SYNOPSIS
Get saved albums.

.DESCRIPTION
Get a list of the albums saved in the current Spotify user's 'Your Music' library.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-albums
#>
function Get-SpotifySavedAlbums {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/albums?limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"; $r 
        } 
    } | Select-Object -ExpandProperty items
}

#endregion

#region Get-SpotifySavedTracks

<#
.SYNOPSIS
Get user's saved tracks.

.DESCRIPTION
Get a list of the songs saved in the current Spotify user's 'Your Music' library.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-tracks
#>
function Get-SpotifySavedTracks {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/tracks?limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"; $r 
        } 
    } | Select-Object -ExpandProperty items
}

#endregion

#region Get-SpotifySavedArtists

<#
.SYNOPSIS
Get followed artists.

.DESCRIPTION
Get the current user's followed artists.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed
#>
function Get-SpotifySavedArtists {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/following?type=artist&limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" | Select-Object -ExpandProperty artists; $r 
        } 
    } | Select-Object -ExpandProperty items
}

#endregion

#region Get-SpotifyAlbumTracks

<#
.SYNOPSIS
Get album tracks.

.DESCRIPTION
Get Spotify catalog information about an album’s tracks. 

.PARAMETER AlbumId
The Spotify ID of the album. Example value: "4aawyAB9vmqN3uQ7FjRGTy".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks
#>
function Get-SpotifyAlbumTracks {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [string] $AlbumId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/albums/$($AlbumId)/tracks?limit=50" }
        & { while ($r.next) {
                $r = Invoke-RestMethod `
                    -Uri $r.next `
                    -Method Get `
                    -Authentication Bearer `
                    -Token $global:SpotifyToken `
                    -ContentType "application/json"; $r 
            } 
        } | Select-Object -ExpandProperty items
    }
}

#endregion

#region Get-SpotifyAlbum

<#
.SYNOPSIS
Get album.

.DESCRIPTION 
Get Spotify catalog information for a single album.

.PARAMETER AlbumId
The Spotify ID of the album. Example value: "4aawyAB9vmqN3uQ7FjRGTy".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album
#>
function Get-SpotifyAlbum {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [string] $AlbumId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/albums/$($AlbumId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}

#endregion

#region Get-SpotifyTrack

<#
.SYNOPSIS
Get track.

.DESCRIPTION 
Get Spotify catalog information for a single track identified by its unique Spotify ID.

.PARAMETER TrackId
The Spotify ID for the track. Example value: "11dFghVXANMlKmJXsNCbNl".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
#>
function Get-SpotifyTrack {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [string] $TrackId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/tracks/$($TrackId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}

#endregion

#region Get-SpotifyArtistAlbums

<#
.SYNOPSIS
Get artist's albums.

.DESCRIPTION
Get Spotify catalog information about an artist's albums.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums
#>
function Get-SpotifyArtistAlbums {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [string] $ArtistId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/artists/$($ArtistId)/albums?limit=50" }
        & { while ($r.next) {
                $r = Invoke-RestMethod `
                    -Uri $r.next `
                    -Method Get `
                    -Authentication Bearer `
                    -Token $global:SpotifyToken `
                    -ContentType "application/json"; $r 
            } 
        } | Select-Object -ExpandProperty items
    }
}

#endregion

#region Get-SpotifyArtist

<#
.SYNOPSIS
Get artist.

.DESCRIPTION 
Get Spotify catalog information for a single artist identified by their unique Spotify ID.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist
#>
function Get-SpotifyArtist {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [string] $ArtistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/artists/$($ArtistId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}

#endregion

#region Get-SpotifyArtistTopTracks

<#
.SYNOPSIS
Get artist's top tracks.

.DESCRIPTION 
Get Spotify catalog information about an artist's top tracks by country.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.PARAMETER Market
An ISO 3166-1 alpha-2 country code. If a country code is specified, only content that is available in that market will be returned. Example value: "ES".

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-top-tracks
#>
function Get-SpotifyArtistTopTracks {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [string] $ArtistId,
        [string] $Market = "US"
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/artists/$($ArtistId)/top-tracks?market=$($Market)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json" | Select-Object -ExpandProperty tracks
    }
}

#endregion

#region New-SpotifyPlaylist

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
Defaults to true. If true the playlist will be public, if false it will be private. To be able to create private playlists, the user must have granted the playlist-modify-private.

.PARAMETER Collaborative
Defaults to false. If true the playlist will be collaborative. Note: to create a collaborative playlist you must also set public to false. To create collaborative playlists you must have granted playlist-modify-private and playlist-modify-public.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/create-playlist
#>
function New-SpotifyPlaylist {
    param (
        [Parameter(Mandatory)]
        [string] $UserId,
        [string] $Name,
        [string] $Description = $null,
        [bool] $Public = $false,
        [bool] $Collaborative = $false 
    )

    $body = @{
        name          = $Name
        public        = $Public
        collaborative = $Collaborative
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
}

#endregion

#region Get-SpotifyCurrentUser

<#
.SYNOPSIS
Get current user's profile.

.DESCRIPTION
Get detailed profile information about the current user (including the current user's username).

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile
#>
function Get-SpotifyCurrentUser {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" 
}

#endregion