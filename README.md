# PowerShell for Spotify

PowerShell commands for Spotify Web API. Automatically unfolds paginated results, can add-remove more than 100 tracks in playlists, and does not require a local HTTP service for authentication. See [Wiki](https://github.com/lennyomg/Spotify-PowerShell/wiki) for the complete list of commands.

### Installation

Download `Spotify-Powershell.zip` from the [latest release](https://github.com/lennyomg/Spotify-PowerShell/releases/latest) page and unpack it into one of [$env:PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath?view=powershell-7.3) folders.

### First run

1. Register a [Spotify developer account](https://developer.spotify.com).
2. [Add](https://developer.spotify.com/documentation/general/guides/authorization/app-settings/) a new application.
3. Open application settings and add `https://lennyomg.github.io/Spotify-PowerShell/index.html` to the Redirect URIs list.
4. Run `New-SpotifyAccessToken`.

The command `New-SpotifyAccessToken` requests a new Spotify authorization token. Open the URL that the command prints to the console and confirm authentication. 

```
New-SpotifyAccessToken -CliendId "spotify-app-id"
```
or
```
$url = New-SpotifyAccessToken -ClientId "spotify-app-id" -PassThru
Start-Process $url
```

After successful authentication on the Spotify web-site, you will be redirected to a page with a PowerShell command to complete authentication in PowerShell.  

```
New-SpotifyAccessToken -AutorizationCode "code"
``` 

### Refresh authorization token

Once in a while you must update the existing authorization token. Put `Update-SpotifyAccessToken` at the top of your script or call this command everytime you get the "401 token expired" error. 

### Examples

Collect all tracks from all saved albums, shuffle, and add to the playlist.

```
Update-SpotifyAccessToken
Get-SpotifySavedAlbums
| Get-SpotifyAlbumTracks
| Select-Object -ExpandProperty id -Unique
| Sort-Object { Get-Random }
| Add-SpotifyPlaylistTracks "69kakdvmDUNRcDTMOnI91BF"
```

Merge and shuffle multiple playlists into one, removing explicit tracks and certain artists.

```
function Merge-SpotifyPlaylist {
    param (
        $Target,
        [array] $Source
    )
    
    $Target
    | Get-SpotifyPlaylistTracks
    | Remove-SpotifyPlaylistTracks $Target

    $Source
    | Get-SpotifyPlaylistTracks
    | Where-Object -Property is_local -EQ $false
    | Where-Object -Property explicit -EQ $false
    | Sort-Object { Get-Random }
    | Where-Object { $_.artists[0].name -NotIn @("The 1975", "The Offspring" ) }
    | Select-Object -ExpandProperty id -Unique
    | Add-SpotifyPlaylistTracks -PlaylistId $Target

    Update-SpotifyPlaylist `
        -PlaylistId $Target `
        -Description ("Mix of {0}." -f ($Source | Get-SpotifyPlaylist | Join-String -Property name -Separator ", "))
}

Update-SpotifyAccessToken
Merge-SpotifyPlaylist ``
    -Target "3gf018H3XNln174XMdKiSa" ``
    -Source "7yml7RjHjsJ5XBLxAeRZZy", "37i9dQZF1DX82GYcclJ3Ug", "37i9dQZF1DXcF6B6QPhFDv"
```

Make a custom request using the existing authentication token.

```
Update-SpotifyAccessToken
Invoke-RestMethod `
    -Uri "https://api.spotify.com/v1/me" `
    -Method Get `
    -Authentication Bearer `
    -Token $global:SpotifyToken `
    -ContentType "application/json" 
```

### Tests

Install [Pester](https://pester.dev) and run:
```
. ./Tests.ps1
Invoke-SpotifyTests
```

### Build

`Build.ps1` compiles all commands into one PSM1 file, and updates module metadata. The associated wiki repository contains a script to update wiki pages based on built-in comments and module metadata.

### Docs

* https://github.com/lennyomg/Spotify-PowerShell/wiki
* https://developer.spotify.com/documentation/web-api/reference/#/
