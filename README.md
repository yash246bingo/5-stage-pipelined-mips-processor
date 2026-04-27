# 5-Stage Pipelined MIPS Processor in Verilog HDL

<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Architecture-5--Stage%20Pipeline-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Target-FPGA-red?style=for-the-badge">
</p>
## Complete Datapath

<p align="center">
  <img src="docs/datapath.png" width="100%">
</p>

## Simulation Waveform

<p align="center">
  <img src="docs/waveform.png" width="100%">
</p>
---

## Overview

A complete **5-stage pipelined MIPS-style processor** designed and implemented in **Verilog HDL**.

This project demonstrates:

- Pipeline execution
- Hazard detection
- Stall insertion
- Forwarding logic
- Jump handling
- RTL simulation
- FPGA synthesis using **Xilinx Vivado**

---

## Pipeline Stages

```text
IF  →  ID  →  EX  →  MEM  →  WB