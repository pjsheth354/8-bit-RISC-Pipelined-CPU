// Main body of CPU consists of Top level modules connected with each other 

module CPU8_blk(input wire clk,
            input wire master_reset,
				output wire [7:0] final_output);
	 
	 wire [7:0] init_input;
	 assign init_input [7:0] = 8'b00001111; 	 
	 
	 // I/O's of FE stage and pipeline register between FE and DE stages
	 
	 wire [23:0] FE_stg_out;
	 wire FE_sel;
	 wire Z_output;
	 wire N_output;
	 wire Z_controller_output;
	 wire N_controller_output;
	 wire FE_mux_sel;
	 wire RF_in_sel;
	 assign reset = master_reset;
	 wire reset_output;

	 // I/O's of Controller Module
	 
	 wire [3:0] Controller_EXE_opcode_out;
	 wire [3:0] Controller_DM_opcode_out;
	 wire [3:0] WB_mux_sel;
	 
	 // Intermediate I/O's for connection of EXE with forwarding unit
	 
	 wire [7:0] DE_EXE_reg_out1;
	 wire [7:0] DE_EXE_reg_out2;
	 wire [7:0] DE_EXE_reg_out_add;
	 wire [3:0] pipe_stg_output4;
	 wire [1:0] FU_sel1, FU_sel2;
	 wire [7:0] Z_N_flag_status;
	 wire [7:0] Z_N_flag_status_output;
	 wire [7:0] shift_address_output;
	 wire [7:0] shift_address;

	 
	 wire [23:0] FE_DE_reg_out;
    wire [3:0] pipe_stg_output1;
	 
	 wire [3:0] pipe_stg_output2;
	 
	 // I/O's of DE stage and pipeline register between DE and EXE stages
	 
	 wire [7:0] DE_stg_out1;
	 wire [7:0] DE_stg_out2;
	 wire [7:0] DE_stg_out_linkAdd;
    wire [7:0] DE_stg_out_Add;
	 wire [7:0] DM_DE_output;
	 
	 wire [3:0] pipe_stg_output3;
	 
	 // I/O's of EXE stage and pipeline register between EXE and DM stages
	 
	 wire [7:0] EXE_stg_out;
	 wire [7:0] EXE_stg_out_add;
	 wire [7:0] EXE_stg_MUX;
	 wire [3:0] pipe_stg_output5;
	 
	 // I/O's of DM stage and pipeline register between DM and WB stages
	 
	 wire [7:0] DM_stg_out;
	 wire [7:0] DM_stg_out1;
	 wire [7:0] DM_stg_out_mux21;
	 wire [3:0] pipe_stg_output7;
	 
	 wire [7:0] EXE_DM_reg_out_add;
	 wire [7:0] EXE_DM_reg_out;
	 wire [7:0] EXE_DM_reg_out_MUX;
	 wire [3:0] pipe_stg_output6;
	 wire [3:0] opcode;
	 
	 wire [7:0] DM_WB_reg_out;
	 wire [7:0] DM_WB_reg_out1;
	 wire [7:0] DM_WB_reg_out_mux21;
	 wire [3:0] pipe_stg_output8; 
	 
	 // I/O's of WB stage
	 
	 wire WB_sel;
	 wire [7:0] WB_stg_out;
	 wire [7:0] WB_stg_out1;
	 
	 // Intermediate I/O to carry forward Register bits for tracking in each stage
	 
	 wire [1:0] register_read_Ra_output;
	 wire [1:0] register_read_Rb_output;
	 wire [1:0] register_read_Ra_output1;
	 wire [1:0] register_read_Rb_output1;
	 wire [1:0] register_read_Ra_output2;
	 wire [1:0] register_read_Rb_output2;
	 wire [1:0] register_read_Ra_output3;
	 wire [1:0] register_read_Rb_output3;
	 wire [1:0] register_read_Ra_output4;
	 wire [1:0] register_read_Rb_output4;
	 wire [1:0] register_read_Ra_output5;
	 wire [1:0] register_read_Rb_output5;
	 wire [1:0] register_read_Ra_output6;

	 // Controller module Instantiation
	 
	 controller con(.clk(clk),
	             .reset_input(reset),
					 .reset_output(reset_output),
	             .FEDEinput(FE_DE_reg_out[23:0]),
	             .FEDE_stg_input(FE_stg_out[23:0]),
	             .Z_input(Z_output),
					 .N_input(N_output),
					 .Z_output(Z_controller_output),
					 .N_output(N_controller_output),
					 .we_rf(we_rf),
					 //.we_lr(we_lr),
					 .FE_mux_sel(FE_mux_sel),
					 .RF_in_sel(RF_in_sel),
					 .EXE_opcode_in(pipe_stg_output3[3:0]),
		          .EXE_reg_in1(DE_EXE_reg_out1[7:0]),
	             .EXE_reg_in2(DE_EXE_reg_out2[7:0]),
		          .EXE_opcode_out(Controller_EXE_opcode_out[3:0]),
					 .address_input(EXE_DM_reg_out_add[7:0]),
	             .alu_input(EXE_DM_reg_out[7:0]),
		          .DM_opcode_in(pipe_stg_output4[3:0]),
		          .we_dm(we_dm),
		          .DM_opcode_out(Controller_DM_opcode_out[3:0]),
					 .WB_opcode_in(pipe_stg_output7[3:0]),
		          .datamemory_input(DM_WB_reg_out[7:0]),
                .datamemory_input1(DM_WB_reg_out1[7:0]),
		          .WB_mux_sel(WB_mux_sel)); 
	 
	 // FE stage Instantiation
	 
	 FE_stg FE_stg1(.reset(reset_output),
						 .clk(clk),
	                .instruction(FE_stg_out[23:0]),
						 .Z(Z_controller_output),
						 .N(N_controller_output));	
						
	                				
		
	 // Pipleine register between FE and DE Instantiation
	
	 FE_DE_reg DE_reg(.clk(clk),
	            .reg_in(FE_stg_out[23:0]),
					.reg_out(FE_DE_reg_out[23:0]));
	 
	 
	 // DE stage Instantiation
						 
	 DE_stg DE_stg1( 
	                 .clk(clk),
	                 .we_rf(we_rf),
						  //.we_lr(we_lr),
						  .instruction(FE_DE_reg_out[23:0]),
						  .data(WB_stg_out[7:0]),
						  .reset(reset_output),
						  .RF_in_sel(RF_in_sel),
						  .Ra(DE_stg_out1[7:0]),
						  .Rb(DE_stg_out2[7:0]),
						  //.Z(Z_controller_output),
						  //.N(N_controller_output),
						  //.return_address(DE_stg_out_linkAdd[7:0]),
						  .address_output(DE_stg_out_Add[7:0]),
					     .pipe_stg_output(pipe_stg_output2[3:0]),
						  .R0(R0),
						  .R1(R1),
						  .R2(R2),
						  .R3(R3),
						  .shift_address(shift_address[7:0]),
						  .register_read_Ra(register_read_Ra_output[1:0]),
						  .register_read_Rb(register_read_Rb_output[1:0]),
						  .WB_read_reg_Ra(register_read_Ra_output6[1:0]),
						  .WB_read_opcode(pipe_stg_output8[3:0]),
						  .DE_DM_input(DM_DE_output),
						  .DM_register_read_Ra_input(register_read_Ra_output4),
						  .DM_opcode_input(pipe_stg_output6[3:0]),
						  .Z_N_flag_status(Z_N_flag_status[7:0]),
						  .final_output(final_output[7:0]),
						  .init_input(init_input[7:0]));
	  
	 // Pipleine register between DE and EXE Instantiation 
    	
	 DE_EXE_reg DE_EXE_reg_stg(.clk(clk),
                .reg_in1(DE_stg_out1[7:0]),
	             .reg_in2(DE_stg_out2[7:0]),
	             .reg_in_add(DE_stg_out_Add[7:0]),
	             .reg_out1(DE_EXE_reg_out1[7:0]),
	             .reg_out2(DE_EXE_reg_out2[7:0]),
					 .shift_address(shift_address[7:0]),
					 .shift_address_output(shift_address_output[7:0]),
					 .Z_N_flag_status(Z_N_flag_status[7:0]),
					 .Z_N_flag_status_output(Z_N_flag_status_output[7:0]),
	             .reg_out_add(DE_EXE_reg_out_add[7:0]),
					 .pipe_stg_input(pipe_stg_output2[3:0]),
					 .pipe_stg_output(pipe_stg_output3[3:0]),
					 .register_read_Ra(register_read_Ra_output[1:0]),
					 .register_read_Rb(register_read_Rb_output[1:0]),
					 .register_read_Ra_output(register_read_Ra_output1[1:0]),
					 .register_read_Rb_output(register_read_Rb_output1[1:0]));
	 
	 
	 // EXE stage Instantiation
	 
	 EXE_stg EXE_stg1(.reset(reset_output),
	                  .mux41_data1(DE_EXE_reg_out1[7:0]),
	                  .mux41_data2(DE_EXE_reg_out2[7:0]),
							.mux41_dataWB1(WB_stg_out1[7:0]),
							.mux41_dataWB2(WB_stg_out1[7:0]),
							.mux41_dataDM1(DM_stg_out1[7:0]),
							.mux41_dataDM2(DM_stg_out1[7:0]),
							.shift_address(shift_address_output[7:0]),
	                  .address_input(DE_EXE_reg_out_add[7:0]),
	                  .mux21_input1(DE_EXE_reg_out1[7:0]),
	                  .mux21_input2(DE_EXE_reg_out2[7:0]),
	                  .address_output(EXE_stg_out_add[7:0]),
	                  .mux21_output(EXE_stg_MUX[7:0]),
	                  .alu_output(EXE_stg_out[7:0]),
							.Z_N_flag_status(Z_N_flag_status_output[7:0]),
							.pipe_stg_input(pipe_stg_output3[3:0]),
	                  .pipe_stg_output(pipe_stg_output4[3:0]),
							.FU_sel1(FU_sel1[1:0]),
							.FU_sel2(FU_sel2[1:0]),
							.Z_output(Z_output),
							.N_output(N_output),
							.Controller_sel(Controller_sel),
							.opcode(Controller_EXE_opcode_out[3:0]),
							.register_read_Ra(register_read_Ra_output1[1:0]),
					      .register_read_Rb(register_read_Rb_output1[1:0]),
					      .register_read_Ra_output(register_read_Ra_output2[1:0]),
					      .register_read_Rb_output(register_read_Rb_output2[1:0]));
		
    // Forwarding Unit Instantiation
		
	 FU FU1_stg(.Ra(DE_EXE_reg_out1[7:0]),
	        .Rb(DE_EXE_reg_out2[7:0]),
	        .WBinput(WB_stg_out1[7:0]), 
			  .DMinput(DM_stg_out_mux21[7:0]),
           .MUX41(FU_sel1[1:0]), 
	        .MUX42(FU_sel2[1:0]),
			  .DE_opcode(pipe_stg_output2[3:0]),
			  .EXE_opcode(pipe_stg_output3[3:0]));
	  
	 
	 // Pipleine register between EXE and DM Instantiation
	  
	 EXE_DM_reg EXE_DM_Reg(.clk(clk),
	             .address_input(EXE_stg_out_add[7:0]),
                .mux21_input(EXE_stg_MUX[7:0]),
                .alu_input(EXE_stg_out[7:0]),
                .pipe_stg_input(pipe_stg_output4[3:0]),
                .address_output(EXE_DM_reg_out_add[7:0]),
                .mux21_output(EXE_DM_reg_out_MUX[7:0]),
                .alu_output(EXE_DM_reg_out[7:0]),
                .pipe_stg_output(pipe_stg_output5[3:0]),
					 .register_read_Ra(register_read_Ra_output2[1:0]),
					 .register_read_Rb(register_read_Rb_output2[1:0]),
					 .register_read_Ra_output(register_read_Ra_output3[1:0]),
					 .register_read_Rb_output(register_read_Rb_output3[1:0])); 
					
	 // DM stage Instantiation
	 
	 DM_stg DM_stg1(.clk(clk),
	        .address_input(EXE_DM_reg_out_add[7:0]),
	        .mux21_input(EXE_DM_reg_out_MUX[7:0]),
	        .alu_input(EXE_DM_reg_out[7:0]),
	        .pipe_stg_input(pipe_stg_output5[3:0]),
	        .we(we_dm),
	        .opcode(Controller_DM_opcode_out[3:0]),
	        .datamemory_output(DM_stg_out[7:0]),
	        .datamemory_output1(DM_stg_out1[7:0]),
           .pipe_stg_output(pipe_stg_output6[3:0]),
	        .mux21_output(DM_stg_out_mux21[7:0]),
			  .register_read_Ra(register_read_Ra_output3[1:0]),
			  .register_read_Rb(register_read_Rb_output3[1:0]),
			  .register_read_Ra_output(register_read_Ra_output4[1:0]),
			  .register_read_Rb_output(register_read_Rb_output4[1:0]),
			  .DM_DE_output(DM_DE_output));
	
	 // Pipleine register between DM and WB Instantiation 
	 
	 DM_WB_reg DM_WB_reg_1(.clk(clk),
	            .datamemory_input(DM_stg_out[7:0]),
	            .datamemory_input1(DM_stg_out1[7:0]),
	            .mux21_input(DM_stg_out_mux21[7:0]),
	            .pipe_stg_input(pipe_stg_output6[3:0]),
	            .datamemory_output(DM_WB_reg_out[7:0]),
	            .datamemory_output1(DM_WB_reg_out1[7:0]),
               .pipe_stg_output(pipe_stg_output7[3:0]),
	            .mux21_output(DM_WB_reg_out_mux21[7:0]),
					.register_read_Ra(register_read_Ra_output4[1:0]),
			      .register_read_Rb(register_read_Rb_output4[1:0]),
			      .register_read_Ra_output(register_read_Ra_output5[1:0]),
			      .register_read_Rb_output(register_read_Rb_output5[1:0]));
	 
	 // WB stage Instantiation 
	  
	 WB_stg WB_stg_1(.inA(DM_WB_reg_out[7:0]),
            .inB(DM_WB_reg_out1[7:0]),
	         .mux21_input(DM_WB_reg_out_mux21[7:0]),
            .sel(WB_mux_sel),
            .out(WB_stg_out[7:0]),
            .mux21_output(WB_stg_out1[7:0]),
            .pipe_stg_input(pipe_stg_output7[3:0]),				
				.register_read_Ra(register_read_Ra_output5[1:0]),
			   .register_read_Ra_output(register_read_Ra_output6[1:0]),
				.pipe_stg_output(pipe_stg_output8[3:0]));
	  
	  
endmodule
