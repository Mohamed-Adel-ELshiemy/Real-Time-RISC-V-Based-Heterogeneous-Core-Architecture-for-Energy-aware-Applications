# Real-Time-RISC-V-Based-Heterogeneous-Core-Architecture-for-Energy-aware-Applications
This work presents a smart architecture that addresses this issue by dynamically changing the configuration of the processing unit according to the realtime change in battery levels. To cope with these dynamics, three different RISC-V processing cores are used to provision them with three different configurations.

Nile University
NISC Center
Digital IC Design (FPGA & ASIC) Research Assistant

Presented by:

Mohamed Adel Elshiemy

Subject: Glucose monitoring Project Using

" Zero-Riscy Processor Based on RISC-V" 

Under supervision of: Dr: Ahmed Soltan

################################################################################################################################
This work you can find it in my publication pdf wich is uploaded here or throught the following DIO on IEEE explore website:  M. A. Elshiemy and A. Soltan, "Comprehensive Compliance Framework for RISC-V Architectures using the RISCOF Test Platform," 2025 IEEE International Symposium on Circuits and Systems (ISCAS), London, United Kingdom, 2025, pp. 1-5, doi: https://doi.org/10.1109/ISCAS56072.2025.11043314.
################################################################################################################################

######### Zero-Riscy RISC-V-Based Processor ############

● ZERO-RISCY is a 2-stage in-order 32b RISC-V processor core. ZERO-RISCY has been designed to be small and efficient. Via two parameters, the core is configurable to support four ISA configurations.
● Zero-Riscy targets mixed arithmetic/control applications and control-oriented tasks.
● Zero-Riscy is optimized to have a small area and power, but higher computation performance than Micro-Riscy. They consist of one single RTL description with parameters to tune the area resources. Furthermore, to target high energy efficiency and ultra-low power in battery-powered Internet-of-things (IoT) devices, the cores are evaluated in Near-Threshold (NT), where the transistors achieve their maximum energy efficiency.
● We analyze their energy consumption in an always-on context, where the cores are waiting for an event to start the computation and finally go back to sleep. We show that when the interval time between events is long enough, the leakage power contribution becomes crucial.
● Zero-Riscy is an area-optimized RISC-V core implementing the RVC32IM instruction set architecture; Figure-1 shows a simplified version of its micro-architecture. It has two pipeline stages that are the IF and Instruction Decode and Execute (IDE) stage. 
The prefetch-buffer generates the instruction address and the program counter value (which can be different due to misalignment given by compressed instructions), and it contains a FIFO to store instructions also when the next stage is not ready to process them.
 
● Zero-Riscy supports the following instructions: 
   • Full support for RV32I Base Integer Instruction Set 
   • Full support for RV32E Base Integer Instruction Set 
   • Full support for RV32C Standard Extension for Compressed Instructions 
   • Full support for RV32M Integer Multiplication and Division Instr_set Extension 

The RV32M and RV32E can be enable and disable using two parameters.
Load and store instructions are executed in two cycles: the first cycle is used to calculate the address and the second cycle to receive the data from memory. The multiplier unit contains one Multiply And Accumulate (MAC) unit, which is able to sequentially multiply two 16 bit operands and accumulate the result in a 32 bit register. Divisions are implemented with minimum resources with the unsigned serial division algorithm using the adder in the ALU in all the steps. No forward-path and data-dependency logic are present in the core, which allows to save control-logic, multiplexers, and comparators. Zero-riscy implements a minimum set of control-status registers defined by the privileged RISC-V 1.9 spec, debug, and up to 32 interrupt requests.

In Zero-Riscy, the core area is dominated by the register-file (35%), as the multiplier unit implements only the RVM specifications in a multi-cycle fashion.

● Micro-Riscy:
Micro-Riscy is further optimized for area with respect to Zero-Riscy by removing the RVM RISC-V extensions. Micro-Riscy does not have any Hardware (HW) support for multiplications and divisions. To further reduce the area footprint, it implements the RVE RISC-V specification, which allows to use only 16 general-purpose registers. This core is suitable for control-oriented code like Finite State Machines (FSMs), runtime functions, schedulers, etc.

