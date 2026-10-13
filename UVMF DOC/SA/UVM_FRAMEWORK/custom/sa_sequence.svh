// Integrate into generated bench sequence package or its custom includes.
class sa_random_sequence extends uvm_sequence #(sa_in_transaction);
  `uvm_object_utils(sa_random_sequence)
  function new(string name="sa_random_sequence"); super.new(name); endfunction
  task body();
    sa_in_transaction tr;
    repeat (15) begin
      tr=sa_in_transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize()) `uvm_fatal("RAND","Randomization failed")
      finish_item(tr);
    end
  endtask
endclass
