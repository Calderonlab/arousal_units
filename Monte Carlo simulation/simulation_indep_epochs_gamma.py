#!/usr/bin/env python3
"""
Strict Order Simulation with Gamma-Prior Sampling for IBR Frequency
-------------------------------------------------------------------
- We enforce the AU sequence:
    tCS < tIBR < tG < tMov
    (tMov - tCS) <= 30s
- Instead of extrapolating IBR from 4 epochs to 88, we sample from a 
  Gamma distribution built from the 4 observed values of IBR:
    [19.26, 10.41, 17.08, 16.26]
- The Gamma prior (α + 1, β = 0.1) produces a distribution of 100 values.
- Each Monte Carlo run samples lambda_IBR from this Gamma-based array.
"""
from scipy.stats import gamma
import numpy as np

# ---------------- CONFIG ----------------
n_epochs = 88
n_permutations = 10000
epoch_length_sec = 900  # 15 minutes

# Poisson means for CS, G, Mov (from 88-epoch estimates)
lambda_CS  = 24.93
lambda_G   = 17.53
lambda_Mov = 10.39

# IBR observed values (from 4 epochs)
IBR_observations = np.array([13, 13, 21, 16])
n = len(IBR_observations)
sum_IBR_observations = np.sum(IBR_observations)

# Define Gamma(α, β) parameters
alpha_prior = 1  # Example: shape parameter
beta_prior = 0.1 # Example: rate parameter

# Calculate posterior parameters
alpha_posterior = alpha_prior + sum_IBR_observations
beta_posterior = beta_prior + n

# Number of samples to draw from the posterior distribution
n_samples = 100

# Generate 100 samples of IBR lambda from Gamma distribution
lambda_IBR_samples = gamma.rvs(alpha_posterior, scale=1/beta_posterior, size=n_samples)
#lambda_IBR_samples = np.random.gamma(shape=alpha_prior, scale=1/beta_prior, size=50)

print("lambda_IBR:", lambda_IBR_samples)
# Observed total ~ 4.01 per epoch x 88 = ~353
observed_AU_per_epoch = 4.01
observed_total = observed_AU_per_epoch * n_epochs

def simulate_one_epoch():
    """
    Generate Poisson events for CS, IBR, G, Mov in [0..900).
    Count how many strictly ordered quadruples (CS -> IBR -> G -> Mov) 
    fit into a 30-second total window from CS to Mov.
    """
    # 1) Sample lambda_IBR from the precomputed Gamma array
    lambda_IBR = np.random.choice(lambda_IBR_samples)

    # 2) Poisson draws
    n_cs  = np.random.poisson(lambda_CS)
    n_ibr = np.random.poisson(lambda_IBR)  # Sampled from Gamma array
    n_g   = np.random.poisson(lambda_G)
    n_mov = np.random.poisson(lambda_Mov)

    # 3) Uniform random timestamps
    cs_times  = np.random.rand(n_cs)  * epoch_length_sec
    ibr_times = np.random.rand(n_ibr) * epoch_length_sec
    g_times   = np.random.rand(n_g)   * epoch_length_sec
    mov_times = np.random.rand(n_mov) * epoch_length_sec

    # Sort them
    cs_times.sort()
    ibr_times.sort()
    g_times.sort()
    mov_times.sort()

    count_sequences = 0

    # 4) Nested loops to count valid chains:
    for t_cs in cs_times:
        ibr_candidates = ibr_times[ibr_times > t_cs]
        for t_ibr in ibr_candidates:
            g_candidates = g_times[g_times > t_ibr]
            for t_g in g_candidates:
                mov_candidates = mov_times[mov_times > t_g]
                upper_bound = t_cs + 30.0  # AU must complete in <=30s
                idx = np.searchsorted(mov_candidates, upper_bound, side='right')
                count_sequences += idx

    return count_sequences

def main():
    sim_totals = np.zeros(n_permutations, dtype=float)

    for i in range(n_permutations):
        total_count = 0
        for _ in range(n_epochs):
            total_count += simulate_one_epoch()
        sim_totals[i] = total_count

    # Compare
    p_value = (np.sum(sim_totals >= observed_total) + 1) / (n_permutations + 1)
    mean_sim = np.mean(sim_totals)
    std_sim  = np.std(sim_totals)
    min_sim  = np.min(sim_totals)
    max_sim  = np.max(sim_totals)

    print("=== Gamma-Prior Adjusted IBR, Strict Order CS -> IBR -> G -> Mov ===")
    print(f"Epochs: {n_epochs}, Permutations: {n_permutations}")
    print(f"Lambda: CS={lambda_CS}, G={lambda_G}, Mov={lambda_Mov}")
    print(f"IBR samples generated using Gamma(α={alpha_prior:.2f}, β={beta_prior})")
    print(f"Observed total: {observed_total:.2f}")
    print("Lambda_IBR is randomly sampled from the Gamma distribution")
    print(f"Mean Sim = {mean_sim:.2f} (std={std_sim:.2f}, min={min_sim}, max={max_sim})")
    print(f"Empirical p-value = {p_value:.6f}")


if __name__ == "__main__":
    main()
