# RISC-V Soft CPU

A SystemVerilog implementation of an RV32I soft CPU, built progressively from a single-cycle processor into a 5-stage pipelined processor with control hazard handling, RAW hazard detection, pipeline stalls/flushes, and half-cycle writeback support.

This project was developed to deepen my understanding of computer architecture, digital design, pipelining, datapath/control design, and verification using simulation-driven testing.

---

## Project Highlights

* Implemented an RV32I soft CPU in SystemVerilog.
* Built both a single-cycle CPU and a 5-stage pipelined CPU.
* Designed modular datapath components including the PC, register file, ALU, ALU control, immediate generator, instruction memory, data memory, and pipeline registers.
* Added support for major RV32I instruction groups:

  * R-type arithmetic/logical instructions
  * I-type arithmetic/logical instructions
  * Load instructions
  * Store instructions
  * Branch instructions
  * `jal`
  * `jalr`
  * `lui`
  * `auipc`
  * `ebreak` for simulation halt/debug
* Implemented control hazard handling for branches and jumps resolved in the EX stage.
* Implemented RAW hazard detection with pipeline stalls and bubble insertion.
* Added half-cycle writeback support using a negative-edge register file write, reducing unnecessary stalls for WB-to-ID dependencies.
* Created assembly-level test programs and converted them into instruction-memory hex files using an external assembly-to-hex translator.
* Verified functionality using module-level and CPU-level SystemVerilog testbenches.

---

## Architecture Overview

This repository contains two main CPU designs:

1. **Single-cycle CPU**
   A baseline implementation where each instruction completes in one clock cycle.

2. **5-stage pipelined CPU**
   A more realistic CPU design that overlaps instruction execution across five pipeline stages:

   * IF: Instruction Fetch
   * ID: Instruction Decode / Register Read
   * EX: Execute / ALU / Branch Resolution
   * MEM: Data Memory Access
   * WB: Register Writeback

The pipelined CPU was built after the single-cycle CPU so that the single-cycle implementation could serve as a functional reference.

---

## Single-Cycle CPU

[INSERT SINGLE-CYCLE CPU DATAPATH DIAGRAM HERE]

The single-cycle CPU executes one full instruction per clock cycle. In this design, the instruction fetch, decode, execute, memory, and writeback operations all occur within one long combinational path between clock edges.

### Main Components

* **Program Counter**

  * Holds the current instruction address.
  * Normally increments by 4.
  * Can be redirected for branches and jumps.

* **Instruction Memory**

  * Stores the program loaded from a hex memory file.
  * Uses `$readmemh` during simulation.

* **Control Unit**

  * Decodes the opcode.
  * Generates high-level control signals such as `RegWrite`, `MemRead`, `MemWrite`, `Branch`, `Jump`, `ALUSrc`, and `MemtoReg`.

* **Register File**

  * Contains 32 RV32I registers.
  * Register `x0` is hardwired to zero.
  * Provides two read ports and one write port.

* **Immediate Generator**

  * Extracts and sign-extends immediates for I-type, S-type, B-type, U-type, and J-type instructions.

* **ALU Control**

  * Uses instruction fields and the main ALU operation control signal to select the exact ALU operation.

* **ALU**

  * Performs arithmetic, logical, comparison, and branch comparison operations.

* **Data Memory**

  * Byte-addressable memory used for loads and stores.
  * Supports byte, halfword, and word operations.

* **Writeback Mux**

  * Selects between ALU result, memory read data, or `PC + 4` for jump link instructions.

The single-cycle design is simpler to reason about, but the clock period is limited by the longest possible instruction path.

---

## Pipelined CPU

[INSERT 5-STAGE PIPELINED CPU DIAGRAM HERE]

The pipelined CPU divides instruction execution into five stages. Each stage performs part of the instruction, and pipeline registers hold values between stages. This allows multiple instructions to be active at the same time.

For example, while one instruction is in EX, another can be in ID, another can be in IF, and so on.

---

