class sa_sa_scoreboard extends uvm_component;
 `uvm_component_utils(sa_sa_scoreboard)
 uvm_tlm_analysis_fifo #(sa_out_transaction) expected_fifo;
 uvm_tlm_analysis_fifo #(sa_out_transaction) actual_fifo;
 int unsigned pass_count, fail_count;
 function new(string name,uvm_component parent); super.new(name,parent); endfunction
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   expected_fifo = new("expected_fifo",this);
   actual_fifo = new("actual_fifo",this);
 endfunction
 task run_phase(uvm_phase phase);
   sa_out_transaction exp, act;
   forever begin
     expected_fifo.get(exp);
     actual_fifo.get(act);
     if (exp.result === act.result) begin
       pass_count++;
       `uvm_info("SA_MATCH", $sformatf("sum=%0d",act.result), UVM_LOW)
     end else begin
       fail_count++;
       `uvm_error("SA_MISMATCH", $sformatf("expected=%0d actual=%0d",exp.result,act.result))
     end
   end
 endtask
 function void check_phase(uvm_phase phase);
   super.check_phase(phase);
   if (pass_count+fail_count == 0) `uvm_error("SA_NO_TEST","No transactions compared")
   if (expected_fifo.used() || actual_fifo.used()) `uvm_error("SA_REMAINDER","Unmatched transactions")
 endfunction
 function void report_phase(uvm_phase phase);
   `uvm_info("SA_RESULTS",$sformatf("pass=%0d fail=%0d",pass_count,fail_count),UVM_NONE)
 endfunction
endclass
