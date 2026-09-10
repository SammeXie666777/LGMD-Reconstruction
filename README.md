# LGMD Neuron Reconstruction

Morphological reconstruction and passive biophysical modelling of the locust **LGMD**
(Lobula Giant Movement Detector) neuron, from a traced SWC skeleton through to a NEURON
model fitted against current-clamp recordings.

The traced neuron arrives as a disconnected, unsorted SWC. This repository contains the MATLAB
tooling that repairs and characterises that morphology, exports it to NEURON `.hoc`, and the
Python notebooks that fit passive membrane parameters to experimental data.

## Pipeline

```
traced SWC  ->  repair topology      (MATLAB: floating branches, zero-length nodes)
            ->  characterise         (MATLAB: morphometrics, Sholl analysis)
            ->  export to NEURON     (MATLAB: export_hoc)
            ->  fit passive params   (Python: NEURON + scipy optimisation)
```

### 1. Morphology repair and analysis (MATLAB)

`code/Matlab/Workflow_Process_Treee.m` is the driver — run it to go from raw SWC to exported HOC.

| Script | Role |
|---|---|
| `visualize_swc_interactive.m` | 3D view of the skeleton with interactive node selection (brush/tip). |
| `swc2AdjMatrix.m` | SWC to adjacency matrix plus node coordinates and radii. |
| `process_floating_branches.m` | Finds disconnected components and reattaches them to the true root. |
| `FindNode_below.m` | Returns all descendants of a node, topologically. |
| `Check_ZeroLength.m` | Flags zero-length segments that break NEURON. |
| `Neuron_Morphology.m` | Total dendritic length, mean radius, surface area. |
| `Sholl_analysis_TREE.m` | Sholl intersection profiles (2D and 3D), via the TREES toolbox. |
| `save_to_swc.m` / `exportToASCII.m` | Write repaired SWC / two-column ASCII traces. |
| `export_hoc.m` | Convert SWC to a NEURON `.hoc` cell definition with named sections. |

### 2. Passive modelling (Python / NEURON)

| Notebook | Role |
|---|---|
| `code/Python_Neuron/Fit_PassiveCurrent.ipynb` | Loads the HOC model, runs current injections (-2/-4/-6 nA), fits Rm, Cm, Ra against recorded traces. |
| `code/Python_Neuron/LGMD_Optimization.ipynb` | Parameter optimisation (`scipy` least-squares / differential evolution) plus topology and diameter sanity checks. |
| `code/Python_Neuron/LGMD_Neuron_Archive.ipynb` | Earlier exploratory version. |

Starting values follow Peron (2007): Vm -65 mV, Rm 5000 ohm-cm2, Ra 57 ohm-cm.

## Data

| Path | Contents |
|---|---|
| `Data/LGMD_Reconstruction_swc/` | Traced skeletons (`.swc`, `.eswc`) and repaired outputs. |
| `Data/LGMD_Reconstruction_swc/Output/Fix_Connection/` | Intermediate figures and node IDs from the reconnection step. |
| `Data/LGMD_Reconstruction_swc/Output/Sholl_analysis/` | Sholl intersection figures. |
| `Data/Passive_CurrentClamp/` | Current-clamp recordings used as fitting targets, raw and subtracted. |
| `Data/Soumi_New Construction/` | Alternative reconstructions from collaborators. |

Model variants live in `code/Python_Neuron/`: `LGMD_Complete_Construction.hoc` is the full
morphology, `_NodesRemoved` drops problem nodes, `_MinorAdjust` carries hand-tuned diameters.

## Requirements

- MATLAB with the [TREES toolbox](https://www.treestoolbox.org/) on the path (Sholl analysis)
- Python 3 with `neuron`, `numpy`, `scipy`, `pandas`, `matplotlib`, `plotly`
- The notebooks `%pip install neuron` on first run

## Notes

The SWC repair step is interactive by design — `visualize_swc_interactive.m` expects you to pick
root and parent nodes for floating branches by hand, since automatic reattachment was unreliable
on this reconstruction.
