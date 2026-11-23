module tb_units;
  import drac_pkg::*;
  bus64_t a, b, value, imm;
  addrPC_t pc, target, link_pc;
  instr_type_t op;
  branch_decision_t taken;
  logic stall, correct;
  branch_pred_t prediction;
  alu dut(a,b,op,value);
  branch_unit branch_dut(op,pc,a,b,imm,taken,target,link_pc);
  branch_prediction_checker checker_dut(stall,op,taken,target,prediction,correct);
  integer checks = 0;
  task automatic alu_check(input instr_type_t operation, input bus64_t x,y,expected);
    op=operation; a=x; b=y; #1;
    if(value !== expected) $fatal(1,"ALU op %0d: %h != %h",op,value,expected);
    checks++;
  endtask
  task automatic branch_check(input instr_type_t operation,input bus64_t x,y,
                               input branch_decision_t expected_taken,input addrPC_t expected_target);
    op=operation; a=x; b=y; #1;
    if(taken !== expected_taken || target !== expected_target || link_pc !== pc+4)
      $fatal(1,"branch op %0d taken=%b target=%h",op,taken,target);
    checks++;
  endtask
  task automatic prediction_check(input logic expected);
    #1;
    if(correct !== expected) $fatal(1,"prediction mismatch op=%0d",op);
    checks++;
  endtask
  bus64_t x,y;
  integer population;
  initial begin
    pc=64'h1000; imm=64'h20; stall=0; prediction='0;
    alu_check(POPCNT,0,0,0);
    alu_check(POPCNT,64'hffffffffffffffff,0,64);
    for(integer bitno=0;bitno<64;bitno++) alu_check(POPCNT,64'h1<<bitno,0,1);
    alu_check(MAX,64'h8000000000000000,64'h7fffffffffffffff,64'h7fffffffffffffff);
    alu_check(MIN,64'h8000000000000000,64'h7fffffffffffffff,64'h8000000000000000);
    for(integer i=0;i<1000;i++) begin
      x={$random,$random}; y={$random,$random}; population=0;
      for(integer j=0;j<64;j++) if(x[j]) population++;
      alu_check(POPCNT,x,y,population);
      alu_check(MAX,x,y,$signed(x)>$signed(y)?x:y);
      alu_check(MIN,x,y,$signed(x)<$signed(y)?x:y);
      alu_check(ADD,x,y,x+y); alu_check(SUB,x,y,x-y);
      alu_check(XOR,x,y,x^y); alu_check(AND,x,y,x&y); alu_check(OR,x,y,x|y);
      alu_check(SLL,x,y,x<<y[5:0]); alu_check(SRL,x,y,x>>y[5:0]);
      alu_check(SRA,x,y,$signed(x)>>>y[5:0]);
      alu_check(SLT,x,y,$signed(x)<$signed(y)); alu_check(SLTU,x,y,x<y);
    end
    alu_check(ADDW,64'h7fffffff,1,64'hffffffff80000000);
    alu_check(SUBW,0,1,64'hffffffffffffffff);
    alu_check(SLLW,1,31,64'hffffffff80000000);
    alu_check(SRLW,64'hffffffff,1,64'h7fffffff);
    alu_check(SRAW,64'h80000000,31,64'hffffffffffffffff);
    branch_check(BEQ,5,5,TAKEN,64'h1020);
    branch_check(BEQ,5,6,NOT_TAKEN,64'h1004);
    branch_check(BNE,5,6,TAKEN,64'h1020);
    branch_check(BNE,5,5,NOT_TAKEN,64'h1004);
    branch_check(BLT,64'hffffffffffffffff,0,TAKEN,64'h1020);
    branch_check(BGE,64'hffffffffffffffff,0,NOT_TAKEN,64'h1004);
    branch_check(BLTU,64'hffffffffffffffff,0,NOT_TAKEN,64'h1004);
    branch_check(BGEU,64'hffffffffffffffff,0,TAKEN,64'h1020);
    branch_check(BLT,1,0,NOT_TAKEN,64'h1004);
    branch_check(BGE,1,0,TAKEN,64'h1020);
    branch_check(BLTU,0,1,TAKEN,64'h1020);
    branch_check(BGEU,0,1,NOT_TAKEN,64'h1004);
    branch_check(JALR,64'h2001,0,TAKEN,64'h2020);
    branch_check(JAL,0,0,NOT_TAKEN,64'h1004); // redirect belongs to decode
    branch_check(OTHER,0,0,NOT_TAKEN,64'h1004);
    op=BEQ; a=1; b=1; prediction.is_branch=1;
    prediction.decision=TAKEN; prediction.pred_addr=64'h1020;
`ifdef BP_ENABLE
    prediction_check(1);
    prediction.pred_addr=64'h2000; prediction_check(0);
    prediction.decision=NOT_TAKEN; prediction_check(0);
    b=2; prediction_check(1);
    prediction.decision=TAKEN; prediction.pred_addr=64'h1004; prediction_check(1);
    prediction.pred_addr=64'h2000; prediction_check(0);
    op=ADD; prediction_check(0);
    prediction.is_branch=0; prediction_check(1);
`else
    prediction_check(0); op=ADD; prediction_check(1);
`endif
    op=JAL; prediction_check(1);
    op=JALR; stall=1; prediction_check(1);
    $display("PASS %0d isolated ALU/branch/prediction checks",checks);
    $finish;
  end
endmodule
