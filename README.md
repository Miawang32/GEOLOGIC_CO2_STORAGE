# GEOLOGIC CO₂ STORAGE

## Overview
This repository contains models and tools for analyzing and optimizing geologic CO₂ storage, aiming to balance injection efficiency with environmental safety and formation integrity. The project employs various methods to simplify complex geological models, assess risk factors such as leakage and fracturing, and optimize monitoring and injection strategies.

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

This repository provides comprehensive resources for researchers and engineers working on efficient, safe, and environmentally responsible geologic CO₂ storage solutions.
