
module npu_cpu_system_wrapper

//----------------------------------------------------------------
// Ports
//----------------------------------------------------------------

(
     clk_i
    ,rst_i
    ,rst_rom_i
    ,mode_sel_i
    ,en_w_rom_i
    ,w_rom_addr_i
    ,w_rom_data_i
    ,instruction_i
    ,WB_RAM_data_o
    ,WB_reg_data_1_o
    ,WB_reg_data_2_o
);

    // Inputs
    input clk_i;
    input rst_i;
    input rst_rom_i;
    input mode_sel_i;
    input en_w_rom_i;
    input [15:0] w_rom_addr_i;
    input [31:0] w_rom_data_i;
    input [31:0] instruction_i;
    
    // Outputs
    output [7:0] WB_RAM_data_o;
    output [7:0] WB_reg_data_1_o;
    output [7:0] WB_reg_data_2_o;

//----------------------------------------------------------------
// Includes
//----------------------------------------------------------------

`include "defs.v"

//----------------------------------------------------------------
// Modules Output Wires
//----------------------------------------------------------------
    
// pc
wire [15:0] pc_s30;
wire [1:0] pc_sgin_s12;
wire [1:0] pc_sgin_s23;

// AXI inputs
reg axi_npu_ram_sel;
reg axi_en_w;
reg [3:0] axi_w_line;
reg [7:0] axi_r_rslt_addr;
reg [`IMG_C1_END - `IMG_C1_STA : 0] axi_img32_data;
reg [`IMG_S2_END - `IMG_S2_STA : 0] axi_img28_data;
reg [`IMG_C3_END - `IMG_C3_STA : 0] axi_img14_data;
reg [`IMG_S4_END - `IMG_S4_STA : 0] axi_img10_data;
reg [`IMG_C5_END - `IMG_C5_STA : 0] axi_img5_data;
reg [`FLITER_C1_END - `FLITER_C1_STA : 0] axi_fliter_c1_data;
reg [`FLITER_C3_END - `FLITER_C3_STA : 0] axi_fliter_c3_data;
reg [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] axi_weight_c5_data;
reg [`BIAS_C1_END - `BIAS_C1_STA : 0] axi_bias_c1_data;
reg [`BIAS_C3_END - `BIAS_C3_STA : 0] axi_bias_c3_data;
reg [`BIAS_C5_END - `BIAS_C5_STA : 0] axi_bias_c5_data;
reg [`RESULT_END - `RESULT_STA : 0] axi_result_data;

// rom
wire [31:0] rom_inst_s12;
wire [31:0] inst_s12;

// decoder
wire [7:0] alu_s12;
wire [1:0] reg_s12;
wire imm_s12;
wire mem_s12;
wire [4:0] r_reg_addr_1_s12;
wire [4:0] r_reg_addr_2_s12;
wire [4:0] r_reg_addr_3_s12;
wire [4:0] r_reg_addr_4_s12;
wire [15:0] r_ram_addr_s12;
wire [7:0] imm_data_1_s12;
wire [7:0] imm_data_2_s12;
wire [7:0] npu_ram_addr_s12;
wire [4:0] npu_w_reg_addr_s12;

// inst buffer
wire [7:0] alu_s23;
wire [1:0] reg_s23;
wire imm_s23;
wire mem_s23;
wire [4:0] r_reg_addr_1_s23;
wire [4:0] r_reg_addr_2_s23;
wire [4:0] r_reg_addr_3_s23;
wire [4:0] r_reg_addr_4_s23;
wire [15:0] r_ram_addr_s23;
wire [7:0] imm_data_1_s23;
wire [7:0] imm_data_2_s23;
wire [7:0] npu_ram_addr_s23;
wire [4:0] npu_w_reg_addr_s23;

// register
wire [7:0] r_reg_data_1;
wire [7:0] r_reg_data_2;
wire [7:0] r_reg_data_3;
wire [7:0] r_reg_data_4;

// ram
wire [7:0] r_ram_data;

// NPU ALU Write Back Register Selector
wire sel_en_w_reg;
wire [7:0] sel_w_reg_data_1;
wire [4:0] sel_w_reg_addr_1;

// NPU ram Selector
wire en_w_s12;
wire [3:0] w_line_s12;
wire [`IMG_C1_END - `IMG_C1_STA : 0] img32_s12;
wire [`IMG_S2_END - `IMG_S2_STA : 0] img28_s12;
wire [`IMG_C3_END - `IMG_C3_STA : 0] img14_s12;
wire [`IMG_S4_END - `IMG_S4_STA : 0] img10_s12;
wire [`IMG_C5_END - `IMG_C5_STA : 0] img5_s12;
wire [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_s12;
wire [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_s12;
wire [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_s12;
wire [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_s12;
wire [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_s12;
wire [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_s12;
wire [`RESULT_END - `RESULT_STA : 0] result_data_s12; // 640 bit

// NPU ram
wire [`IMG_C1_END - `IMG_C1_STA : 0] img32_s23;
wire [`IMG_S2_END - `IMG_S2_STA : 0] img28_s23;
wire [`IMG_C3_END - `IMG_C3_STA : 0] img14_s23;
wire [`IMG_S4_END - `IMG_S4_STA : 0] img10_s23;
wire [`IMG_C5_END - `IMG_C5_STA : 0] img5_s23;
wire [7:0] result_s23;
wire [`FLITER_C1_END - `FLITER_C1_STA : 0] fliter_c1_s23;
wire [`FLITER_C3_END - `FLITER_C3_STA : 0] fliter_c3_s23;
wire [`WEIGHT_C5_END - `WEIGHT_C5_STA : 0] weight_c5_s23;
wire [`BIAS_C1_END - `BIAS_C1_STA : 0] bias_c1_s23;
wire [`BIAS_C3_END - `BIAS_C3_STA : 0] bias_c3_s23;
wire [`BIAS_C5_END - `BIAS_C5_STA : 0] bias_c5_s23;

// alu write back
wire en_w_reg;
wire en_w_ram;
wire [7:0] w_ram_data;
wire [15:0] w_ram_addr;
wire [7:0] w_reg_data_1;
wire [7:0] w_reg_data_2;
wire [4:0] w_reg_addr_1;
wire [4:0] w_reg_addr_2;

// NPU ALU
wire wb_en_w_npu_ram;
wire [3:0] wb_w_line;
wire [`IMG_S2_END - `IMG_S2_STA : 0] wb_img28_data;
wire [`IMG_C3_END - `IMG_C3_STA : 0] wb_img14_data;
wire [`IMG_S4_END - `IMG_S4_STA : 0] wb_img10_data;
wire [`IMG_C5_END - `IMG_C5_STA : 0] wb_img5_data;
wire [`RESULT_END - `RESULT_STA : 0] wb_result_data;
wire npu_alu_sel;
wire en_w_reg_npu;
wire [4:0] w_reg_addr_npu;
wire [7:0] w_reg_data_npu;

//----------------------------------------------------------------
// Modules
//----------------------------------------------------------------

rom rom(
     .clk_i(clk_i)
    ,.rst_i(rst_rom_i)
    ,.pc_i(pc_s30)
    ,.w_rom_data_i(w_rom_data_i)
    ,.w_rom_addr_i(w_rom_addr_i)
    ,.en_w_rom_i(en_w_rom_i)
    ,.inst_o(rom_inst_s12)
);

inst_mode inst_mode(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.mode_sel_i(mode_sel_i)
    ,.imm_inst_i(instruction_i)
    ,.rom_inst_i(rom_inst_s12)
    ,.inst_o(inst_s12)
);

decode decode(
     .inst_i(inst_s12)
    ,.alu_o(alu_s12)
    ,.pc_o(pc_sgin_s12)
    ,.reg_o(reg_s12)
    ,.imm_o(imm_s12)
    ,.mem_o(mem_s12)
    ,.reg_addr_1_o(r_reg_addr_1_s12)
    ,.reg_addr_2_o(r_reg_addr_2_s12)
    ,.reg_addr_3_o(r_reg_addr_3_s12)
    ,.reg_addr_4_o(r_reg_addr_4_s12)
    ,.ram_addr_o(r_ram_addr_s12)
    ,.imm_data_1_o(imm_data_1_s12)
    ,.imm_data_2_o(imm_data_2_s12)
    ,.npu_ram_addr_o(npu_ram_addr_s12)
    ,.npu_w_reg_addr_o(npu_w_reg_addr_s12)
);

ram ram(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.en_w_ram_i(en_w_ram)
    ,.w_ram_data_i(w_ram_data)
    ,.w_ram_addr_i(w_ram_addr)
    ,.r_ram_addr_i(r_ram_addr_s12)
    ,.r_ram_data_o(r_ram_data)
);

N_reg_selector N_reg_selector(
     .npu_alu_sel_i(npu_alu_sel)
    ,.en_w_reg_npu_i(en_w_reg_npu)
    ,.w_reg_addr_npu_i(w_reg_addr_npu)
    ,.w_reg_data_npu_i(w_reg_data_npu)
    ,.en_w_reg_i(en_w_reg)
    ,.w_reg_data_1_i(w_reg_data_1)
    ,.w_reg_addr_1_i(w_reg_addr_1)
    ,.en_w_reg_o(sel_en_w_reg)
    ,.w_reg_data_1_o(sel_w_reg_data_1)
    ,.w_reg_addr_1_o(sel_w_reg_addr_1)
);

register register(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.en_w_reg_i(sel_en_w_reg)
    ,.w_reg_data_1_i(sel_w_reg_data_1)
    ,.w_reg_data_2_i(w_reg_data_2)
    ,.w_reg_addr_1_i(sel_w_reg_addr_1)
    ,.w_reg_addr_2_i(w_reg_addr_2)
    ,.r_reg_addr_1_i(r_reg_addr_1_s12)
    ,.r_reg_addr_2_i(r_reg_addr_2_s12)
    ,.r_reg_addr_3_i(r_reg_addr_3_s12)
    ,.r_reg_addr_4_i(r_reg_addr_4_s12)
    ,.r_reg_data_1_o(r_reg_data_1)
    ,.r_reg_data_2_o(r_reg_data_2)
    ,.r_reg_data_3_o(r_reg_data_3)
    ,.r_reg_data_4_o(r_reg_data_4)
);

N_ram_selector N_ram_selector(

     .npu_alu_sel_i(axi_npu_ram_sel)

    ,.wb_en_w_i(wb_en_w_npu_ram)
    ,.wb_w_line_i(wb_w_line)
    ,.wb_img28_data_i(wb_img28_data)
    ,.wb_img14_data_i(wb_img14_data)
    ,.wb_img10_data_i(wb_img10_data)
    ,.wb_img5_data_i(wb_img5_data)
    ,.wb_result_data_i(wb_result_data)

    ,.axi_en_w_i(axi_en_w)
    ,.axi_w_line_i(axi_w_line)
    ,.axi_r_rslt_addr_i(axi_r_rslt_addr)
    ,.axi_img32_data_i(axi_img32_data)
    ,.axi_img28_data_i(axi_img28_data)
    ,.axi_img14_data_i(axi_img14_data)
    ,.axi_img10_data_i(axi_img10_data)
    ,.axi_img5_data_i(axi_img5_data)
    ,.axi_fliter_c1_data_i(axi_fliter_c1_data)
    ,.axi_fliter_c3_data_i(axi_fliter_c3_data)
    ,.axi_weight_c5_data_i(axi_weight_c5_data)
    ,.axi_bias_c1_data_i(axi_bias_c1_data)
    ,.axi_bias_c3_data_i(axi_bias_c3_data)
    ,.axi_bias_c5_data_i(axi_bias_c5_data)
    ,.axi_result_data_i(axi_result_data)

    ,.en_w_o(en_w_s12)
    ,.w_line_o(w_line_s12)
    ,.img32_data_o(img32_s12)
    ,.img28_data_o(img28_s12)
    ,.img14_data_o(img14_s12)
    ,.img10_data_o(img10_s12)
    ,.img5_data_o(img5_s12)
    ,.fliter_c1_data_o(fliter_c1_s12)
    ,.fliter_c3_data_o(fliter_c3_s12)
    ,.weight_c5_data_o(weight_c5_s12)
    ,.bias_c1_data_o(bias_c1_s12)
    ,.bias_c3_data_o(bias_c3_s12)
    ,.bias_c5_data_o(bias_c5_s12)
    ,.result_data_o(result_data_s12)
);

NPU_ram NPU_ram(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.en_w_i(en_w_s12)
    ,.w_line_i(w_line_s12)
    ,.r_rslt_addr_i(npu_ram_addr_s12)
    ,.img32_data_i(img32_s12)
    ,.img28_data_i(img28_s12)
    ,.img14_data_i(img14_s12)
    ,.img10_data_i(img10_s12)
    ,.img5_data_i(img5_s12)
    ,.fliter_c1_data_i(fliter_c1_s12)
    ,.fliter_c3_data_i(fliter_c3_s12)
    ,.weight_c5_data_i(weight_c5_s12)
    ,.bias_c1_data_i(bias_c1_s12)
    ,.bias_c3_data_i(bias_c3_s12)
    ,.bias_c5_data_i(bias_c5_s12)
    ,.result_data_i(result_data_s12)

    ,.img32_o(img32_s23) 
    ,.img28_o(img28_s23) 
    ,.img14_o(img14_s23) 
    ,.img10_o(img10_s23) 
    ,.img5_o(img5_s23) 
    ,.result_o(result_s23)
    ,.fliter_c1_o(fliter_c1_s23) 
    ,.fliter_c3_o(fliter_c3_s23) 
    ,.weight_c5_o(weight_c5_s23) 
    ,.bias_c1_o(bias_c1_s23) 
    ,.bias_c3_o(bias_c3_s23) 
    ,.bias_c5_o(bias_c5_s23) 
);

inst_buffer inst_buffer(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.alu_i(alu_s12)
    ,.pc_i(pc_sgin_s12)
    ,.reg_i(reg_s12)
    ,.imm_i(imm_s12)
    ,.mem_i(mem_s12)
    ,.reg_addr_1_i(r_reg_addr_1_s12)
    ,.reg_addr_2_i(r_reg_addr_2_s12)
    ,.reg_addr_3_i(r_reg_addr_3_s12)
    ,.reg_addr_4_i(r_reg_addr_4_s12)
    ,.ram_addr_i(r_ram_addr_s12)
    ,.imm_data_1_i(imm_data_1_s12)
    ,.imm_data_2_i(imm_data_2_s12)
    ,.npu_ram_addr_i(npu_ram_addr_s12)
    ,.npu_w_reg_addr_i(npu_w_reg_addr_s12)
    ,.alu_o(alu_s23)
    ,.pc_o(pc_sgin_s23)
    ,.reg_o(reg_s23)
    ,.imm_o(imm_s23)
    ,.mem_o(mem_s23)
    ,.reg_addr_1_o(r_reg_addr_1_s23)
    ,.reg_addr_2_o(r_reg_addr_2_s23)
    ,.reg_addr_3_o(r_reg_addr_3_s23)
    ,.reg_addr_4_o(r_reg_addr_4_s23)
    ,.ram_addr_o(r_ram_addr_s23)
    ,.imm_data_1_o(imm_data_1_s23)
    ,.imm_data_2_o(imm_data_2_s23)
    ,.npu_ram_addr_o(npu_ram_addr_s23)
    ,.npu_w_reg_addr_o(npu_w_reg_addr_s23)
);

alu alu(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.mode_sel_i(mode_sel_i)
    ,.alu_i(alu_s23)
    ,.pc_i(pc_sgin_s23)
    ,.reg_i(reg_s23)
    ,.imm_i(imm_s23)
    ,.mem_i(mem_s23)
    ,.reg_addr_1_i(r_reg_addr_1_s23)
    ,.reg_addr_2_i(r_reg_addr_2_s23)
    ,.reg_addr_3_i(r_reg_addr_3_s23)
    ,.reg_addr_4_i(r_reg_addr_4_s23)
    ,.ram_addr_i(r_ram_addr_s23)
    ,.imm_data_1_i(imm_data_1_s23)
    ,.imm_data_2_i(imm_data_2_s23)
    ,.r_ram_data_i(r_ram_data)
    ,.r_reg_data_1_i(r_reg_data_1)
    ,.r_reg_data_2_i(r_reg_data_2)
    ,.r_reg_data_3_i(r_reg_data_3)
    ,.r_reg_data_4_i(r_reg_data_4)
    ,.r_pc_data_i(pc_s30)
    ,.en_w_reg_o(en_w_reg)
    ,.en_w_ram_o(en_w_ram)
    ,.w_ram_data_o(w_ram_data)
    ,.w_ram_addr_o(w_ram_addr)
    ,.w_reg_data_1_o(w_reg_data_1)
    ,.w_reg_data_2_o(w_reg_data_2)
    ,.w_reg_addr_1_o(w_reg_addr_1)
    ,.w_reg_addr_2_o(w_reg_addr_2)
    ,.w_pc_data_o(pc_s30)
);

NPU_alu NPU_alu(
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.alu_i(alu_s23)
    ,.w_reg_addr_npu_i(npu_w_reg_addr_s23)
    ,.img32_i(img32_s23)
    ,.img28_i(img28_s23)
    ,.img14_i(img14_s23)
    ,.img10_i(img10_s23)
    ,.img5_i(img5_s23)
    ,.result_i(result_s23)
    ,.fliter_c1_i(fliter_c1_s23)
    ,.fliter_c3_i(fliter_c3_s23)
    ,.weight_c5_i(weight_c5_s23)
    ,.bias_c1_i(bias_c1_s23)
    ,.bias_c3_i(bias_c3_s23)
    ,.bias_c5_i(bias_c5_s23)
    ,.en_w_o(wb_en_w_npu_ram)
    ,.w_line_o(wb_w_line)
    ,.img28_data_o(wb_img28_data)
    ,.img14_data_o(wb_img14_data)
    ,.img10_data_o(wb_img10_data)
    ,.img5_data_o(wb_img5_data)
    ,.result_data_o(wb_result_data)
    ,.npu_alu_sel_o(npu_alu_sel)
    ,.en_w_reg_npu_o(en_w_reg_npu)
    ,.w_reg_addr_npu_o(w_reg_addr_npu)
    ,.w_reg_data_npu_o(w_reg_data_npu)
);

//----------------------------------------------------------------
// Output Watcher
//----------------------------------------------------------------

assign WB_RAM_data_o = w_ram_data;
assign WB_reg_data_1_o = sel_w_reg_data_1;
assign WB_reg_data_2_o = w_reg_data_2;

endmodule
