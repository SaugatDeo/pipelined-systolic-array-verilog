# Pipelined 4×4 Systolic Array — Verilog

> AI Accelerator Architecture | RTL Design | Hardware-Software Co-Verification

A fully verified hardware implementation of a pipelined 
systolic array for matrix multiplication in Verilog, 
targeting AI accelerator architectures similar to Google TPU.

---

## Architecture Overview
```
Matrix A →→→→→→→→→→→→→→→→→→→
         ↓      ↓      ↓      ↓
Matrix  PE00 → PE01 → PE02 → PE03
B ↓      ↓      ↓      ↓      ↓
        PE10 → PE11 → PE12 → PE13
         ↓      ↓      ↓      ↓
        PE20 → PE21 → PE22 → PE23
         ↓      ↓      ↓      ↓
        PE30 → PE31 → PE32 → PE33
                              ↓
                           Results
```

- **16 Processing Elements** in a 4×4 grid
- Each PE performs pipelined **Multiply-Accumulate (MAC)**
- Matrix A flows **left → right**
- Matrix B flows **top → bottom**
- Results accumulate **locally** — no central memory bus

---

## Key Features

- **Pipelined PE design** — new data accepted every clock cycle
- **Independent valid handshaking** — separate valid signals 
  for A rows and B columns
- **Cycle-accurate data skewing** — correct matrix alignment
- **Hardware-Software co-verification** — RTL verified against 
  NumPy golden reference
- **Scalable RTL** — uses generate blocks for clean instantiation

---

## Project Structure
```
├── src/
│   └── design.sv        # PE + Systolic Array RTL
├── tb/
│   └── testbench.sv     # Cycle-accurate testbench
├── verify/
│   └── verify.py        # NumPy co-verification script
└── README.md
```

---

## Verification Results

Verified by computing **A × I = A** (identity matrix test):

| Expected | Got |
|----------|-----|
| 1 2 3 4  | 1 2 3 4 ✅ |
| 5 6 7 8  | 5 6 7 8 ✅ |
| 1 2 1 2  | 1 2 1 2 ✅ |
| 3 4 3 4  | 3 4 3 4 ✅ |

All 16 outputs match NumPy reference exactly.

---

## Tools

| Tool | Purpose |
|------|---------|
| Icarus Verilog 0.9.7 | RTL Simulation |
| EDA Playground | Browser-based IDE |
| Python 3 + NumPy | Golden Reference Model |

---

## How to Run

**Verilog Simulation:**
1. Open [EDA Playground](https://www.edaplayground.com)
2. Load `src/design.sv` and `tb/testbench.sv`
3. Select Icarus Verilog 0.9.7
4. Click Run

**Python Verification:**
```bash
pip install numpy
python verify/verify.py
```

---

## Concepts Demonstrated

- Systolic array architecture (Google TPU inspired)
- MAC unit design and pipelining
- RTL design with generate blocks
- Valid/ready handshaking protocol
- Data skewing for matrix alignment
- Hardware-software co-verification methodology

---

## Author

**Saugat Deo**  
B.Tech Electronics & Instrumentation Engineering  
NIT Rourkela  
```
