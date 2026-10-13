//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the adder_out interface signals.
//      It is instantiated once per adder_out bus.  Bus Functional Models, 
//      BFM's named adder_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named adder_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(adder_out_bus.sig_en_o), // Agent input 
// .dut_signal_port(adder_out_bus.sig_out), // Agent input 

import uvmf_base_pkg_hdl::*;
import adder_out_pkg_hdl::*;

interface  adder_out_if 

  (
  input tri sig_clock, 
  input tri reset,
  inout tri  sig_en_o,
  inout tri  sig_out
  );

modport monitor_port 
  (
  input sig_clock,
  input reset,
  input sig_en_o,
  input sig_out
  );

modport initiator_port 
  (
  input sig_clock,
  input reset,
  input sig_en_o,
  input sig_out
  );

modport responder_port 
  (
  input sig_clock,
  input reset,  
  output sig_en_o,
  output sig_out
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