## Pipeline Stages

### 1. IF — Instruction Fetch

The IF stage fetches the instruction at the current PC.

Responsibilities:

* Read instruction memory.
* Compute `PC + 4`.
* Select the next PC.
* Handle redirects from branches and jumps.
* Detect `ebreak` for simulation halt behavior.

The normal next PC is `PC + 4`. If a branch or jump is taken, the PC is redirected to the target address calculated in the EX stage.

---

### 2. ID — Instruction Decode / Register Read

The ID stage decodes the fetched instruction and reads register operands.

Responsibilities:

* Decode instruction fields.
* Generate control signals.
* Read `rs1` and `rs2` from the register file.
* Generate immediates.
* Pass register addresses and control information to the hazard unit.
* Pass decoded instruction data into the ID/EX pipeline register.

The ID stage also outputs metadata such as:

* `id_rs1_addr`
* `id_rs2_addr`
* `id_uses_rs1`
* `id_uses_rs2`

These signals are important because the hazard unit should only stall on true dependencies. For example, not every instruction actually uses both `rs1` and `rs2`.

---

### 3. EX — Execute / ALU / Branch Resolution

The EX stage performs ALU operations and resolves branches and jumps.

Responsibilities:

* Select ALU operands.
* Execute arithmetic/logical operations.
* Calculate branch and jump targets.
* Evaluate branch conditions.
* Generate redirect signals for taken branches and jumps.

For branch instructions, the EX stage determines whether the branch is taken. If it is taken, the pipeline redirects the PC and flushes younger incorrect instructions.

For jump instructions:

* `jal` uses `PC + immediate` as the redirect target.
* `jalr` uses `rs1 + immediate`, with the least significant bit cleared according to the RV32I specification.

---

### 4. MEM — Data Memory Access

The MEM stage performs load and store operations.

Responsibilities:

* Read from data memory for load instructions.
* Write to data memory for store instructions.
* Pass ALU results forward for non-memory instructions.
* Preserve writeback control signals for the WB stage.

The data memory is byte-addressable and supports different memory operation types such as:

* `lb`
* `lh`
* `lw`
* `sb`
* `sh`
* `sw`

---

### 5. WB — Writeback

The WB stage writes the final result back into the register file.

Possible writeback values include:

* ALU result
* Loaded memory data
* `PC + 4` for `jal` and `jalr`

The writeback stage is also used for debug halt detection. In this design, `ebreak` is detected and carried through the pipeline so the testbench can stop once the instruction reaches the end of the pipeline.

---

## Pipeline Registers

The pipelined CPU uses pipeline registers between each stage:

* `IF/ID`
* `ID/EX`
* `EX/MEM`
* `MEM/WB`

Each pipeline register stores both datapath values and control signals.

For example, the ID/EX register stores:

* Register read values
* Immediate value
* Source/destination register addresses
* ALU control information
* Memory control signals
* Writeback control signals
* Current PC and `PC + 4`

This structure allows each instruction to carry the information it needs as it moves through the pipeline.

---

## Control Hazards

Branches and jumps create control hazards because the CPU may fetch the next sequential instruction before knowing whether the PC should redirect.

In this design, branches and jumps are resolved in the EX stage.

When a redirect is taken:

* The PC is updated to the redirect target.
* The instruction currently in IF/ID is flushed.
* The instruction currently in ID/EX is flushed.

This removes incorrectly fetched instructions from the pipeline.

Simplified behavior:

```systemverilog
if (redirect_taken) begin
    if_id_flush = 1'b1;
    id_ex_flush = 1'b1;
end
```

This is equivalent to a simple predict-not-taken pipeline: the CPU continues fetching sequentially unless EX later determines that a branch or jump should redirect.

---

## RAW Data Hazards

A RAW hazard occurs when an instruction needs to read a register before an older instruction has written the correct value.

Example:

```asm
addi x1, x0, 5
add  x2, x1, x1
```

