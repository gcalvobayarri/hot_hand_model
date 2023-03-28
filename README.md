# hot_hand_model
SOFTWARE NEEDED: R and JAGS. All codes are in R language.

This folder contains the statistical analysis carried out in the paper "A Bayesian hidden Markov model for assessing the hot hand phenomenon in basketball shooting performance". The material available here is as follows.

1. Folder "data": it includes three elements: MIA_all.RData, shots_MIA_all.RData, matrix_data_ft_complete_season_all.RDATA.
	MIA_all.RData: a data frame of all the shots of the season.
	shots_MIA_all.RData: a vector of the results of the shots, where 1 indicates a shot made and 0 indicates a shot missed.
	matrix_data_ft_complete_season_all.RDATA: the response variable (matrix_tiros) and covariates (distance_matrix, ft) in the matrix format.

2. Folder "documents": it contains a plot of the basketball court which is used in the shot chart.

3. Folder "figures": all of the figures presented in the paper in PDF format.

4. Folder "functions": it includes the function for the n-step transition probability matrix.

5. Folder "model": the Bayesian longitudinal hidden Markov model used in the study in JAGS format.

6. Folder "results": it contains a sample from JAGS of the posterior distribution of the parameters (rsamps_hot_hand_ft_re_all2.RData).

7. Folder "results_scripts": it includes six scripts on posterior results shown in the paper, i. e., occupancy_times_ft_histograms.R, sojourn_times.R, stationary_distribution.R, success_vs_distance.R, success_vs_match.R, transition_probabilities_histograms.R.
	occupancy_times_ft_histograms.R: code for Figure 3.
	sojourn_times.R: code for Figure 4 (violin plots).
	stationary_distribution.R: code on the calculation of the stationary distribution.
	success_vs_distance.R: code for Figure 5.
	success_vs_match.R: code for Figure 6.
	transition_probabilities_histograms.R: code for Figure 2.

8. Folder "script": it contains four general scripts for the analysis, i. e., clean_MIA_all.R, modelization.R, rhat.R, shot_chart2.R.
	clean_MIA_all.R: code for adapting the data to our analysis and transforming it into matrix format.
	modelization.R: code for computing the JAGS model and seeing the posterior results.
	rhat.R: rhat of the chains (see Table 1).
	shot_chart2.R: code for Figure 1 (shot chart).
          
