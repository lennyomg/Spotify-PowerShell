<#
.SYNOPSIS
Get one or several artists.

.DESCRIPTION 
Get Spotify catalog information for several artists based on their Spotify IDs.

.PARAMETER ArtistId
A list of the Spotify IDs for the artists. Can be more than 50.

.EXAMPLE
Get-SpotifyArtist -ArtistId "0TnOYISbd1XYRBk9myaseg"

.EXAMPLE
Get-SpotifyArtist 2CIMQHirSU0MQqyYHq0eOx, 57dN52uHvrHOxijzpIgu3E, 1vCWHaC5f2uS3yhpwWbIA6

.EXAMPLE
"2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6" | Get-SpotifyArtist

.FUNCTIONALITY
Artist

.LINK
https://developer.spotify.com/documentation/web-api/reference/get-multiple-artists
#>
function Get-SpotifyArtist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [ValidateNotNullOrEmpty()]
        [string[]] $ArtistId
    )
    begin {
        $pipe = @()

        function Invoke {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/artists?ids=$($pipe -join ',')" `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"
            | Select-Object -ExpandProperty artists
            | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)"); $_ }
        }
    }
    process {
        $pipe += $ArtistId
        if ($pipe.Length -ge 50) {
            Invoke
            $pipe = @()
        }
    }
    end {
        if ($pipe) {
            Invoke
        }
    }
}