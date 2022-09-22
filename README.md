
# PowerShell for Spotify

PowerShell commands for Spotify Web API. Automatically unfolds paginated results and can add-remove more than 100 tracks in playlists. See [Wiki](https://github.com/lennyomg/Spotify-PowerShell/wiki) for the complete list of commands, documentation, and examples.

### First run

1. Register a [Spotify developer account](https://developer.spotify.com).
2. [Add](https://developer.spotify.com/documentation/general/guides/authorization/app-settings/) a new application.
3. Open application settings and add `https://lennyomg.github.io/Spotify-PowerShell/index.html` to the Redirect URIs list.
4. Download all files from `module` directory.
5. Run `Import-Module "<path>/Spotify.psm1"`.
6. Run `Connect-SpotifyApi` and follow instructions.

### Connect-SpotifyApi

The command `Connect-SpotifyApi` refreshes the Spotify authorization token. Put this command at the top of your script. Call this command if you get "401 token expired" error. 

### Examples

Collect all tracks from all saved albums, shuffle, and add to the playlist.

```
Import-Module "./Spotify.psm1"
Connect-SpotifyApi

Get-SpotifySavedAlbums
| Get-SpotifyAlbumTracks
| Select-Object -ExpandProperty uri -Unique
| Sort-Object { Get-Random }
| Add-SpotifyPlaylistTracks "69kakdvmDUNRcDTMOnI91BF"
```

Merge and shuffle multiple playlists into one, removing explicit tracks and certain artists.

```
Import-Module "./Spotify.psm1"
Connect-SpotifyApi

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
    | Where-Object { $_.artists[0].name -NotIn @("The 1975", "The Offspring", ) }
    | Select-Object -ExpandProperty uri -Unique
    | Add-SpotifyPlaylistTracks -PlaylistId $Target

    Update-SpotifyPlaylist `
        -PlaylistId $Target `
        -Description ("Mix of {0}." -f ($Source | Get-SpotifyPlaylist | Join-String -Property name -Separator ", "))
}

Merge-SpotifyPlaylist ``
    -Target "3gf018H3XNln174XMdKiSa" ``
    -Source "7yml7RjHjsJ5XBLxAeRZZy", "37i9dQZF1DX82GYcclJ3Ug", "37i9dQZF1DXcF6B6QPhFDv"
```

Make a custom request using the existing authorization token.

```
Import-Module "./Spotify.psm1"
Connect-SpotifyApi

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

`Build.ps1` compiles all commands into one PSM1 file, and updates module metadata.

### Docs

* https://github.com/lennyomg/Spotify-PowerShell/wiki
* https://developer.spotify.com/documentation/web-api/reference/#/
