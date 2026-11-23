// Test-only types, written during migration. NOT the recovered DRAC package.
// Enum encodings are arbitrary; these tests do not verify decoder integration.
package drac_pkg;
  typedef logic [63:0] bus64_t;
  typedef logic [63:0] addrPC_t;
  typedef enum logic [5:0] {MAX, MIN, POPCNT, ADD, ADDW, SUB, SUBW,
    SLL, SLLW, SLT, SLTU, XOR, SRL, SRLW, SRA, SRAW, OR, AND,
    JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, OTHER} instr_type_t;
  typedef logic branch_decision_t;
  localparam branch_decision_t NOT_TAKEN=1'b0, TAKEN=1'b1;
  typedef struct packed {logic is_branch; branch_decision_t decision;
    addrPC_t pred_addr;} branch_pred_t;
endpackage
import drac_pkg::*;
