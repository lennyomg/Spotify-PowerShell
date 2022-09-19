. $PSScriptRoot/../../Tests.ps1

BeforeAll {
    . $PSScriptRoot/Get-SpotifyTrackAnalysis.ps1
}

Describe "Get-SpotifyTrackAnalysis" {
    It "Default <value>" -ForEach @(
        @{ value = "11dFghVXANMlKmJXsNCbNl" }
        @{ value = "2wynpXzuXf6Cvf2MqHYA9Z" }
    ) {
        $p = Get-SpotifyTrackAnalysis -TrackId $value
        $p.meta | Should -Not -BeNullOrEmpty
        $p.track | Should -Not -BeNullOrEmpty
    }
}

Describe "Get-SpotifyTrackAnalysis" {
    Test-Syntax { Get-SpotifyTrackAnalysis -TrackId "id" }
    Test-Syntax { Get-SpotifyTrackAnalysis "id" }
    Test-Syntax { "id" | Get-SpotifyTrackAnalysis }
    Test-Syntax { "id1", "id2" | Get-SpotifyTrackAnalysis } 2
    Test-Validation { Get-SpotifyTrackAnalysis -TrackId "" }
    Test-Validation { Get-SpotifyTrackAnalysis -TrackId $null }
    Test-PipeAlias { param($p) $p | Get-SpotifyTrackAnalysis }
}

Describe "Get-SpotifyTrackAnalysis Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyTrackAnalysis -TrackId "2wynpXzuXf6Cvf2MqHYA9Z" }
}
