# ⚡ MINI PROCESSOR
### 16-bit Single-Cycle CPU — Verilog RTL

**Digital IC Design Camp — Final Project**

A compact custom **16-bit Single-Cycle CPU** designed and verified in Verilog, featuring a custom ISA, dedicated datapath/control logic, an 8-bit ALU, conditional branching, jumps, and system instructions.

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Architecture](https://img.shields.io/badge/Architecture-Single--Cycle-2ea44f)
![ALU](https://img.shields.io/badge/ALU-8--bit-orange)
![ISA](https://img.shields.io/badge/ISA-Custom-purple)
![Simulation](https://img.shields.io/badge/Simulation-ModelSim-red)

---

## 📌 Overview

The Mini Processor is a custom **16-bit Single-Cycle CPU** implemented in Verilog RTL.

The processor integrates five core hardware blocks:
- Program Counter
- Instruction Memory
- Register File
- ALU
- Control Unit

The design implements a custom instruction set supporting arithmetic, logical, immediate, branch, jump, and system instructions. It was functionally verified using multiple instruction-memory programs and ModelSim waveform analysis.

---

## 🧠 Architecture

```text
                         ┌─────────────────────┐
                         │  Instruction Memory │
                         │      64 × 16        │
                         └──────────┬──────────┘
                                    │
                              16-bit Instruction
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    Control Unit     │
                         └───────┬───────┬─────┘
                                 │       │
                                 │       │ ALU Opcode
                                 ▼       ▼
                         ┌─────────────────────┐
                         │    Register File    │
                         │       4 × 8         │
                         └──────┬──────┬──────┘
                                │      │
                                ▼      ▼
                              ┌───────────┐
                              │    ALU    │
                              │   8-bit   │
                              └─────┬─────┘
                                    │
                               ALU Result
                                    │
                                    ▼
                               Write-back
```

### Core Specifications

| Feature | Specification |
|---|---|
| Architecture | Single-Cycle CPU |
| Instruction Width | 16 bits |
| Program Counter | 6 bits |
| Instruction Memory | 64 × 16 bits |
| Register File | 4 × 8-bit registers |
| Register Read Ports | 2 combinational |
| Register Write Port | 1 synchronous |
| ALU Width | 8 bits |
| ALU Operations | 16 |
| ISA Classes | R-Type, I-Type, Branch/Jump, System |
| HDL | Verilog |
| Simulation | ModelSim |

---

# 📜 Custom Instruction Set Architecture

The two most significant bits `[15:14]` select the instruction class.

| `[15:14]` | Instruction Class | Purpose |
|---|---|---|
| `00` | R-Type | ALU operations |
| `01` | I-Type | Immediate operation |
| `10` | Branch / Jump | Program control |
| `11` | System | HALT / NOP |

## 🔹 R-Type

```text
[15:14] [13:10] [9:8] [7:6] [5:4] [3:0]
   00   ALU_OP   rd    rs1   rs2  Reserved
```

Example:

```text
ADD R2, R0, R1
```

## 🔹 I-Type

```text
[15:14] [13:12]   [11:4]    [3:0]
   01     rd    Immediate  Reserved
```

Implemented I-Type instruction:

```text
LOADI R0, 5
```

---

# ⚙️ ALU

The processor contains an **8-bit ALU** controlled by a **4-bit opcode**, providing 16 operations.

| Opcode | Operation | Opcode | Operation |
|---|---|---|---|
| `0000` | Addition | `1001` | NOT B |
| `0001` | Subtraction | `1010` | AND |
| `0010` | Division | `1011` | NAND |
| `0011` | Multiplication | `1100` | NOR |
| `0100` | Shift | `1101` | OR |
| `0101` | Rotation | `1110` | XOR |
| `0110` | 1's Complement A | `1111` | XNOR |
| `0111` | Increment A | — | — |

The ALU also produces a zero flag:

```text
zero = 1  → result == 0
zero = 0  → result != 0
```

The zero flag is used by BEQ and BNE.

---

# 🔀 Branch & Jump

## JMP

When:

```text
instr[15:14] = 10
instr[13]    = 0
```

the instruction performs an unconditional jump using `instr[5:0]` as the target address.

## BEQ — Branch if Equal

When:

```text
instr[15:14] = 10
instr[13]    = 1
instr[8]     = 0
```

```text
rs1    = instr[12:11]
rs2    = instr[10:9]
target = instr[5:0]
```

The ALU compares the registers through subtraction:

```text
rs1 - rs2
```

```text
zero = 1 → BEQ taken
zero = 0 → BEQ not taken
```

---

# 🚀 BNE Extension

A **BNE (Branch if Not Equal)** instruction was added as an extension to the branch mechanism.

### Encoding

```text
instr[15:14] = 10
instr[13]    = 1
instr[8]     = 1
```

The same register and target fields are used:

```text
rs1    = instr[12:11]
rs2    = instr[10:9]
target = instr[5:0]
```

The ALU performs:

```text
rs1 - rs2
```

```text
zero = 1 → Registers equal     → BNE not taken
zero = 0 → Registers different → BNE taken
```

BEQ and BNE therefore reuse the existing ALU subtraction and zero-detection logic.

---

# 🛑 System Instructions

The `11` instruction class is used for system operations.

### HALT
Freezes the Program Counter:

```text
PC → HOLD
```

### NOP
Performs no register write and allows normal PC progression.

---

# 🧩 RTL Modules

| Module | Responsibility |
|---|---|
| `program_counter.v` | Maintains the current instruction address |
| `instruction_memory.v` | Stores and provides 16-bit instructions |
| `register_file.v` | Provides register operands and write-back |
| `ALU.v` | Performs arithmetic and logical operations |
| `control_unit.v` | Decodes instructions and generates control signals |
| `mini_processor.v` | Integrates the complete CPU datapath |
| `mini_processor_tb.v` | Simulation and functional verification |

---

# 🧪 Verification

The processor was verified through dedicated Verilog test programs and **ModelSim simulation**.

### Verification Coverage

- Instruction fetch and execution
- Immediate loading
- Arithmetic operations
- Logical operations
- BEQ not taken
- BEQ taken
- BNE not taken
- BNE taken
- JMP
- HALT / PC hold behavior
- Register write-back
- ALU zero flag behavior

## Main Program — `program_mem.txt`

```text
LOADI R0, 5
LOADI R1, 3
ADD R2, R0, R1
SUB R3, R0, R1
BEQ R2, R3, 6
XOR R3, R0, R1
JMP 7
HALT
```

## BEQ Taken — `program_beq_taken.txt`

The test initializes:

```text
R2 = 6
R3 = 6
```

and executes:

```text
BEQ R2, R3, 6
```

Since `R2 - R3 = 0`, the zero flag becomes active and the branch is taken.

## BNE — `program_bne.txt`

The BNE program verifies both outcomes:

```text
R2 = R3  → BNE not taken
R1 ≠ R2  → BNE taken
```

---

# 📊 Simulation

The design was simulated using **ModelSim**.

Waveform analysis was used to verify:
- Program Counter transitions
- Instruction execution
- Register values
- ALU results
- Zero flag behavior
- Control signals
- Branch decisions
- Jump behavior
- HALT / PC hold

---

# 📁 Repository Structure

```text
Mini-Processor/
│
├── RTL/
│   ├── program_counter.v
│   ├── instruction_memory.v
│   ├── register_file.v
│   ├── ALU.v
│   ├── control_unit.v
│   └── mini_processor.v
│
├── Testbench/
│   └── mini_processor_tb.v
│
├── Programs/
│   ├── program_mem.txt
│   ├── program_beq_taken.txt
│   └── program_bne.txt
│
├── Simulation/
│   └── ModelSim waveforms
│
├── Documentation/
│   └── Project Documentation.pdf
│
└── README.md
```

---

# 🛠️ Tools & Technologies

**Verilog HDL** • **RTL Design** • **Digital Logic** • **Digital IC Design** • **ModelSim**

---

# 🔮 Future Improvements

Possible future extensions include:
- Additional instructions
- Larger Register File
- Expanded memory system
- Additional processor features
- Pipelined architecture

---

# ⭐ Project Highlights

```text
✓ 16-bit Custom ISA
✓ Single-Cycle CPU Architecture
✓ 64 × 16-bit Instruction Memory
✓ 4 × 8-bit Register File
✓ 8-bit ALU with 16 Operations
✓ BEQ & BNE Conditional Branching
✓ JMP / HALT / NOP Support
✓ Verilog RTL Implementation
✓ ModelSim Functional Verification
✓ Dedicated Verification Programs
```

---

<div align="center">

### ⚡ Mini Processor
**Single-Cycle CPU • Verilog RTL • Digital IC Design**

*Designed and verified as a Digital IC Design Camp final project.*

</div>
