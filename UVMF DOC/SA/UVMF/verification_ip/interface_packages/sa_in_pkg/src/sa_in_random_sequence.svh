//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the sa_in transaction and sends it 
// to the UVM driver.
//
// This sequence constructs and randomizes a sa_in_transaction.
// 
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class sa_in_random_sequence 
  extends sa_in_sequence_base ;

  `uvm_object_utils( sa_in_random_sequence )

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  //*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

  // ****************************************************************************
  // TASK : body()
  // This task is automatically executed when this sequence is started using the 
  // start(sequencerHandle) task.
  //
  task body();
    // Exhaustively test 16 operand combinations (0..3 x 0..3)
    // followed by 15 randomized operand pairs.
    for (int a=0; a<4; a++) begin
      for (int b=0; b<4; b++) begin
        req = sa_in_transaction::type_id::create("exhaustive_req");
        start_item(req);
        req.ina = 2'(a);
        req.inb = 2'(b);
        finish_item(req);
      end
    end
    repeat (15) begin
      req = sa_in_transaction::type_id::create("random_req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal("SA_RAND", "Cannot randomize")
      finish_item(req);
    end
  endtask

endclass: sa_in_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

