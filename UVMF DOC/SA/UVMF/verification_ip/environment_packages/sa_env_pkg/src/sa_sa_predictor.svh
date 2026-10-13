// Serial-adder reference model; called from monitor TLM analysis path.
`uvm_analysis_imp_decl(_sa_input)
class sa_sa_predictor extends uvm_component;
  `uvm_component_utils(sa_sa_predictor)
  uvm_analysis_imp_sa_input #(sa_in_transaction, sa_sa_predictor) input_export;
  uvm_analysis_port #(sa_out_transaction) expected_ap;
  function new(string name, uvm_component parent);
    super.new(name,parent);
    input_export = new("input_export",this);
    expected_ap = new("expected_ap",this);
  endfunction
  function void write_sa_input(sa_in_transaction t);
    sa_out_transaction e;
    e = sa_out_transaction::type_id::create("expected");
    e.result = {1'b0,t.ina} + {1'b0,t.inb};
    expected_ap.write(e);
  endfunction
endclass
