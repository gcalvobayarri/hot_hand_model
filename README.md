# hot_hand_model
SOFTWARE NEEDED: R and JAGS. All codes are in R language.

This folder contains the statistical analysis carried out in the paper "Can the hot hand phenomenon be modelled? A Bayesian hidden Markov approach". The material available here is as follows.

1. Folder "data": it includes three type of elements, for instance, for the Miami Heat team: MIA_all.RData, shots_MIA_all2.RData, matrix_data_ft_complete_season_all2.RDATA.
	* MIA_all.RData: a data frame of all the shots of the season.
	* shots_MIA_all2.RData: a vector of the results of the shots, where 1 indicates a shot made and 0 indicates a shot missed.
	* matrix_data_ft_complete_season_all2.RDATA: the response variable (matrix_tiros) and covariates (distance_matrix, ft) in the matrix format.

2. Folder "documents": it contains a plot of the basketball court which is used in the shot chart.

3. Folder "functions": it includes the function for the n-step transition probability matrix and the logarithmic summation.

4. Folder "model":
   	* the Bayesian longitudinal hidden Markov model used in the study in JAGS format (longitudinal_model_ft_re2.txt).
   	* The longitudinal model without hidden structure (simple_model.txt).

5. Folder "results": it contains four type of elements, for instance, for the Miami Heat team: 
   	* rsamps_hot_hand_ft_re_all2_v2.RData: a sample from JAGS of the posterior distribution of the parameters for the BLHMM.
   	* rsamps_simple.RData: a sample from JAGS of the posterior distribution of the parameters for the simplest model.
   	* log_cpo_HMM.RData: approximate cpos for the BLHMM in logarithmic scale.
   	* log_cpo_simple.RData: approximate cpos for the simplest model in logarithmic scale.

6. Folder "results_scripts": it includes six type of scripts on posterior results shown in the paper, for instance, for the Miami Heat team:
	* occupancy_times_ft_histograms.R: code for Figure 3.
	* sojourn_times.R: code for Figure 4 (violin plots).
	* stationary_distribution.R: code on the calculation of the stationary distribution.
	* success_vs_distance.R: code for Figure 5.
	* success_vs_match.R: code for Figure 6.
	* transition_probabilities_histograms.R: code for Figure 2.

7. Folder "script": it contains four general scripts for the analysis, i. e., clean_MIA_all2.R, modelization2.R, rhat.R, shot_chart2.R.
	* clean_MIA_all2.R: code for adapting the data to our analysis and transforming it into matrix format.
	* modelization2.R: code for computing the JAGS BLHMM and seeing the posterior results.
	* modelization_simple.R: code for computing the JAGS simplest model and seeing the posterior results.
	* rhat.R: rhat of the chains (see Table 1).
	* shot_chart2.R: code for Figure 1 (shot chart).
 	* In addition, it contains the CPO folder.
          
