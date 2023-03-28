# hot_hand_model

SOFTWARE NEEDED: R AND JAGS. All code in R language.

In this folder anyone can reproduce the statistical analysis carried out in the "A Bayesian hidden Markov model for assessing the hot hand phenomenon in basketball shooting performance" paper. In the following, the structure of this project is explained:

1. Folder "data". Here it is included three elements: MIA_all.RData, shots_MIA_all.RData, matrix_data_ft_complete_season_all.RDATA.
          MIA_all.RData: data frame of all the shots of the season.
          shots_MIA_all.RData: vector of the results of the shots, 1 (made shot), 0 (missed shot).
          matrix_data_ft_complete_season_all.RDATA: Response variable (matrix_tiros) and covariates (distance_matrix, ft) in the matricial format for the modelling.
          
2. Folder "documents". Plot of the basketball court. It is used in the shot chart.

3. Folder "figures". All the figures presented in the paper in PDF format.

4. Folder "functions". Function for the n-step transition probability matrix.

5. Folder "model". The Bayesian longitudinal hidden Markov model used in the study, in JAGS format.

6. Folder "results". A sample from JAGS of the posterior distribution of the parameters (rsamps_hot_hand_ft_re_all2.RData).

7. Folder "results_scripts". Six scripts on posterior results showed in the paper: occupancy_times_ft_histograms.R, sojourn_times.R, stationary_distribution.R, success_vs_distance.R, success_vs_match.R, transition_probabilities_histograms.R.
          occupancy_times_ft_histograms.R: code for Figure 3.
          sojourn_times.R: code for Figure 4 (violin plots).
          stationary_distribution.R: code on the calculation of the stationary distribution.
          success_vs_distance.R: code for Figure 5.
          success_vs_match.R: code for Figure 6.
          transition_probabilities_histograms.R: code for Figure 2.
          
8. Folder "script". Four general scripts for the analysis: clean_MIA_all.R, modelization.R, rhat.R, shot_chart2.R.
          clean_MIA_all.R: code for adapting the data to our analysis and transforming it into matricial format.
          modelization.R: code for computing the jags model and seeing the posterior results.
          rhat.R: rhat of the chains (see Table 1).
          shot_chart2.R: code for Figure 1 (shot chart).
          