Simplified block diagram of Zero-riscy. The critical path is along the branch-address from the IF-IDE pipeline stage to the ALU, all the way along to the branch-target in the prefetch-buffer and finally to the instruction memory.

The main contribution to the total power consumption is provided by the prefetch-buffer, which interacts with the instruction memory every cycle, produces the instruction fetch address, and the program counter value and stores the instructions in a FIFO. In the Riscy core, it also handles hardware-loop instruction requests. As the controller and compressed decoder. So, This explains why we put the pipeline stage between the fetch stage and decode, execute and write back in another stage.

● The multiplier unit contains one Multiply And Accumulate (MAC) unit, which is able to sequentially multiply two 16 bit operands and accumulate the result in a 32 bit register.
 
● Zero-Riscy has an interrupt controller that can control 32 intrupts at a time.
<img width="975" height="337" alt="image" src="https://github.com/user-attachments/assets/a0f5197d-1e50-4643-a6a3-69e57ae0e298" />

● Zero-Riscy ALU Block diagram:
The ALU contains the minimal hardware resources to implement the RVC32IM ISA: one 32-bit adder, one 32-bit shifter, and the logic unit.
Here is a simplified block diagram of the Zero-riscy ALU. The adder is shared between additions/subtractions, branches, address generation for load/store operations and divisions.
<img width="975" height="771" alt="image" src="https://github.com/user-attachments/assets/fd29e3d7-d824-4db3-aeb9-102e4aa54cd5" />

We know that the adder is the main block which used for arithmetic and logical unit. So, We used an approximate adder with four accuracy levels for minimizing the total dynamic power consumption as much as possible.

● Proposed ACA-CSU Adder
Accuracy-Configurable Approximate Adder with Carry Select Unit (ACA-CSU)

The proposed ACA-CSU adder is designed to provide configurable accuracy levels during runtime, allowing it to adaptively operate in both approximate and accurate modes. The adder is
divided into L blocks of equal size, where each block has M bits. 

Each block consists of two parts: Sum Generators and Carry Predictors.

Sum Generators: The jth Sum Generator takes Propagate (Pj·M+M−1:j·M), Generate (Gj·M+M−1:j·M), and Carry (Cinj) as inputs, and generates Sum (Sj·M+M−1:j·M) and Carry (Coutj) as outputs.

The Generate and Propagate signals are calculated as:

p_i=A_i⊕B_i   ,G_i=A_i∙B_i         → (1)

Based on these inputs, the sum generators calculate the sum using parallel prefix logic.

Carry Predictors: The Carry Predictor (CarryPredict) takes K bits of propagate (Pi’s) and generate (Gi’s) as input and predicts a carry (CPredictj ) using parallel prefix logic. The jth CarryPredict takes 

Pj·M−1:j·M−K and Gj·M−1:j·M−K as input and gives CPredictj as output. 

For example, if K =M = 4, CPredictj is calculated using the following equation:

〖CPredict〗_j=G_3+G_2 P_3+G_1 P_3 P_2+G_0 P_3 P_2 P_1        → (2)

Carry Select Unit (CSU): Based on the Control signal, either CPredictj or Coutj−1 is selected as the carry input to the j th block. The accuracy of the adder is decided by the Control signal, and the adder has L accuracy levels.  

The proposed design is generic and can have different accuracy levels defined by the value of L. The maximum carry chain of an m-bit parallel prefix adder is M. In the ACA-CSU design, the Sum Generator block takes the input carry from the CarryPredict block in approximate mode. The CarryPredict creates a carry chain of K preceding bits, thus increasing the accuracy of the sum block to a K + M carry chain.

To further enhance accuracy, the ACA-CSU considers Gj·M−K−1 when calculating CPredictj . Another signal, block propagate (BPj ), is defined for the j th CarryPredict block, which is calculated as:

〖BP〗_j=∏_(j*M-1)^(i=j*M-K)▒P_i       → (3)

If BPj = 1, it means a carry is not generated by this CarryPredict block, and passing Gj·M−K−1 as carry will increase the accuracy. This increases the maximum carry chain from K + M to K + M + 1.

The CSU takes Controlj , CPredictj , Coutj−1 , Gj·M−K−1, and BPj as input and generates the carry input for the j th block. By using the semantic meaning of the input signals, the CSU can be designed optimally. The overall logic of the CSU can be written as:

