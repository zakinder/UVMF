//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the sa_out interface signals.
//      It is instantiated once per sa_out bus.  Bus Functional Models, 
//      BFM's named sa_out_driver_bfm, are used to drive signals on the bus.
//      BFM's named sa_out_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(sa_out_bus.en_o), // Agent input 
// .dut_signal_port(sa_out_bus.result_o), // Agent input 

import uvmf_base_pkg_hdl::*;
import sa_out_pkg_hdl::*;

interface  sa_out_if 

  (
  input tri clk, 
  input tri rst_n,
  inout tri  en_o,
  inout tri  result_o
  );

modport monitor_port 
  (
  input clk,
  input rst_n,
  input en_o,
  input result_o
  );

modport initiator_port 
  (
  input clk,
  input rst_n,
  input en_o,
  input result_o
  );

modport responder_port 
  (
  input clk,
  input rst_n,  
  output en_o,
  output result_o
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

