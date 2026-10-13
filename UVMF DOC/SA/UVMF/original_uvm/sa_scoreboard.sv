class sa_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(sa_scoreboard)
  uvm_analysis_export #(sa_transaction) expected_export;
  uvm_analysis_export #(sa_transaction) actual_export;
  uvm_tlm_analysis_fifo #(sa_transaction) expected_fifo;
  uvm_tlm_analysis_fifo #(sa_transaction) actual_fifo;
  int unsigned pass_count, fail_count;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_export = new("expected_export",this);
    actual_export = new("actual_export",this);
    expected_fifo = new("expected_fifo",this);
    actual_fifo = new("actual_fifo",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    expected_export.connect(expected_fifo.analysis_export);
    actual_export.connect(actual_fifo.analysis_export);
  endfunction
  task run_phase(uvm_phase phase);
    sa_transaction expected,actual,actual_normalized;
    uvm_comparer comparer;
    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      // Output monitor observes only the serial sum. Supply the associated
      // input operands from the expected transaction so compare() checks
      // all three sa_transaction fields without false input mismatches.
      actual_normalized = sa_transaction::type_id::create("actual_normalized");
      actual_normalized.copy(actual);
      actual_normalized.ina = expected.ina;
      actual_normalized.inb = expected.inb;
      comparer = new();
      if (expected.compare(actual_normalized, comparer)) begin
        pass_count++;
        `uvm_info("ADDER_PASS",$sformatf("A=%0d B=%0d expected=%0d actual=%0d",expected.ina,expected.inb,expected.out,actual.out),UVM_LOW)
      end else begin
        fail_count++;
        `uvm_error("ADDER_MISMATCH",$sformatf("A=%0d B=%0d expected=%0d actual=%0d",expected.ina,expected.inb,expected.out,actual.out))
      end
    end
  endtask
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (pass_count+fail_count==0) `uvm_error("NO_CHECKS","No transactions compared")
    if (expected_fifo.used()!=0 || actual_fifo.used()!=0)
      `uvm_error("UNMATCHED",$sformatf("Remaining expected=%0d actual=%0d",expected_fifo.used(),actual_fifo.used()))
  endfunction
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("ADDER_SUMMARY",$sformatf("PASSED=%0d FAILED=%0d",pass_count,fail_count),UVM_NONE)
  endfunction
endclass
