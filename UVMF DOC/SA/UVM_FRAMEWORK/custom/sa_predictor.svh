// Reference predictor: create expected output from input agent transactions.
// Can be used in custom UVMF predictor or scoreboard integration.
class sa_predictor extends uvm_component;
  `uvm_component_utils(sa_predictor)
  uvm_analysis_imp #(sa_in_transaction, sa_predictor) in;
  uvm_analysis_port #(sa_out_transaction) predicted;
  function new(string name, uvm_component parent);
    super.new(name,parent);
    in = new("in",this);
    predicted = new("predicted",this);
  endfunction
  function void write(sa_in_transaction t);
    sa_out_transaction out_tx;
    out_tx=sa_out_transaction::type_id::create("out_tx");
    out_tx.result = {1'b0,t.ina}+{1'b0,t.inb};
    predicted.write(out_tx);
  endfunction
endclass
// Names of generated transaction types may require qualification with
// sa_in_pkg:: and sa_out_pkg:: based on generated package imports.
