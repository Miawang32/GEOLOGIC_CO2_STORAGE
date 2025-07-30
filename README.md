# GEOLOGIC CO₂ STORAGE

## Overview
This project focuses on simulating geologic CO₂ storage over a 6-year period, including both injection and post-injection monitoring phases. The work is structured into three main parts. Risk Assessment evaluates the potential for CO₂ leakage and reservoir fracturing across 20 permeability realizations, using top-layer gas volume and maximum pressure as risk indicators. Model Updating integrates observed well data to identify the most representative simulation realization and adjusts the permeability model via zone-wise multipliers to improve predictive accuracy. Optimization explores improved injection strategies through adjustments to well locations and injection rates, aiming to minimize risks while preserving total injection volumes.

## Repository Structure

- **Model Updating/**  
  Scripts for ensemble and history-matching methods, including Ensemble Kalman Filter (EnKF) and adjoint techniques, aimed at quantifying uncertainty in model predictions.

- **Optimization/**  
  Tools for optimizing injection schedules and monitoring designs. These include optimization algorithms that efficiently explore solution spaces to identify optimal combinations of well controls and locations.

- **Risk Assessment/**  
  Probabilistic analysis tools for evaluating risks associated with CO₂ leakage and plume migration, essential for prioritizing environmental safety and formation integrity.

- **Utils/**  
  Helper functions and wrappers supporting the main analytical workflows, including plotting utilities, input/output operations, and interfaces with MRST (Matlab Reservoir Simulation Toolbox).

## Key Methodologies
- **Model Simplification:** Reducing computational complexity for efficient analysis.
- **Ensemble-Based Uncertainty Quantification:** Generating multiple permeability realizations to evaluate prediction uncertainties.
- **Sensitivity Analysis:** Identifying influential parameters to prioritize data collection and reduce model uncertainty.
- **Optimization Algorithms:** Balancing risk of leakage versus risk of fracturing by efficiently exploring well configurations.

## Conclusion 
In summary, the model simplification strategy—dividing the reservoir into 15 homogeneous permeability zones—effectively reduces computational complexity and makes the analysis tractable, but may overlook fine-scale heterogeneities critical to flow behavior. A key challenge is the trade-off between minimizing CO₂ leakage and avoiding reservoir fracturing; optimizing for one risk can increase the other. To address this, ensemble simulations and sensitivity analyses were used to quantify uncertainty and identify influential parameters. Ultimately, the combination of forward simulation, history matching, and optimization enables a more robust and risk-aware approach to designing and managing CO₂ storage operations.
