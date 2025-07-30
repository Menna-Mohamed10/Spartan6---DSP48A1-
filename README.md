# 🧮 DSP48A1 Slice Simulation & Verification  

A complete Verilog design and verification project simulating the behavior of a **Spartan-6 DSP48A1 slice**, based on Xilinx architecture.

---

## 📌 Project Overview  

This project implements a configurable **DSP48A1 slice** in Verilog, featuring:
- Parameterized DSP design following Xilinx DSP48A1 behavior.
- Testbench verifying four functional paths via `OPMODE`.
- Simulation using **QuestaSim** + full FPGA flow via **Vivado**.
- Clean elaboration, synthesis, implementation, and linting results.

---

## 📁 Files Included

| File                    | Description                                |
|-------------------------|--------------------------------------------|
| `DSP58A1.v`             | Main DSP slice module                      |
| `REG_MUX.v`             | Register + Multiplexer helper module       |
| `tb_DSP58A1.v`          | Testbench verifying 4 data paths           |
| `DSP58A1.do`            | Simulation automation script for QuestaSim |
| `Contraints_basys.xdc`  | Constraints file (clock = 100 MHz @ W5)    |

📂 `docs/` folder includes all screenshots (schematics, waveforms, timing, and utilization reports).

---

## 🧪 Testbench Functional Paths

Each DSP path is tested with controlled `OPMODE` values and delayed output checking based on pipeline register stages:

1. **Path 1**: Pre-subtractor + Multiplier + C input  
   ![Path 1](docs/questa_waveform_path1.png)

2. **Path 2**: Pre-adder + zero propagation  
   ![Path 2](docs/questa_waveform_path2.png)

3. **Path 3**: Feedback-based accumulator  
   ![Path 3](docs/questa_waveform_path3.png)

4. **Path 4**: D:A:B concatenation + PCIN  
   ![Path 4](docs/questa_waveform_path4.png)

Each test path includes self-checking verification.

---

## 🧰 Tools Used

- 🛠 **Vivado** for elaboration, synthesis, implementation  
- 🔍 **QuestaSim** for testbench simulation  
- ✔️ **Linting** for clean HDL validation

---

## 💡 FPGA Targeting Info

- **Part**: `xc7a200tffg1156-3` (larger IO support)
- **Clock**: 100 MHz (`W5` pin in `Contraints_basys.xdc`)
- ✅ No critical warnings or errors in flow steps

---

## 📊 Flow Outputs

| Phase                   | Snapshot |
|-------------------------|----------|
| Elaboration             | ![Elaboration](docs/elaboration_schematic.png) |
| Synthesis (Utilization) | ![Synthesis Util](docs/synthesis_utilization.png) |
| Synthesis (Timing)      | ![Synthesis Timing](docs/synthesis_timing.png) |
| Implementation (Util.)  | ![Impl Util](docs/implementation_utilization.png) |
| Implementation (Timing) | ![Impl Timing](docs/implementation_timing.png) |
| Device View             | ![Device View](docs/device_view.png) |

---

## 🔍 Clean Linting & Logs

- ✅ No design rule violations or syntax issues
- ✅ Linting Passed 

---

## 📚 References

- 📄 [Xilinx UG389 - Spartan-6 DSP48A1 Slice](https://www.xilinx.com/support/documentation/user_guides/ug389.pdf)  

---