The `add` instruction depends on the result of the previous `addi`. In a pipeline without forwarding, the value may not be available in the register file yet when the dependent instruction reaches ID.

To handle this, the CPU uses a `hazard_unit`.

---

## Hazard Unit

[INSERT HAZARD UNIT INPUT/OUTPUT DIAGRAM HERE]

The hazard unit detects when the instruction in ID depends on an older instruction that has not written back yet.

### Hazard Unit Inputs

Important inputs include:

* `redirect_taken`

  * Indicates that a branch or jump redirect occurred.

* ID-stage source register information:

  * `id_rs1_addr`
  * `id_rs2_addr`
  * `id_uses_rs1`
  * `id_uses_rs2`

* Destination register and write-enable information from later pipeline stages:

  * `id_ex_rd_addr`
  * `id_ex_RegWrite`
  * `ex_mem_rd_addr`
  * `ex_mem_RegWrite`
  * `mem_wb_rd_addr`
  * `mem_wb_RegWrite`

### Hazard Unit Outputs

The hazard unit controls stalls and flushes:

* `pc_stall`

  * Freezes the PC.

* `if_id_stall`

  * Freezes the IF/ID pipeline register.

* `if_id_flush`

  * Clears the IF/ID pipeline register.

* `id_ex_flush`

  * Clears the ID/EX pipeline register, inserting a bubble.

---

## RAW Hazard Handling Without Forwarding

Without forwarding, the hazard unit checks whether the instruction in ID needs a register that is waiting to be written by an older instruction in the pipeline.

A simplified RAW hazard condition is:

```systemverilog
raw_hazard_rs1 =
    id_uses_rs1 &&
    (id_rs1_addr != 5'd0) &&
    (
        (id_ex_RegWrite  && (id_ex_rd_addr  == id_rs1_addr)) ||
        (ex_mem_RegWrite && (ex_mem_rd_addr == id_rs1_addr)) ||
        (mem_wb_RegWrite && (mem_wb_rd_addr == id_rs1_addr))
    );

raw_hazard_rs2 =
    id_uses_rs2 &&
    (id_rs2_addr != 5'd0) &&
    (
        (id_ex_RegWrite  && (id_ex_rd_addr  == id_rs2_addr)) ||
        (ex_mem_RegWrite && (ex_mem_rd_addr == id_rs2_addr)) ||
        (mem_wb_RegWrite && (mem_wb_rd_addr == id_rs2_addr))
    );

raw_hazard = raw_hazard_rs1 || raw_hazard_rs2;
```

When a RAW hazard is detected:

```systemverilog
pc_stall    = 1'b1;
if_id_stall = 1'b1;
id_ex_flush = 1'b1;
```

This means:

* The PC does not advance.
* The instruction in IF/ID stays in place.
* A bubble is inserted into ID/EX.
* Older instructions continue moving forward until the needed value becomes available.

This prevents the dependent instruction from reading stale register data.

---

## Half-Cycle Writeback Support

The CPU also supports a half-cycle writeback optimization.

Instead of writing the register file on the positive edge of the clock, the register file writes on the negative edge. This allows the WB-stage instruction to update the register file halfway through the cycle, before the ID stage reads registers for the next instruction.

Conceptually:

```text
First half of cycle:
    WB writes result into register file.

Second half of cycle:
    ID reads updated register value.
```

This creates an effective WB-to-ID bypass without adding an explicit forwarding mux in the ID stage.

### How This Affects the Hazard Unit

The half-cycle writeback itself is implemented in the register file, but the hazard unit must be aware of it.

Without half-cycle writeback, the hazard unit must stall when ID depends on an instruction in MEM/WB.

With half-cycle writeback, the MEM/WB instruction writes early enough that ID can safely read the updated value in the same cycle. Therefore, the hazard unit no longer needs to stall on MEM/WB dependencies.

So the hazard unit changes from checking:

```text
ID/EX
EX/MEM
MEM/WB
```

to checking only:

```text
ID/EX
EX/MEM
```

