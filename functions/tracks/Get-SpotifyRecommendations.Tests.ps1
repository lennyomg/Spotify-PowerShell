BeforeAll { 
    . $PSScriptRoot/Get-SpotifyRecommendations.ps1
}

Describe "Get-SpotifyRecommendations" {
    It "Default" {
        $p = Get-SpotifyRecommendations -SeedArtists "2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E" -MinEnergy 0.8 -MaxEnergy 1 -TargetDanceability 1
        $p.Count | Should -BeGreaterThan 0
        $p | ForEach-Object {
            $_.type | Should -Be "track"
            $_.id | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Get-SpotifyRecommendations Syntax" {
    It "All" {
        Mock Invoke-RestMethod
        Get-SpotifyRecommendations `
            -SeedArtists "a1", "a2" `
            -SeedGenres "g1", "g2" `
            -SeedTracks "t1", "t2" `
            -MaxAcousticness 0 `
            -MaxDanceability 0 `
            -MaxDurationMs 0 `
            -MaxEnergy 0 `
            -MaxInstrumentalness 0 `
            -MaxKey 0 `
            -MaxLiveness 0 `
            -MaxLoudness 0 `
            -MaxMode 0 `
            -MaxPopularity 0 `
            -MaxSpeechiness 0 `
            -MaxTempo 0 `
            -MaxTimeSignature 0 `
            -MaxValence 0 `
            -MinAcousticness 0 `
            -MinDanceability 0 `
            -MinDurationMs 0 `
            -MinEnergy 0 `
            -MinInstrumentalness 0 `
            -MinKey 0 `
            -MinLiveness 0 `
            -MinLoudness 0 `
            -MinMode 0 `
            -MinPopularity 0 `
            -MinSpeechiness 0 `
            -MinTempo 0 `
            -MinTimeSignature 0 `
            -MinValence 0 `
            -TargetAcousticness 0 `
            -TargetDanceability 0 `
            -TargetDurationMs 0 `
            -TargetEnergy 0 `
            -TargetInstrumentalness 0 `
            -TargetKey 0 `
            -TargetLiveness 0 `
            -TargetLoudness 0 `
            -TargetMode 0 `
            -TargetPopularity 0 `
            -TargetSpeechiness 0 `
            -TargetTempo 0 `
            -TargetTimeSignature 0 `
            -TargetValence 0 
    }

    Test-Validation { Get-SpotifyRecommendations -SeedArtists "1", "2", "3", "4", "5", "6" }
    Test-Validation { Get-SpotifyRecommendations -SeedGenres "1", "2", "3", "4", "5", "6" }
    Test-Validation { Get-SpotifyRecommendations -SeedTracks "1", "2", "3", "4", "5", "6" }

    It "Alias" {
        $c = Get-Command Get-SpotifyRecommendations
        $c.Parameters.Values | ForEach-Object {
            $_.Aliases.Count | Should -BeGreaterThan 0 -Because $_.Name 
        }
    }
}

Describe "Get-SpotifyRecommendations Output" -Tag "Output" {
    Update-CommandOutput { Get-SpotifyRecommendations -SeedArtists "2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E" -MinEnergy 0.8 -MaxEnergy 1 -TargetDanceability 1 }
}