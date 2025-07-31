
# 🏔️ GEOLOGIC CO₂ STORAGE  
<sub><sup>Six-year simulation • Risk assessment • History matching • Optimization</sup></sub>
Closed-loop reservoir management (CLRM) is the gold standard for safe geologic CO₂ storage, but full-scale implementations demand massive data and HPC resources. We present a lightweight CLRM prototype—15-zone model, Monte-Carlo risk screen, two-stage history match, and dual-objective well-rate optimisation—to prove the concept within tight time and compute limits, while keeping the workflow extensible for higher-fidelity upgrades later.


---

## 📑 Table of Contents
1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Key Methodologies](#key-methodologies)
   - [Risk Assessment](#risk-assessment)
   - [Model Updating](#model-updating)
   - [Optimization](#optimization)
4. [Conclusion](#conclusion)

---

<h2 id="overview">🌍 Overview</h2>
This repository contains the end-to-end workflow used in our study  
on **geologic CO₂ storage** over a six-year life-cycle:

* **4 years of active injection** — CO₂ is continuously injected into a deep saline formation.  
* **2 years of post-injection monitoring** — pressure dissipation and plume migration are tracked.

We break the problem into three interconnected tasks:

1. **Risk Assessment** – quantify the probability and severity of **CO₂ leakage** and **fracturing** under geological uncertainty.  
2. **Model Updating** – calibrate the reservoir model to sparse field observations via two-stage history matching.  
3. **Optimization** – search for well configurations and injection-rate schedules that minimise risk while meeting storage targets.

Throughout, we employ a **15-zone homogeneous‐permeability model**, which balances geological realism with computational tractability.  
The key challenges we tackle are:

* **Parameter uncertainty** – actual permeability varies spatially and is poorly constrained.  
* **Competing risks** – aggressive injection promotes storage efficiency but elevates cap-rock leakage and fracturing risks.  
* **Data scarcity** – only limited bottom-hole pressure (BHP) and tracer data are available for calibration.

---

<h2 id="repository-structure">🗂️ Repository Structure</h2>

```text
GEOLOGIC_CO2_STORAGE/
├── Risk Assessment/      # Probabilistic leakage / pressure analysis
├── Model Updating/       # Two-stage history matching
├── Optimization/         # Well & rate optimisation scripts
├── Utils/                # MRST helpers, plotting, I/O
```

| Folder | Core Content |
|--------|--------------|
| **Risk Assessment/** | • Monte-Carlo permeability realisations (n=20)<br>• CO₂-volume & pressure metrics<br>• Uncertainty visualisation scripts |
| **Model Updating/**  | • Best-realisation selection<br>• 15-zone permeability multipliers<br>• Pre‑/post‑update BHP & saturation plots |
| **Optimization/**    | • Brute‑force two‑well placement search (≥10 configs)<br>• Dynamic rate allocation (1 Mt yr⁻¹ total)<br>• Pareto‑front analysis |
| **Utils/**           | `.mat` loaders, MRST runners, plotting helpers |

---

<h2 id="key-methodologies">🔬 Key Methodologies</h2>

### Risk Assessment
We propagate geological uncertainty by sampling **20 log‑normal permeability realisations** for each of the 15 zones:

$$
\log_{10}(k_i) \sim \mathcal{N}(\mu_i,\sigma_i^2),\qquad i=1,\dots,15
$$

Each realisation is stored as a column of `perm_all.mat`. For every run we track two primary risk indicators:

| Metric | Proxy & rationale | Output file |
|--------|------------------|-------------|
| **Leakage potential** | CO₂ volume that reaches the top reservoir layer – proxy for cap‑rock breach | `co2_volume_all.mat` |
| **Fracture risk** | Maximum reservoir over‑pressure – correlated with fracturing | `max_pressure_all.mat` |

Both arrays have shape (20 × N<sub>time</sub>) and are post‑processed into histograms and spatial maps.

### Model Updating
Field‑measured BHP, pore pressure, and saturation are sparse (monthly logs at three wells).  
We therefore adopt a **two‑stage history‑matching strategy**:

1. **Best Realisation Selection**  
   $$\text{Mismatch}=\frac{1}{N}\sum_{t=1}^{N}|x_t^{\text{sim}}-x_t^{\text{obs}}|$$  
   The realisation with the lowest mismatch becomes the **baseline model**.

2. **Permeability Updating**  
   A 15‑element multiplier vector \(\boldsymbol{\alpha}\) is optimised to minimise mismatch:  
   $$\mathbf{k}^{\text{updated}} = \mathbf{k}^{\text{best}} \circ \boldsymbol{\alpha}.$$

<div align="center">

| **Before Update** | | |
|:--:|:--:|:--:|
| ![](resources/before/update_BHP_beforeupdate.png) | ![](resources/before/update_PWell_beforeupdate.png) | ![](resources/before/update_SWell_beforeupdate.png) |

| **After Update** | | |
|:--:|:--:|:--:|
| ![](resources/after/update_BHP_4.png) | ![](resources/after/update_PWell_4.png) | ![](resources/after/update_SWell_4.png) |

</div>

### Optimization
To **simultaneously minimise leakage & fracturing risks** while storing 6 Mt of CO₂, we treat well layout and rate allocation as coupled design variables:

<div align="center">

#### 🚩 Well Placement Optimization
<table>
  <tr>
    <td align="center"><img src="resources/optima/perm_udLocation_map_1.png" width="45%"></td>
    <td align="center"><img src="resources/optima/plume_udLocation_1.png" width="45%"></td>
  </tr>
  <tr>
    <td align="center"><em>Permeability map with candidate well pairs (≥8‑block spacing)</em></td>
    <td align="center"><em>Predicted CO₂ plume for best pair</em></td>
  </tr>
</table>

#### 💧 Injection Rate Optimization
<table>
  <tr>
    <td align="center"><img src="resources/untitled%20folder/Rate.png" width="45%"></td>
    <td align="center"><img src="resources/untitled%20folder/CO2_leakage%20.png" width="45%"></td>
  </tr>
  <tr>
    <td align="center"><em>Adaptive rate‑splitting (Σ=1 Mt yr⁻¹)</em></td>
    <td align="center"><em>Leakage‑risk trajectory</em></td>
  </tr>
</table>

</div>

Algorithm notes:

* **Placement search:** brute‑force enumeration of ≥10 two‑well layouts, each run for a short forecast.  
* **Dynamic rate control:** quarterly re‑allocation based on current risk gradient.  
* **Trade‑off analysis:** Pareto front (leakage vs. pressure) quantifies achievable gains.

---

<h2 id ="conclusion">🏁 Conclusion</h2>

Our integrated workflow delivers a **robust, data-informed roadmap** for CO₂ sequestration:

* **Probabilistic screening** reveals leakage & fracturing envelopes.  
* **Zone‑wise history matching** reduces predictive variance.  
* **Coupled optimisation** cuts both leakage volume and pressure peaks by >30 % relative to naïve designs.

> **Takeaway:** Uncertainty quantification + adaptive calibration + multi‑objective optimisation is essential for safe, cost‑effective deployment of geologic CO₂ storage projects.

---

