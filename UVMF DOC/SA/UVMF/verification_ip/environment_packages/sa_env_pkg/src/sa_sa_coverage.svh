class sa_sa_coverage extends uvm_subscriber #(sa_in_transaction);
  `uvm_component_utils(sa_sa_coverage)
  bit [1:0] last_a, last_b;
  covergroup operands_cg;
    a_cp: coverpoint last_a { bins vals[] = {[0:3]}; }
    b_cp: coverpoint last_b { bins vals[] = {[0:3]}; }
    all_pairs: cross a_cp, b_cp;
  endgroup
  function new(string name, uvm_component parent);
    super.new(name,parent);
    operands_cg = new();
  endfunction
  function void write(sa_in_transaction t);
    last_a=t.ina;
    last_b=t.inb;
    operands_cg.sample();
  endfunction
endclass
