`ifndef __SA_TRANSACTION_SVH__
`define __SA_TRANSACTION_SVH__
// One 2-bit input pair and its 3-bit sum; explicit UVM field hooks.
class sa_transaction extends uvm_sequence_item;
  `uvm_object_utils(sa_transaction)
  rand bit [1:0] ina;
  rand bit [1:0] inb;
       bit [2:0] out;

  function new(string name = "sa_transaction");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("ina=%0d (0x%0h) inb=%0d (0x%0h) out=%0d (0x%0h)",
                     ina, ina, inb, inb, out, out);
  endfunction

  // Invoked via destination.copy(source).
  function void do_copy(uvm_object rhs);
    sa_transaction src;
    if (!$cast(src, rhs))
      `uvm_fatal("SA_COPY_TYPE", "rhs is not an sa_transaction")
    super.do_copy(rhs);
    ina = src.ina;
    inb = src.inb;
    out = src.out;
  endfunction

  // Invoked via expected.compare(actual, comparer).
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    sa_transaction other;
    bit matches;
    if (!$cast(other, rhs)) begin
      `uvm_error("SA_COMPARE_TYPE", "rhs is not an sa_transaction")
      return 0;
    end
    matches = super.do_compare(rhs, comparer);
    matches &= comparer.compare_field("ina", ina, other.ina, 2, UVM_DEC);
    matches &= comparer.compare_field("inb", inb, other.inb, 2, UVM_DEC);
    matches &= comparer.compare_field("out", out, other.out, 3, UVM_DEC);
    return matches;
  endfunction

  // Invoked via tx.print() / tx.sprint().
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field_int("ina", ina, 2, UVM_DEC);
    printer.print_field_int("inb", inb, 2, UVM_DEC);
    printer.print_field_int("out", out, 3, UVM_DEC);
  endfunction

  // Invoked via tx.record(recorder), normally after a stream is opened.
  function void do_record(uvm_recorder recorder);
    super.do_record(recorder);
    recorder.record_field("ina", ina, 2, UVM_DEC);
    recorder.record_field("inb", inb, 2, UVM_DEC);
    recorder.record_field("out", out, 3, UVM_DEC);
  endfunction

  // Invoked via pack_bits(), pack_bytes(), or pack_ints().
  // Width/order MUST match do_unpack: 2 + 2 + 3 = 7 bits.
  function void do_pack(uvm_packer packer);
    super.do_pack(packer);
    packer.pack_field_int(ina, 2);
    packer.pack_field_int(inb, 2);
    packer.pack_field_int(out, 3);
  endfunction

  // Invoked via unpack_bits(), unpack_bytes(), or unpack_ints().
  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
    ina = packer.unpack_field_int(2);
    inb = packer.unpack_field_int(2);
    out = packer.unpack_field_int(3);
  endfunction
endclass : sa_transaction
`endif
