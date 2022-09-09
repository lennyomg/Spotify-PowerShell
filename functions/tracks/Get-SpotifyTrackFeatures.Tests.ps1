BeforeAll {
    . $PSScriptRoot/Get-SpotifyTrackFeatures.ps1
}

Describe "Get-SpotifyTrackFeatures" {
    It "Default <value>" -ForEach @(
        @{ value = "11dFghVXANMlKmJXsNCbNl" }
        @{ value = "2wynpXzuXf6Cvf2MqHYA9Z" }
    ) {
        $p = Get-SpotifyTrackFeatures -TrackId $value
        $p.type | Should -Be "audio_features"
        $p.id | Should -Be $value
        $p.uri | Should -Not -BeNullOrEmpty
    }
}

Describe "Get-SpotifyTrackFeatures" {
    Test-Syntax { Get-SpotifyTrackFeatures -TrackId "id" }
    Test-Syntax { Get-SpotifyTrackFeatures "id" }
    Test-Syntax { "id" | Get-SpotifyTrackFeatures }
    Test-Syntax { "id1", "id2" | Get-SpotifyTrackFeatures } 2
    Test-Validation { Get-SpotifyTrackFeatures -TrackId "" }
    Test-Validation { Get-SpotifyTrackFeatures -TrackId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyTrackFeatures }
}

Describe "Get-SpotifyTrackFeatures Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyTrackFeatures -TrackId "2wynpXzuXf6Cvf2MqHYA9Z" }
}