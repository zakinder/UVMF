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
  
      // Construct the transaction
      req=sa_in_transaction::type_id::create("req");
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "sa_in_random_sequence::body()-sa_in_transaction randomization failed")
      // Send the transaction to the sa_in_driver_bfm via the sequencer and sa_in_driver.
      finish_item(req);
      `uvm_info("SEQ", {"Response:",req.convert2string()},UVM_MEDIUM)

  endtask

endclass: sa_in_random_sequence

// pragma uvmf custom external begin
// pragma uvmf custom external end

