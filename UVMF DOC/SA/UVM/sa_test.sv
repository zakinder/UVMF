class sa_test extends uvm_test;
  `uvm_component_utils(sa_test)
  sa_env sa_env;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sa_env=sa_env::type_id::create("sa_env",this);
  endfunction
  // This method is run before the DUT sequence and exercises every requested
  // uvm_object hook through its standard PUBLIC API.
  task exercise_transaction_methods();
    sa_transaction original, copied, decoded, changed;
    uvm_comparer cmp;
    uvm_recorder rec;
    bit packed_bits[];
    int nbits;

    original = sa_transaction::type_id::create("original");
    copied   = sa_transaction::type_id::create("copied");
    decoded  = sa_transaction::type_id::create("decoded");
    changed  = sa_transaction::type_id::create("changed");
    original.ina = 2'd2;
    original.inb = 2'd3;
    original.out = 3'd5;

    // 1. convert2string()
    `uvm_info("SA_METHOD_STRING", original.convert2string(), UVM_LOW)

    // 2. do_copy() through copy()
    copied.copy(original);
    // 3. do_compare() through compare()
    cmp = new();
    if (!original.compare(copied, cmp))
      `uvm_fatal("SA_METHOD_COPY", "copy/compare failed")

    // 4. do_print() through sprint()/print()
    `uvm_info("SA_METHOD_PRINT", original.sprint(), UVM_LOW)

    // 5. do_record() through record() with a recorder.
    // Backend-specific waveform/database output needs the simulator's
    // transaction-recording configuration.
    rec = new("sa_method_recorder");
    original.record(rec);
    `uvm_info("SA_METHOD_RECORD", "Called record(rec): do_record executed", UVM_LOW)

    // 6. do_pack() and 7. do_unpack() through the bit-array APIs.
    nbits = original.pack_bits(packed_bits);
    if (nbits != 7)
      `uvm_fatal("SA_METHOD_PACK", $sformatf("Expected 7 packed bits; got %0d", nbits))
    void'(decoded.unpack_bits(packed_bits));
    cmp = new();
    if (!original.compare(decoded, cmp))
      `uvm_fatal("SA_METHOD_UNPACK", "pack/unpack round-trip failed")

    // Negative compare demonstrates field-by-field mismatch diagnostics.
    changed.copy(original);
    changed.out = original.out ^ 3'b001;
    cmp = new();
    cmp.show_max = 0; // Suppress intentional mismatch diagnostic output.
    if (original.compare(changed, cmp))
      `uvm_fatal("SA_METHOD_NEGATIVE", "Deliberately changed output compared equal")
    `uvm_info("SA_METHODS_PASS", "All seven UVM transaction methods exercised", UVM_NONE)
  endtask

  task run_phase(uvm_phase phase);
    sa_sequence seq;
    phase.raise_objection(this);
    exercise_transaction_methods();
    seq=sa_sequence::type_id::create("seq");
    seq.start(sa_env.sa_agent.sa_seqr);
    // Wait until the final three-bit output can be observed and compared.
    repeat (8) @(posedge sa_env.sa_agent.agent_config.m_vif.sig_clock);
    phase.drop_objection(this);
  endtask
endclass
