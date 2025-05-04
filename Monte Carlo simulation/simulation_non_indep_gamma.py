#!/usr/bin/env python3
"""
Scenario: Linked Event Pairs but Independent from Others
---------------------------------------------------------
- CS+IBR are simultaneous and have their own Poisson frequency (11.75 per epoch).
- IBR+G and G+Mov are linked pairs but independent of the others.
- The full AU sequence (CS → IBR → G → Mov) must happen in order.
- The full AU sequence must occur within 30 seconds.

Event Frequencies (per epoch, from the table):
    - CS+IBR = 11.75
    - IBR+G  = 9.5
    - G+Mov  = 7.42

We generate timestamps for each event type based on their observed frequencies.
For each epoch, we count how many valid chains exist under the AU rules.
"""

import numpy as np
from scipy.stats import gamma

# ---------------- CONFIG ----------------
n_epochs = 88
n_permutations = 10000
epoch_length_sec = 900  # 15 minutes

# Poisson means for G+Mov (from 88-epoch estimates)
lambda_G_Mov   = 7.42   # G+Mov linked

# CS+IBR and IBR+G observed values (from 4 epochs)
CS_IBR_observations = np.array([12,12,11,12])
IBR_G_observations = np.array([8, 9, 12, 9])

n_CS_IBR = len(CS_IBR_observations)
n_IBR_G = len(IBR_G_observations)

sum_CS_IBR_observations = np.sum(CS_IBR_observations)
sum_IBR_G_observations = np.sum(IBR_G_observations)

# Define Gamma(α, β) parameters
alpha_prior = 1  # Example: shape parameter
beta_prior = 0.1 # Example: rate parameter

# Calculate posterior parameters
alpha_posterior_CS_IBR = alpha_prior + sum_CS_IBR_observations
beta_posterior_CS_IBR = beta_prior + n_CS_IBR

alpha_posterior_IBR_G = alpha_prior + sum_IBR_G_observations
beta_posterior_IBR_G = beta_prior + n_IBR_G

# Number of samples to draw from the posterior distribution
n_samples = 100

# Generate 100 samples of CS+IBR lambda and IBR+G lambda from Gamma distribution
lambda_CS_IBR_samples = gamma.rvs(alpha_posterior_CS_IBR, scale=1/beta_posterior_CS_IBR, size=n_samples)
print("lambda_CS_IBR:", lambda_CS_IBR_samples)


lambda_IBR_G_samples = gamma.rvs(alpha_posterior_IBR_G, scale=1/beta_posterior_IBR_G, size=n_samples)
print("lambda_IBR_G:", lambda_IBR_G_samples)

# Observed total ~ 4.01 per epoch x 88 = ~353
observed_total = 4.01 * n_epochs
max_chain_offset = 30.0  # Entire chain must complete within 30 seconds

def simulate_one_epoch():
    """
    Generate Poisson events for CS+IBR, IBR+G, G+Mov in [0..900).
    Count how many strictly ordered quadruples (CS -> IBR -> G -> Mov) 
    fit into a 30-second total window from CS to Mov.
    """
    # 1) Sample lambda_CS_IBR from the precomputed Gamma array
    lambda_CS_IBR = np.random.choice(lambda_CS_IBR_samples)
    
    # 1) Sample lambda_IBR_G from the precomputed Gamma array
    lambda_IBR_G = np.random.choice(lambda_IBR_G_samples)
    
    
    # 1) Poisson draws
    n_cs_ibr  = np.random.poisson(lambda_CS_IBR) # Sampled from Gamma array
    n_ibr_g   = np.random.poisson(lambda_IBR_G) # Sampled from Gamma array
    n_g_mov   = np.random.poisson(lambda_G_Mov)

    # 2) Generate random timestamps for linked events
    cs_ibr_times = np.random.rand(n_cs_ibr)  * epoch_length_sec  # CS+IBR are simultaneous
    ibr_g_times  = np.random.rand(n_ibr_g)  * epoch_length_sec   # IBR+G linked
    g_mov_times  = np.random.rand(n_g_mov)  * epoch_length_sec   # G+Mov linked

    # Sort them
    cs_ibr_times.sort()
    ibr_g_times.sort()
    g_mov_times.sort()

    count_sequences = 0

    # 3) Nested loops to count valid chains:
    # We require:
    #   tCS = tIBR < tG < tMov
    #   (tMov - tCS) <= 30
    for t_cs_ibr in cs_ibr_times:
        # Find IBR+G times greater than tCS
        ibr_g_candidates = ibr_g_times[ibr_g_times > t_cs_ibr]
        for t_ibr_g in ibr_g_candidates:
            # Find G+Mov times greater than tG
            g_mov_candidates = g_mov_times[g_mov_times > t_ibr_g]
            # Also must ensure (tMov - tCS) <= 30 => tMov <= t_cs + 30
            upper_bound = t_cs_ibr + max_chain_offset
            # Get all tMov that are <= upper_bound
            idx = np.searchsorted(g_mov_candidates, upper_bound, side='right')
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

    print("=== Linked Event Pairs but Independent from Others ===")
    print("=== Gamma-Prior Adjusted CS+IBR, IBR+G Strict Order CS -> IBR -> G -> Mov ===")
    print(f"Epochs: {n_epochs}, Permutations: {n_permutations}")
    print(f"Lambda: G+Mov={lambda_G_Mov}")
    print(f"CS+IBR, IBR+G samples generated using Gamma(α={alpha_prior:.2f}, β={beta_prior})")
    print(f"Observed total: {observed_total:.2f}")
    print("(CS+IBR occur together, IBR-G and G-Mov are linked but independent of others)")
    print(f"Chain must finish within 30s from CS: (tMov - tCS) <= 30")
    print(f"Mean Sim = {mean_sim:.2f} (std={std_sim:.2f}, min={min_sim}, max={max_sim})")
    print(f"Empirical p-value = {p_value:.6f}")


if __name__ == "__main__":
    main()
