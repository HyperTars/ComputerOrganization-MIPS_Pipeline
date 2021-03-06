# ComputerOrganization-MIPS

- This is a Computer Organization and Design course project using Quartus II to design parts of an MIPS CPU from single-line to 5-level pipeline
  - Single-Line MIPS CPU
  - MultiCycle MIPS CPU
  - 5-Level Pipeline MIPS CPU

- Overview of 5-level pipeline MIPS CPU
![pipeline_MIPS](Pipeline_MIPS.png)

- 5-level Pipeline MIPS CPU includes
  - Step1: Fetch Instructions
    - Reg1: IF / ID - Store
  - Step2: Decode Instructions
    - Reg2: IF / ID - Read
    - Reg2: ID / EXE - Store
  - Step3: Execution
    - Reg2: ID / EXE - Read
    - Reg3: EXE / MEM
  - Step4: Memory Access
    - Reg3: EXE / MEM
    - Reg4: MEM / WB
  - Step5: Write Back
    - Reg4: MEM / WB

- Components
  - MUX: select instructions
  - Add: PC + 4 and write back to PC, prepare for next clock
  - REG: instruction register, fetch address according to address sent from PC

- Hazard resolved
  - Structural Hazard
  - Data Hazard
  - Control Hazard
  
  See full [Design Thoughts 流水线设计思路](流水线设计思路.pdf)
  
