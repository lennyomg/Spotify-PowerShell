@{
    RootModule        = './Spotify.psm1' 
    ModuleVersion     = '0.2.0' 
    GUID              = '153c26ff-0080-4655-bcd3-d8ffee31f6a8' 
    Author            = 'lennyomg' 
    CompanyName       = 'lennyomg' 
    Copyright         = '(c) lennyomg. All rights reserved.' 
    Description       = 'PowerShell commands for Spotify Web API.' 
    PowerShellVersion = '5.0'
    FunctionsToExport = @(
        'Connect-SpotifyApi',
        'Get-SpotifyPlaylistTracks',
        'Get-SpotifyPlaylist',
        'Remove-SpotifyPlaylistTracks',
        'Add-SpotifyPlaylistTracks',
        'Update-SpotifyPlaylist',
        'Get-SpotifySavedPlaylists',
        'Get-SpotifySavedAlbums',
        'Get-SpotifySavedTracks',
        'Get-SpotifySavedArtists',
        'Get-SpotifyAlbumTracks',
        'Get-SpotifyAlbum',
        'Get-SpotifyTrack',
        'Get-SpotifyArtistAlbums',
        'Get-SpotifyArtist',
        'Get-SpotifyArtistTopTracks',
        'New-SpotifyPlaylist',
        'Get-SpotifyCurrentUser') 
    CmdletsToExport   = @()
    VariablesToExport = @() 
    AliasesToExport   = @() 
    PrivateData       = @{
        PSData = @{
            Tags       = @("spotify") 
            LicenseUri = 'https://github.com/lennyomg/Spotify-PowerShell' 
            ProjectUri = 'https://github.com/lennyomg/Spotify-PowerShell' 
            Prerelease = 'preview' 
        } 
    }
}