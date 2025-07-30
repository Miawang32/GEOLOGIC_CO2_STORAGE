# GEOLOGIC_CO2_STORAGE

> **A MATLAB-based workflow for geological CO₂ storage modelling, history matching, optimisation, and risk assessment.**


---

## ✨ Project Overview
Geologic storage of carbon dioxide (GCS) is recognised as a key technology for large-scale decarbonisation.  
This repository provides a modular MATLAB implementation (100 % MATLAB) that wraps and extends the **MATLAB Reservoir Simulation Toolbox (MRST)** carbon-storage functionality — including history matching (Model Updating), design optimisation, and quantitative risk assessment — for rapid scenario studies and research prototyping. :contentReference[oaicite:0]{index=0}  

---

## 📂 Repository Structure 
```text
GEOLOGIC_CO2_STORAGE/
├── Model Updating/      # Ensemble & history-matching scripts (EnKF, adjoints, etc.)
├── Optimization/        # Injection-schedule & monitoring-design optimisation
├── Risk Assessment/     # Probabilistic leakage / plume migration analysis
├── Utils/               # Common helper functions (MRST wrappers, plotting, I/O)
