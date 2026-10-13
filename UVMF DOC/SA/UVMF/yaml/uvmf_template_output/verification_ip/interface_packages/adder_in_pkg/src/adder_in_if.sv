//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the adder_in interface signals.
//      It is instantiated once per adder_in bus.  Bus Functional Models, 
//      BFM's named adder_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named adder_in_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(adder_in_bus.sig_en_i), // Agent output 
// .dut_signal_port(adder_in_bus.sig_ina), // Agent output 
// .dut_signal_port(adder_in_bus.sig_inb), // Agent output 

import uvmf_base_pkg_hdl::*;
import adder_in_pkg_hdl::*;

interface  adder_in_if 

  (
  input tri sig_clock, 
  input tri reset,
  inout tri  sig_en_i,
  inout tri  sig_ina,
  inout tri  sig_inb
  );

modport monitor_port 
  (
  input sig_clock,
  input reset,
  input sig_en_i,
  input sig_ina,
  input sig_inb
  );

modport initiator_port 
  (
  input sig_clock,
  input reset,
  output sig_en_i,
  output sig_ina,
  output sig_inb
  );

modport responder_port 
  (
  input sig_clock,
  input reset,  
  input sig_en_i,
  input sig_ina,
  input sig_inb
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