The MEM/WB comparison is removed because that value is available through the register file by the time ID reads it.

This reduces unnecessary stalls and improves pipeline performance while keeping the datapath simpler than a full forwarding network.

---

## Stall and Flush Priority

Control hazards are given priority over data hazards.

If a branch or jump redirect occurs, the incorrect younger instructions must be flushed regardless of any RAW hazard.

Priority order:

1. Control redirect flush
2. RAW hazard stall
3. Normal pipeline advance

Simplified behavior:

```systemverilog
if (redirect_taken) begin
    if_id_flush = 1'b1;
    id_ex_flush = 1'b1;
end else if (raw_hazard) begin
    pc_stall    = 1'b1;
    if_id_stall = 1'b1;
    id_ex_flush = 1'b1;
end
```

This ensures that incorrect-path instructions are removed before considering data-hazard stalls.

---

## External Assembly-to-Hex Translation Flow

The CPU test programs were written in RV32I assembly and then converted into hex instruction memory files using an external assembly-to-hex translator.

The testing flow was:

```text
RV32I assembly program
        |
        v
Assembly-to-hex translator
        |
        v
Hex instruction memory file
        |
        v
$readmemh loads program into instruction memory
        |
        v
SystemVerilog CPU simulation
```

The generated hex file is loaded by the instruction memory during simulation.

Example memory loading flow:

```systemverilog
initial begin
    $readmemh(PROGRAM_FILE, memory_array);
end
```

This made testing much easier because I could write readable assembly programs instead of manually encoding every instruction by hand.

The translator/compiler flow was especially useful for testing:

* Arithmetic instructions
* Load/store instructions
* Branch offsets
* Jump targets
* RAW hazards
* Control hazards
* `ebreak` termination

---

## Testing Strategy

Testing was a major part of this project. The CPU was verified incrementally instead of only testing the final full system.

### 1. Module-Level Testing

Individual modules were tested first to isolate bugs early.

Examples of tested modules:

* ALU
* ALU control
* Register file
* Immediate generator
* Instruction memory
* Data memory
* IF stage
* ID stage
* EX stage
* MEM stage
* WB stage

This helped verify that each component behaved correctly before integrating it into the full CPU.

---

### 2. Single-Cycle CPU Testing

The single-cycle CPU was tested with assembly programs covering different RV32I instruction types.

Test categories included:

* R-type arithmetic and logic
* I-type arithmetic and logic
* Load/store behavior
* Branch taken and branch not taken behavior
* `jal`
* `jalr`
* `lui`
* `auipc`
* `ebreak`

The single-cycle CPU served as a useful baseline because each instruction completed before the next one started. That made it easier to debug instruction semantics before introducing pipeline hazards.

---

### 3. Pipelined CPU Testing Without Hazards

After building the pipeline skeleton, I first tested programs with no RAW hazards and no taken branches.

This verified that:

* Instructions moved correctly through IF, ID, EX, MEM, and WB.
* Pipeline registers preserved the correct values.
* Control signals flowed through the pipeline correctly.
* Register writes occurred in the correct stage.
* The CPU halted correctly on `ebreak`.

This step was important because pipeline bugs can be difficult to debug if hazards are introduced too early.

---

### 4. Control Hazard Testing

Next, I tested branches and jumps.

The goal was to verify that:

* Branch targets were calculated correctly.
* Taken branches redirected the PC.
* Not-taken branches continued normally.
* `jal` redirected correctly.
* `jalr` redirected correctly and cleared the least significant bit of the target.
* Incorrect-path instructions were flushed.
* Valid instructions after the redirect still completed.

Control hazard tests were intentionally kept small so that the expected pipeline behavior was easy to trace cycle by cycle.

---

### 5. RAW Hazard Testing

After control hazards worked, I tested RAW hazards.

Example hazard pattern:

```asm
addi x1, x0, 5
add  x2, x1, x1
```

The testbench checked that the CPU inserted stalls instead of allowing the dependent instruction to use stale data.

