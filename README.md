
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

### Supported API

Playlists  
* Get-SpotifyPlaylist    
* Update-SpotifyPlaylist       
* Get-SpotifyPlaylistTracks   
* Add-SpotifyPlaylistTracks 
* Remove-SpotifyPlaylistTracks
* Get-SpotifySavedPlaylists

Albums 
* Get-SpotifyAlbum        
* Get-SpotifyAlbumTracks    
* Get-SpotifySavedAlbums

Tracks      
* Get-SpotifyTrack           
* Get-SpotifySavedTracks 

Artists
* Get-SpotifyArtist
* Get-SpotifyArtistAlbums
* Get-SpotifyArtistTopTracks
* Get-SpotifySavedArtists 

### Links

https://developer.spotify.com/documentation/web-api/reference/#/
