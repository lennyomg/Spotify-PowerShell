
# PowerShell for Spotify

### Example

```
Import-Module "./Spotify.psm1"
Connect-SpotifyApi

Get-SpotifySavedAlbums 
| Select-Object -ExpandProperty album 
| Get-SpotifyAlbumTracks 
| Format-Wide name
```

### Documentation

https://github.com/lennyomg/Spotify-PowerShell/wiki

### Links

https://developer.spotify.com/documentation/web-api/reference/#/
