class sa_sequence extends uvm_sequence#(sa_transaction);
 `uvm_object_utils(sa_sequence)
 extern function   new(string name = "");
 extern task    body();
endclass: sa_sequence
typedef uvm_sequencer#(sa_transaction) sa_sequencer;
function sa_sequence::new(string name = "");
 super.new(name);
endfunction: new
task sa_sequence::body();
 sa_transaction sa_tx;
 if (starting_phase != null)
     starting_phase.raise_objection(this);
 repeat(15) begin
  sa_tx = sa_transaction::type_id::create(.name("sa_tx") ,
               .contxt(get_full_name()) );
  start_item(sa_tx);     /* handshake with driver::get function */   
  if( !sa_tx.randomize() )                
   `uvm_error("", "failed to randomize...");
  finish_item(sa_tx);    /* handshake with driver::get function */   
 end
 if (starting_phase != null)
  starting_phase.drop_objection(this);
endtask: body