〖Cin〗_j=〖CarryPredict〗_j∙〖BP〗_j^'+〖Control〗_j^'∙〖BP〗_j∙G_(j*M-K-1)
+〖Control〗_j∙〖BP〗_j∙〖Cout〗_(j-1)    → (4)

The proposed ACA-CSU adder provides configurable accuracy levels, allowing it to adapt to the requirements of different applications. It can achieve significant throughput improvement and power reduction compared to conventional adder designs while maintaining the desired accuracy level. 
<img width="1350" height="391" alt="image" src="https://github.com/user-attachments/assets/9cfdee5e-5d40-4f08-80a9-71d3e5b3b1a5" />

Table. 1. Performance Matrices
<img width="1153" height="244" alt="image" src="https://github.com/user-attachments/assets/a5acf6ea-dedf-4636-b0a3-d46894f31076" />

The clock period can reach to 10ns related to the targeted FPGA type. 
●Zero-Riscy Decoder:
Instruction	Opcode
instr_rdata_i[6:0]	input conditions	outputs	control signals
JAL	7'b1101111	jump_mux_i == 1	alu_op_a_mux_sel_o = 3'b001 //OP_A_CURRPC
alu_op_b_mux_sel_o = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b1100 //IMMB_UJ
alu_operator_o            = 6'b011000 //ALU_ADD
regfile_we                   = 1'b0
	raw_stall_o = (raw_ra_i & (alu_op_a_mux_sel_o==OP_A_REGA_OR_FWD)
OR

                        raw_rb_i & (alu_op_b_mux_sel_o==OP_B_REGB_OR_FWD)
OR

raw_rb_i & (data_we_o&data_req) );

deassert_we = deassert_we_i 
              OR
                                raw_stall_o;

  // deassert we signals (in case of stalls)

regfile_we_o = (deassert_we) ?
                          1'b0 : regfile_we;

mult_int_en_o = RV32M ?
                       ((deassert_we) ? 1'b0 :
                            mult_int_en) : 1'b0;

div_int_en_o = RV32M ? 
                       ((deassert_we) ? 1'b0 : 
                            div_int_en ) : 1'b0;

mmult_en_o = (deassert_we) ?
                          1'b0 : mmult_en;

data_req_o = (deassert_we) ? 
                        1'b0 : data_req;

csr_op_o  = (deassert_we) ?
                      CSR_OP_NONE   :
                       csr_op;

jump_in_id_o  = (deassert_we) ?
                             1'b0: jump_in_id;

branch_in_id_o = (deassert_we) ? 
                            1'b0 : branch_in_id;

JAL	7'b1101111	jump_mux_i == 0	alu_op_a_mux_sel_o = 3'b001 //OP_A_CURRPC
alu_op_b_mux_sel_o = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b0011 //IMMB_PCINCR
alu_operator_o            = 6'b011000 //ALU_ADD
regfile_we                   = 1'b1	
JALR	7'b1100111	jump_mux_i == 1	alu_op_a_mux_sel_o = 3'b000 //OP_A_REGA_OR_FWD
alu_op_b_mux_sel_o = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b0000 //IMMB_I
alu_operator_o            = 6'b011000 //ALU_ADD
regfile_we                   = 1'b0
	
JALR	7'b1100111	jump_mux_i == 0
instr_rdata_i[14:12] != 3'b0
	alu_op_a_mux_sel_o = 3'b001 //OP_A_CURRPC
alu_op_b_mux_sel_o = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b0011 //IMMB_PCINCR
alu_operator_o            = 6'b011000 //ALU_ADD
regfile_we                   = 1'b1
illegal_insn_o   = 1'b1	
BRANCH	7'b1100011	branch_mux_i == 1
instr_rdata_i[14:12] ==	3'b000: alu_operator_o = 6'b001100 //ALU_EQ
3'b001: alu_operator_o = 6'b001101 //ALU_NE
3'b100: alu_operator_o = 6'b000000 //ALU_LTS
3'b101: alu_operator_o = 6'b001010 //ALU_GES
3'b110: alu_operator_o = 6'b000001 //ALU_LTU
3'b111: alu_operator_o = 6'b001011 //ALU_GEU	
STORE	7'b0100011	instr_rdata_i[14] == 1'b0

