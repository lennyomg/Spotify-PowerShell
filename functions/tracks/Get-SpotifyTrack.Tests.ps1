. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyTrack.ps1
}

Describe "Get-SpotifyTrack" {
    It "Default <value>" -ForEach @(
        @{ value = "11dFghVXANMlKmJXsNCbNl" }
        @{ value = "2wynpXzuXf6Cvf2MqHYA9Z" }
        @{ value = @("11dFghVXANMlKmJXsNCbNl", "2wynpXzuXf6Cvf2MqHYA9Z") }
    ) {
        $p = Get-SpotifyTrack -TrackId $value
        $p.id | Should -Be $value
        $p | ForEach-Object {
            $_.type | Should -Be "track"
            $_.uri | Should -Not -BeNullOrEmpty
            $_.PSObject.TypeNames | Should -Contain "spfy.track"
        }
    }
}

Describe "Get-SpotifyTrack Syntax" {
    Test-Syntax { Get-SpotifyTrack -TrackId "id" }
    Test-Syntax { Get-SpotifyTrack "id" }
    Test-Syntax { "id" | Get-SpotifyTrack }
    Test-Syntax { "id1", "id2" | Get-SpotifyTrack }
    Test-Syntax { @(1..050) | ForEach-Object { "id{$($_)}" } | Get-SpotifyTrack }
    Test-Syntax { @(1..051) | ForEach-Object { "id{$($_)}" } | Get-SpotifyTrack } 2
    Test-Syntax { @(1..100) | ForEach-Object { "id{$($_)}" } | Get-SpotifyTrack } 2
    Test-Syntax { @(1..120) | ForEach-Object { "id{$($_)}" } | Get-SpotifyTrack } 3
    Test-Validation { Get-SpotifyTrack -TrackId "" }
    Test-Validation { Get-SpotifyTrack -TrackId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyTrack }
}

Describe "Get-SpotifyTrack Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyTrack -TrackId "2wynpXzuXf6Cvf2MqHYA9Z" }
}
