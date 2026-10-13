// Example UVMF environment integration component, to be hooked up via
// generated environment's custom regions (not automatically YAML-wired).
class sa_scoreboard_uvmf extends uvm_component;
 `uvm_component_utils(sa_scoreboard_uvmf)
 uvm_tlm_analysis_fifo #(sa_out_transaction) expected_fifo, actual_fifo;
 int unsigned passed, failed;
 function new(string name,uvm_component parent); super.new(name,parent); endfunction
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   expected_fifo=new("expected_fifo",this);
   actual_fifo=new("actual_fifo",this);
 endfunction
 task run_phase(uvm_phase phase);
   sa_out_transaction e,a;
   forever begin
     expected_fifo.get(e); actual_fifo.get(a);
     if (e.result===a.result) begin passed++; `uvm_info("SA_PASS",$sformatf("sum=%0d",a.result),UVM_LOW) end
     else begin failed++; `uvm_error("SA_FAIL",$sformatf("expected %0d got %0d",e.result,a.result)) end
   end
 endtask
 function void check_phase(uvm_phase phase);
   if (passed+failed==0) `uvm_error("SA_EMPTY","No comparisons")
   if (expected_fifo.used() || actual_fifo.used()) `uvm_error("SA_UNMATCHED","Unmatched transactions")
 endfunction
 function void report_phase(uvm_phase phase);
   `uvm_info("SA_SUMMARY",$sformatf("passed=%0d failed=%0d",passed,failed),UVM_NONE)
 endfunction
endclass