instr_rdata_i[13:12] =	data_req       = 1'b1
data_we_o      = 1'b1
alu_operator_o = 6'b011000 //ALU_ADD
imm_b_mux_sel_o = 4'b0001 //IMMB_S
alu_op_b_mux_sel_o  = 3'b010 //OP_B_IMM
2'b00: data_type_o = 2'b10 // SB
2'b01: data_type_o = 2'b01 // SH
2'b10: data_type_o = 2'b00 // SW	
LOAD	7'b0000011	instr_rdata_i[13:12] =

instr_rdata_i[14:12] == 3'b111
instr_rdata_i[31:25] =	data_req        = 1'b1
regfile_we      = 1'b1
data_type_o     = 2'b00
alu_operator_o      = 6'b011000 //ALU_ADD
alu_op_b_mux_sel_o  = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b0000 //IMMB_I
data_sign_extension_o = ~instr_rdata_i[14]
2'b00:   data_type_o = 2'b10; // LB
2'b01:   data_type_o = 2'b01; // LH
2'b10:   data_type_o = 2'b00; // LW
default: data_type_o = 2'b00;// illegal or reg-reg
alu_op_b_mux_sel_o = 3'b000 //OP_B_REGB_OR_FWD
data_sign_extension_o = ~instr_rdata_i[30]
7'b0000_000,
7'b0100_000: data_type_o = 2'b10; // LB, LBU
7'b0001_000,
7'b0101_000: data_type_o = 2'b01; // LH, LHU
7'b0010_000: data_type_o = 2'b00; // LW
default: illegal_insn_o = 1'b1
	
