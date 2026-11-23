//`default_nettype none
import drac_pkg::*;

module alu (
    input bus64_t  data_rs1_i,
    input bus64_t  data_rs2_i,
    input instr_type_t instr_type_i,
    output bus64_t result_o
);

always_comb begin
    case (instr_type_i)
        MAX: begin
            result_o = ($signed(64'(data_rs1_i)) > $signed(64'(data_rs2_i))) ? 64'(data_rs1_i) : 64'(data_rs2_i);
        end
        MIN: begin
            result_o = ($signed(64'(data_rs1_i)) > $signed(64'(data_rs2_i))) ? 64'(data_rs2_i) : 64'(data_rs1_i);
        end
        POPCNT: begin
            logic [1:0] sum1 [31:0];
            logic [2:0] sum2 [15:0];
            logic [3:0] sum3 [7:0];
            logic [4:0] sum4 [3:0];
            logic [5:0] sum5 [1:0];

            for (int i = 0; i < 32; i++) begin
                sum1[i] = data_rs1_i[2*i] + data_rs1_i[2*i+1];
            end

            
            for (int i = 0; i < 16; i++) begin
                sum2[i] = sum1[2*i] + sum1[2*i+1];
            end

            for (int i = 0; i < 8; i++) begin
                sum3[i] = sum2[2*i] + sum2[2*i+1];
            end

            for (int i = 0; i < 4; i++) begin
                sum4[i] = sum3[2*i] + sum3[2*i+1];
            end

            for (int i = 0; i < 2; i++) begin
                sum5[i] = sum4[2*i] + sum4[2*i+1];
            end

            result_o = sum5[0] + sum5[1];
        end
        ADD: begin
            result_o = 64'(data_rs1_i + data_rs2_i);
        end
        ADDW: begin
            result_o[31:0] = 32'(data_rs1_i[31:0] + data_rs2_i[31:0]);
            result_o[63:32] = {32{result_o[31]}};
        end
        SUB: begin
            result_o = 64'(data_rs1_i - data_rs2_i);
        end
        SUBW: begin
            result_o[31:0] = 32'(data_rs1_i[31:0] - data_rs2_i[31:0]);
            result_o[63:32] = {32{result_o[31]}};
        end
        SLL: begin
            result_o = data_rs1_i << data_rs2_i[5:0];
        end
        SLLW: begin
            result_o[31:0] = data_rs1_i[31:0] << data_rs2_i[4:0];
            result_o[63:32] = {32{result_o[31]}};
        end
        SLT: begin
            result_o = {63'b0, $signed(data_rs1_i) < $signed(data_rs2_i)};
        end
        SLTU: begin
            result_o = {63'b0, data_rs1_i < data_rs2_i};
        end
        XOR: begin
            result_o = data_rs1_i ^ data_rs2_i;
        end
        SRL: begin
            result_o = data_rs1_i >> data_rs2_i[5:0];
        end
        SRLW: begin
            result_o[31:0] = data_rs1_i[31:0] >> data_rs2_i[4:0];
            result_o[63:32] = {32{result_o[31]}};
        end
        SRA: begin
            result_o = $signed(data_rs1_i) >>> data_rs2_i[5:0];
        end
        SRAW: begin
            result_o[31:0] = $signed(data_rs1_i[31:0]) >>> data_rs2_i[4:0];
            result_o[63:32] = {32{result_o[31]}};
        end
        OR: begin
            result_o = data_rs1_i | data_rs2_i;
        end
        AND: begin
            result_o = data_rs1_i & data_rs2_i;
        end
        default: begin
            result_o = 0;
        end
    endcase
end

endmodule
//`default_nettype wire