RAW hazard tests included:

* ALU-to-ALU dependencies
* Load/use-style dependencies
* Hazards involving `rs1`
* Hazards involving `rs2`
* Hazards combined with jumps or branches
* Cases where `x0` should not cause a stall

---

### 6. Half-Cycle Writeback Testing

After implementing negative-edge register file writeback, I updated the hazard logic so that MEM/WB dependencies no longer caused stalls.

The goal was to verify that a value written in WB could be read by the ID stage in the same cycle.

This tested the effective WB-to-ID bypass behavior.

The important expected result was:

* Dependencies on ID/EX still stall.
* Dependencies on EX/MEM still stall.
* Dependencies on MEM/WB no longer stall.
* The dependent instruction still reads the correct value.

---

### 7. End-to-End CPU Testbench

The CPU-level testbench loads a program, runs the processor, and stops when the CPU reaches `ebreak`.

The testbench includes:

* Clock generation
* Reset sequencing
* Program execution loop
* Maximum cycle timeout
* Optional trace/debug printing
* Memory checking tasks
* Debug halt detection

The testbench uses memory checks to validate final program results.

Example concept:

```systemverilog
run_program(100, 1'b1);
check_mem(32'd64, 32'h0000000D);
```

The `check_mem` task uses byte addresses, matching the CPU’s byte-addressable memory system.

---

## Debugging Support

The CPU exposes several debug signals to make simulation easier.

Examples include:

* Current PC
* Current instruction
* ALU result
* Immediate value
* Writeback value
* Destination register
* Halt signal

These signals made it easier to inspect pipeline behavior in the waveform viewer and identify where an incorrect value first appeared.

---

## Design Decisions

### Branches Resolved in EX

Branches are resolved in the EX stage because the ALU is already available there for comparisons and target calculations.

This keeps the ID stage simpler, but it means taken branches require flushing younger instructions.

---

### Byte-Addressable Data Memory

The data memory is byte-addressable rather than word-indexed.

This better matches RV32I behavior and allows support for byte, halfword, and word loads/stores.

---

### `ebreak` for Simulation Halt

The CPU uses `ebreak` as a clean way to terminate test programs in simulation.

Instead of relying on a fixed cycle count only, test programs end with `ebreak`, and the testbench waits for the halt signal.

---

### Half-Cycle Writeback Before Full Forwarding

Before implementing a complete forwarding network, I added half-cycle writeback as a simpler optimization.

This reduces stalls for WB-to-ID dependencies without adding new forwarding muxes to the datapath.

A full forwarding implementation can still be added later for paths such as:

* EX/MEM to EX
* MEM/WB to EX
* Load-use hazard handling

---

## Skills Demonstrated

This project demonstrates experience with:

* Computer architecture
* CPU datapath design
* Control unit design
* RV32I instruction encoding and execution
* Pipelined processor design
* Hazard detection
* Pipeline stalls and flushes
* Register file timing
* SystemVerilog RTL design
* Testbench development
* Simulation-based verification
* Debugging with waveforms
* Assembly-level testing
* Hex memory initialization using `$readmemh`
* Modular hardware design

---

## Future Improvements

Potential future extensions include:

* Full forwarding network
* EX/MEM-to-EX forwarding
* MEM/WB-to-EX forwarding
* Load-use hazard forwarding/stall refinement
* Branch prediction
* Instruction/data cache
* CSR support
* More complete RV32I compliance testing
* FPGA synthesis and timing comparison
* Performance comparison between:

  * no forwarding
  * half-cycle writeback
  * full forwarding

---

## Summary

This project started as a single-cycle RV32I CPU and evolved into a 5-stage pipelined soft CPU with realistic pipeline control logic. The most important learning outcomes were understanding how instructions move through a pipeline, how control and data hazards affect correctness, and how hardware timing decisions such as half-cycle writeback can reduce stalls.

The project combines RTL design, computer architecture, assembly-level testing, and simulation-based verification into a complete soft CPU implementation.