LUI	7'b0110111		alu_op_a_mux_sel_o  = 3'b010 //OP_A_IMM
alu_op_b_mux_sel_o  = 3'b010 //OP_B_IMM
imm_a_mux_sel_o     = 1'b1 //IMMA_ZERO
imm_b_mux_sel_o     = 4'b0010 //IMMB_U
alu_operator_o      = 6'b011000 //ALU_ADD
regfile_we          = 1'b1	
AUIPC	7'b0010111		alu_op_a_mux_sel_o  = 3'b001 //OP_A_CURRPC
alu_op_b_mux_sel_o  = 3'b010 //OP_B_IMM
imm_b_mux_sel_o     = 4'b0010 //IMMB_U
alu_operator_o      = 6'b011000 //ALU_ADD
regfile_we          = 1'b1;	
OPIMM	7'b0010011	instr_rdata_i[14:12] =	alu_op_b_mux_sel_o  = 3'b010
imm_b_mux_sel_o     = 4'b0000
regfile_we          = 1'b1
3'b000: alu_operator_o = ALU_ADD  
3'b010: alu_operator_o = ALU_SLTS
3'b011: alu_operator_o = ALU_SLTU;
3'b100: alu_operator_o = ALU_XOR;
3'b110: alu_operator_o = ALU_OR;
3'b111: alu_operator_o = ALU_AND;
3'b001: alu_operator_o = ALU_SLL; 
3'b101: if (instr_rdata_i[31:25] == 7'b0)
                alu_operator_o = ALU_SRL  
             else if (instr_rdata_i[31:25] == 7'b010_0000)
                  alu_operator_o = ALU_SRA  	
OP	7'b0110011	if (instr_rdata_i[31] == 1'b1)
else
if (~instr_rdata_i[28])
{instr_rdata_i[30:25], instr_rdata_i[14:12]} == 	regfile_we     = 1'b1
illegal_insn_o = 1'b1
// RV32I ALU operations
{6'b00_0000, 3'b000}: alu_operator_o = ALU_ADD
{6'b10_0000, 3'b000}: alu_operator_o ALU_SUB 
{6'b00_0000, 3'b010}: alu_operator_o = ALU_SLTS 
{6'b00_0000, 3'b011}: alu_operator_o = ALU_SLTU 
{6'b00_0000, 3'b100}: alu_operator_o = ALU_XOR 
{6'b00_0000, 3'b110}: alu_operator_o = ALU_OR 
{6'b00_0000, 3'b111}: alu_operator_o = ALU_AND  
{6'b00_0000, 3'b001}: alu_operator_o = ALU_SLL
{6'b00_0000, 3'b101}: alu_operator_o = ALU_SRL 
{6'b10_0000, 3'b101}: alu_operator_o = ALU_SRA
// supported RV32M instructions
            {6'b00_0001, 3'b000}: // mul
                alu_operator_o        = ALU_ADD;
                multdiv_operator_o    = MD_OP_MULL;
                mult_int_en           = 1'b1;
                multdiv_signed_mode_o = 2'b00;
                illegal_insn_o        = RV32M ? 1'b0 : 1'b1;
            {6'b00_0001, 3'b001}: // mulh
                alu_operator_o        = ALU_ADD;
                multdiv_operator_o    = MD_OP_MULH;
                mult_int_en           = 1'b1;
                multdiv_signed_mode_o = 2'b11;
                illegal_insn_o        = RV32M ? 1'b0 : 1'b1;
            {6'b00_0001, 3'b010}:  // mulhsu
                alu_operator_o        = ALU_ADD;
                multdiv_operator_o    = MD_OP_MULH;
                mult_int_en           = 1'b1;
                multdiv_signed_mode_o = 2'b01;
                illegal_insn_o        = RV32M ? 1'b0 : 1'b1; 
            {6'b00_0001, 3'b011}:  // mulhu
                alu_operator_o        = ALU_ADD;
                multdiv_operator_o    = MD_OP_MULH;
                mult_int_en           = 1'b1;
                multdiv_signed_mode_o = 2'b00;
                illegal_insn_o        = RV32M ? 1'b0 : 1'b1;
            {6'b00_0001, 3'b100}:  // div
              alu_operator_o        = ALU_ADD;
              multdiv_operator_o    = MD_OP_DIV;
              div_int_en            = 1'b1;
              multdiv_signed_mode_o = 2'b11;
              illegal_insn_o        = RV32M ? 1'b0 : 1'b1; 
            {6'b00_0001, 3'b101}:  // divu
              alu_operator_o        = ALU_ADD;
              multdiv_operator_o    = MD_OP_DIV;
              div_int_en            = 1'b1;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn_o        = RV32M ? 1'b0 : 1'b1; 
            {6'b00_0001, 3'b110}:  // rem
              alu_operator_o        = ALU_ADD;
              multdiv_operator_o    = MD_OP_REM;
              div_int_en            = 1'b1;
              multdiv_signed_mode_o = 2'b11;
              illegal_insn_o        = RV32M ? 1'b0 : 1'b1;
            {6'b00_0001, 3'b111}:  // remu
              alu_operator_o        = ALU_ADD;
              multdiv_operator_o    = MD_OP_REM;
              div_int_en            = 1'b1;
              multdiv_signed_mode_o = 2'b00;
              illegal_insn_o        = RV32M ? 1'b0 : 1'b1;
	
SYSTEM	7'b111011	if (instr_rdata_i[14:12] == 3'b000)
instr_rdata_i[31:20] ==	12'h000: ecall_insn_o = 1'b1 // ECALL   // environment (system) call
12'h001: ebrk_insn_o = 1'b1;// ebreak  // debugger trap
12'h302: mret_insn_o = 1'b1; // mret
12'h105: pipe_flush_o = 1'b1;  // wfi  // flush pipeline
default: illegal_insn_o = 1'b1;
else
          csr_access_o        = 1'b1;
          regfile_we          = 1'b1;
          alu_op_b_mux_sel_o  = OP_B_IMM;
          imm_a_mux_sel_o     = IMMA_Z; 
 imm_b_mux_sel_o     = IMMB_I    // CSR address is encoded in Iimm
