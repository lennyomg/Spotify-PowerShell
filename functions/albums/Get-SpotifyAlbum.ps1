<#
.SYNOPSIS
Get one or several albums.

.DESCRIPTION 
Get Spotify catalog information for multiple albums identified by their Spotify IDs.

.PARAMETER AlbumId
A list of the Spotify IDs for the albums. Can be more than 20.

.EXAMPLE
Get-SpotifyAlbum -AlbumId "4aawyAB9vmqN3uQ7FjRGTy"

.EXAMPLE
Get-SpotifyAlbum 382ObEPsp2rxGrnsizN5TX, 4aawyAB9vmqN3uQ7FjRGTy

.EXAMPLE
"382ObEPsp2rxGrnsizN5TX", "4aawyAB9vmqN3uQ7FjRGTy" | Get-SpotifyAlbum

.FUNCTIONALITY
Album

.LINK
https://developer.spotify.com/documentation/web-api/reference/get-multiple-albums
#>
function Get-SpotifyAlbum {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string[]] $AlbumId
    )
    begin {
        $pipe = @()

        function Invoke {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/albums?ids=$($pipe -join ',')" `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"
            | Select-Object -ExpandProperty albums
            | ForEach-Object { 
                @() + $_ + $_.artists | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
            }
        }
    }
    process {
        $pipe += $AlbumId
        if ($pipe.Length -ge 20) {
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