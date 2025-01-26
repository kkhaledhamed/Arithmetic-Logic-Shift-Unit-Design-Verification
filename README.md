# Arithmetic Logic Shift Unit Design & Verification
## Overview
This project focuses on the design, implementation, and verification of an Arithmetic Logic Shift Unit (ALSU), a critical module in digital systems. The ALSU performs various arithmetic, logic, and shift operations. The verification process employs a robust Universal Verification Methodology (UVM) environment for full functional coverage and validation.

## Features
### Supported Operations:
- Arithmetic:
  - Addition
  - Subtraction
- Logical:
  - AND
  - OR
  - XOR
  - NOT
- Shift:
  - Logical Left Shift
  - Logical Right Shift
  - Arithmetic Right Shift
### Additional Features:
Integration of a shift register for extended functionality.
Designed for efficient operation and scalability.
High-performance design with full verification using UVM.

## Design Flow
### Design:
Implemented in Verilog for synthesis and simulation.
Modular approach for easy integration and extension.
Fully compliant with industry-standard practices.

### Synthesis:
Synthesized using Xilinx Vivado.
Post-synthesis and post-implementation analysis completed.
Achieved significant timing and resource efficiency.

### Verification:
UVM Environment: Includes driver, monitor, sequencer, scoreboard, and assertions.
Golden Reference Model: Used for comparing the ALSU output against expected results.
Functional coverage ensures all scenarios are validated.
#### Verification Details
The verification environment was developed using UVM and includes the following components:
- Assertions: Monitors key design properties during runtime.
- Functional Coverage:
- Branch, condition, and toggle coverage were achieved.
- Branch coverage is slightly less than 100% due to an unreachable default case in a case statement (likely a tool bug, as discussed with the supervisor).
- Waveforms: Simulations were thoroughly analyzed using waveform tools.
#### Test Scenarios:
Directed and random tests were used to validate all operations.
Reset and valid sequences were tested.

#### Verification Tools
ModelSim/QuestaSim: For simulation and waveform analysis.
Vivado: For synthesis and implementation.
Synthesis and Implementation
Tools Used: Xilinx Vivado for synthesis, timing, and resource utilization reports.
Post-Synthesis Schematic:
Visualized using Vivado after elaboration.
نسخ
### Key Reports and Observations
#### Code Coverage Metrics:
- Utilization Report:
  - Summary of area usage, timing, and power.
- Timing Report:
  - Achieved timing closure with minimal delays.
- ALSU:
  Branch Coverage: Close to 100%, except for a tool bug.
  Statement Coverage: Fully achieved.
  Toggle Coverage: Verified thoroughly.
- Shift Register:
  Similar high coverage metrics achieved.
  Functional and assertion-based coverage is complete.
- Waveforms:
 - Snapshots are available for valid and invalid cases.
 - Post-reset valid sequences are tested successfully.

### Key Challenges and Solutions
- Challenge: Achieving full branch coverage.
  - Solution: Analysis confirmed this was due to a simulation tool limitation, which was deemed acceptable after supervisor review.
- Challenge: Integrating a shift register into the ALSU without affecting timing.
  - Solution: Incremental design and testing ensured seamless integration.