if (instr_rdata_i[14] == 1'b1)
            // rs1 field is used as immediate
            alu_op_a_mux_sel_o = OP_A_IMM;
else
            alu_op_a_mux_sel_o = OP_A_REGA_OR_FWD;
  case (instr_rdata_i[13:12])
            2'b01:   csr_op   = CSR_OP_WRITE; //2'b01
            2'b10:   csr_op   = CSR_OP_SET; //2'b10
            2'b11:   csr_op   = CSR_OP_CLEAR; //2'b11
            default: csr_illegal = 1'b1;
  if(~csr_illegal)
      if (instr_rdata_i[31:20] == 12'h300)
              //access to mstatus
              csr_status_o = 1'b1;
  illegal_insn_o = csr_illegal;
	
FENCE	7'b0001111	instr_rdata_i[14:12] ==	3'b000:  // FENCE
3'b001:  // FENCEI
                // flush pipeline
                pipe_flush_o = 1'b1;
default:  illegal_insn_o = 1'b1;
	
MMULT	7'b0001011	instr_rdata_i[14:12] ==	3'b101: // mmult32
              mmult_en = 1'b1;
              mmult_operator_o = 3'b101;
              mmult_param_o = instr_rdata_i[31:25];
              regfile_we = 1'b1;
default: illegal_insn_o = 1'b1;
	
 
● Zero-Riscy Compressed Decoder:
Decodes RISC-V compressed instructions into their RV32 equivalent. This module is fully combinatorial.
 <img width="1058" height="312" alt="image" src="https://github.com/user-attachments/assets/b3ff4b73-49ee-406c-b905-a32e1934a781" />

<img width="1015" height="860" alt="image" src="https://github.com/user-attachments/assets/5df2c8e8-da65-4237-9e78-20f3e9a2db36" />

 
● Load-Store-Unit (LSU):
The LSU of the core takes care of accessing the data memory. Load and stores on words (32 bit), half words (16 bit) and bytes (8 bit) are supported.
● How to refer to Data Type which you use when Zeroriscy Processor operate at real time and need to do memory write?
Data type 00 Word, 01 Half word, 11,10 byte
 <img width="975" height="274" alt="image" src="https://github.com/user-attachments/assets/969f5183-8af9-490c-b234-d6197244cf3d" />

<img width="1009" height="577" alt="image" src="https://github.com/user-attachments/assets/0be9d319-4d60-46e0-8ee1-440945a93f28" />

 
LSU Signals table
● Protocol:
The protocol that is used by the LSU to communicate with a memory works as follows: The LSU provides a valid address in data_addr_o and sets data_req_o high. The memory then answers with a data_gnt_i set high as soon as it is ready to serve the request. This may happen in the same cycle as the request was sent or any number of cycles later. After a grant was received, the address may be changed in the next cycle by the LSU. In addition, the data_wdata_o, data_we_o and data_be_o signals may be changed as it is assumed that the memory has already processed and stored that information. After receiving a grant, the memory answers with a data_rvalid_i set high if data_rdata_i is valid. This may happen one or more cycles after the grant has been received. Note that data_rvalid_i must also be set when a write was performed, although the data_rdata_i has no meaning in this case.

Basic Memory Transaction
 <img width="975" height="471" alt="image" src="https://github.com/user-attachments/assets/f68e3f9e-85fe-4b80-9a8c-eb9b132226d1" />


GNU Toolchain:
Example: Software and Image Processing System Flow

I have written a python script code for converting the original image into 2D array of pixels then store this 2D array in a memory file then write a C code to read this memory file and doing some processing on it like image filtering and edge detection then pass this C code to the compiler to get the assembly code then pass this assembly code to the assembler to get the hexadecimal machine code then pass this hexadecimal machine code to the instruction memory and here our Zero-Riscy processor can run and execute these instructions and load the targeted image from the data memory.

Image Processing Algorithm in GNU Toolchain
<img width="975" height="460" alt="image" src="https://github.com/user-attachments/assets/6ca38768-9887-4387-96ec-43f481945a12" />

 
● Simulation Result: 

Arithmetic and Logical Instructions Test
<img width="1442" height="495" alt="image" src="https://github.com/user-attachments/assets/7c7e0f56-4351-4c0a-8696-5879f51402ae" />


Led Toggle Based on Multiplication Execution Time Simulation
<img width="1644" height="730" alt="image" src="https://github.com/user-attachments/assets/48d8fe35-220e-47eb-ad8b-5ba1fdc130de" />

In the previous simulation result, We show that the multiplication operation take a three clock cycles through this time we have a led on then it will be off after the execution time of the multiplication operation.

 
The most critical path for 8-bit setup time is from (if_stage_i/instr_rdata_id_o_reg[21] to instr_add_o[6] ).
 <img width="1052" height="414" alt="image" src="https://github.com/user-attachments/assets/84d4e670-1c61-45db-ab42-a027d1e40aac" />

●After modifying the timing constraint file and use (clock frequency 40.694 MHZ):
» I checked that all design points are free from setup and hold timing violations.
 <img width="991" height="296" alt="image" src="https://github.com/user-attachments/assets/88a6572e-4461-45d6-92a7-812bf7902886" />


●Why the power decreased after adding timing constraints?
The tool does its best to met (pass) all paths without any setup or hold timing violations. So, It puts a large clock frequency that has a direct proportional for increasing dynamic power 
P_Dynamic=α*C_load 〖〖*V〗_DD〗^2*f_clk

● FPGA Prototyping Results:
 
Reset  
<img width="423" height="318" alt="image" src="https://github.com/user-attachments/assets/fc3ebe94-ed1a-4994-b2ad-709eb212919e" />

Logical OR 
<img width="427" height="320" alt="image" src="https://github.com/user-attachments/assets/a3f03109-9fa7-48d9-977b-827b646e8741" />

Arithmetic Division   
<img width="425" height="319" alt="image" src="https://github.com/user-attachments/assets/e93e1e96-3a4f-443a-9463-ddb8e119b5ea" />

Arithmetic Multiplication
 <img width="421" height="316" alt="image" src="https://github.com/user-attachments/assets/c9504e83-a248-4951-9554-637aeccd9a34" />

Arithmetic Addition      
<img width="427" height="320" alt="image" src="https://github.com/user-attachments/assets/59baa7ab-9a88-4456-849c-e5009e2831b1" />

Toggle LED Test on ZCU106 
<img width="429" height="321" alt="image" src="https://github.com/user-attachments/assets/e02d98e6-9d59-4453-a4ff-379b3ce00c89" />


In this test case of multiplication operation, we have operand_1 = 5 and operand_2 = 10. So, the result should be 50 which is shown in the following seven segment display of nexys 4 FPGA.
 
Led Toggle Based on Multiplication Execution Time on Nexys 4 FPGA
In the previous nexys 4 FPGA result, We can’t observe the led blinking which is so small 40ns (3 clock cycle, one for fetch and 2 clock cycles for execution). So, We use the oscilloscope to observe this led.
 <img width="725" height="543" alt="image" src="https://github.com/user-attachments/assets/5f28c7c1-3cf9-49bc-bf2e-31f1837a0d5c" />

 
Led blinking Observation on Tektronix Oscilloscope
<img width="699" height="463" alt="image" src="https://github.com/user-attachments/assets/7994405e-ed89-454b-9cba-63718ebb0cd3" />

<img width="992" height="744" alt="image" src="https://github.com/user-attachments/assets/6578a30c-ddd7-4bd3-8a53-f04760d0b83d" />


The total output dynamic power for 32-bit bus core after adding timing constraints (clock frequency 100 MHZ):
 
Dynamic Power Consumption
The total utilization for 32-bit bus width after adding timing constraints: 
<img width="433" height="509" alt="image" src="https://github.com/user-attachments/assets/30be4713-54ba-4d6a-9dee-d0cd40fe4074" />
 
FPGA Resource Utilization
<img width="464" height="545" alt="image" src="https://github.com/user-attachments/assets/557a3cda-3a7a-4129-821a-f9104056ffba" />

Conclusion:
» In this core, I collect Zero-Riscy with Micro-Riscy cores in the same RTL Via two parameters which enable a select to which one is activated. Micro-Riscy is further optimized for area with respect to Zero-Riscy by removing the RVM RISC-V extensions
» ZERO-RISCY is a 2-stage in-order 32b RISC-V processor core. the core is configurable to support four ISA configurations.
   • Full support for RV32I Base Integer Instruction Set 
   • Full support for RV32E Base Integer Instruction Set 
   • Full support for RV32C Standard Extension for Compressed Instructions 
   • Full support for RV32M Integer Multiplication and Division Instruction set Extension
Load and store instructions are executed in two cycles (one for address and one for accessing data from the memory). We have the availability to access Byte, Half word or word. The multiplier unit contains one (MAC) unit.
No forward-path and data-dependency logic are present in the core (No need for hazard unit).
Zero-Riscy implements a minimum set of control-status registers defined by the privileged RISC-V 1.9 spec, debug, and up to 32 interrupt requests.
