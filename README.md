# 🌍 CO₂ Geologic Storage Simulation & Risk Assessment  
**PTE-412/464 Final Project – University of Southern California**

This repository presents a comprehensive simulation study of geologic CO₂ storage, completed as the final project for the PTE-412/464 course "Modeling, Simulation, and Management of Subsurface Flow Systems", instructed by Prof. Behnam Jafarpour at USC.

We simulate the injection, monitoring, and optimization of CO₂ storage in a synthetic reservoir under geological uncertainty, evaluate leakage and fracturing risks, and perform model updating with observation data.

---

## 📁 Repository Overview

.
├── figures/ # All visualization results
│ ├── perm_map.png # Permeability map (15-layer zonation)
│ ├── poro_map.png # Porosity map
│ ├── PB1_B_Realization_.png # Realization plots (Region B)
│ ├── PB1_C_Realization_.png # Realization plots (Region C)
│ ├── Q2a_BHPWell.png # Injection well BHP over time
│ └── Q2d_update_SWell_*.png # Saturation before & after model update
├── data/ # Simulation output files (.mat)
├── scripts/ # MATLAB simulation scripts (not shown)
└── README.md

yaml
Always show details

Copy

---

## 🔍 Project Tasks

### 1. Risk Assessment
- Simulated 20 permeability realizations for a 15-layer reservoir using Monte Carlo sampling.
- Evaluated CO₂ plume migration, pressure build-up, and storage distribution.
- Quantified risks of:
  - **Leakage**: via CO₂ volume in top layer.
  - **Fracturing**: via max pore pressure.

### 2. Model Updating
- Compared simulated data with synthetic field measurements from injection/observation wells.
- Identified best-matching realization.
- Updated permeability multipliers to improve history match.

### 3. Optimization (Optional for Extension)
- Well placement and injection rate adjustment to minimize leakage and fracturing simultaneously.

---

## 🧠 Key Concepts
- Monte Carlo Sampling (20 realizations × 15-layer zonation)
- Risk Indicators: top-layer CO₂ saturation & pressure maxima
- Ensemble history matching
- Pressure/Saturation monitoring
- Uncertainty quantification

---

## 📊 Sample Visualizations

### 🗺️ Permeability & Porosity Maps
| Permeability | Porosity |
|--------------|----------|
| ![](figures/perm_map.png) | ![](figures/poro_map.png) |

---

### 🔁 Realization Results (B Region)
| Realization 1 | Realization 2 | Realization 3 |
|---------------|---------------|---------------|
| ![](figures/PB1_B_Realization_1.png) | ![](figures/PB1_B_Realization_2.png) | ![](figures/PB1_B_Realization_3.png) |

---

### 🔄 Realization Results (C Region)
| Realization 4 | Realization 5 | Realization 6 |
|---------------|---------------|---------------|
| ![](figures/PB1_C_Realization_4.png) | ![](figures/PB1_C_Realization_5.png) | ![](figures/PB1_C_Realization_6.png) |

---

### 📉 Bottom-Hole Pressure at Injection Well
![](figures/Q2a_BHPWell.png)

---

### 🔁 Saturation Evolution During Model Updating
| SWell 1 | SWell 2 | SWell 3 |
|---------|---------|---------|
| ![](figures/Q2d_update_SWell_1.png) | ![](figures/Q2d_update_SWell_2.png) | ![](figures/Q2d_update_SWell_3.png) |

---

## 📚 Course Information
- **Course**: PTE-412/464 – Modeling & Simulation of Subsurface Flow Systems  
- **Instructor**: Prof. Behnam Jafarpour  
- **Term**: Spring 2023  
- **University**: University of Southern California (USC)  
- **Project Type**: Final Individual Project – CO₂ Storage Track  

---

## ✍️ Author

**Yifan Jiang**  
Ph.D. Student, University of Southern California  
Project Submission Date: May 2023
