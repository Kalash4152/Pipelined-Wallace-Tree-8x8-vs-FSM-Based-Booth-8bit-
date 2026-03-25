# 🚀 8×8 Multiplier Design & Comparison (Booth vs Wallace)

## 📌 Overview
This project presents the design, implementation, and comparative analysis of two multiplier architectures:

- FSM-based Booth Multiplier
- Pipelined Wallace Tree Multiplier

The goal is to evaluate performance trade-offs in terms of latency, throughput, area, timing, and power using Verilog RTL and FPGA synthesis.

---

## ⚙️ Architectures Implemented

### 🔹 Booth Multiplier (Sequential)
- FSM-controlled iterative design
- Performs multiplication over multiple cycles
- Area-efficient but slower

### 🔹 Wallace Tree Multiplier (Pipelined)
- Parallel carry-save reduction (CSA)
- Multi-stage pipeline (6 stages)
- High throughput and low delay

---

## 🧠 Key Concepts Used
- Carry-Save Addition (CSA)
- Pipeline Design
- Partial Product Reduction
- FSM Control Logic
- FPGA Timing & Power Analysis

---

## 📊 Results Summary

| Metric        | Booth Multiplier | Wallace Multiplier |
|--------------|----------------|-------------------|
| Architecture | Sequential (FSM) | Parallel (Pipeline) |
| Latency      | 8 cycles        | 6 cycles          |
| Throughput   | 1 / 8 cycles    | 1 / cycle         |
| LUTs         | 20              | 98                |
| Flip-Flops   | 36              | 206               |
| Delay        | ~2.3 ns         | ~1.5 ns           |
| Fmax         | ~430 MHz        | ~660 MHz          |

---

## ⚡ Key Insights
- Wallace tree achieves significantly higher throughput due to parallelism
- Booth multiplier minimizes hardware but increases latency
- Carry-save reduction eliminates intermediate carry propagation delays
- Trade-off between performance and area is clearly demonstrated

---

## 🔬 Verification & Analysis
- Functional verification using custom testbenches
- Continuous pipeline validation (Wallace)
- FPGA synthesis using Vivado
- Timing, area, and power reports analyzed

---

## ⚠️ Notes on Results
- Timing results are post-synthesis estimates
- Power analysis is vectorless (no switching activity)
- Relative comparison between architectures is valid

---

## 📁 Project Structure
