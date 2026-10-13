//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the sa_in interface signals.
//      It is instantiated once per sa_in bus.  Bus Functional Models, 
//      BFM's named sa_in_driver_bfm, are used to drive signals on the bus.
//      BFM's named sa_in_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(sa_in_bus.en_i), // Agent output 
// .dut_signal_port(sa_in_bus.ina), // Agent output 
// .dut_signal_port(sa_in_bus.inb), // Agent output 

import uvmf_base_pkg_hdl::*;
import sa_in_pkg_hdl::*;

interface  sa_in_if 

  (
  input tri clk, 
  input tri rst_n,
  inout tri  en_i,
  inout tri  ina,
  inout tri  inb
  );

modport monitor_port 
  (
  input clk,
  input rst_n,
  input en_i,
  input ina,
  input inb
  );

modport initiator_port 
  (
  input clk,
  input rst_n,
  output en_i,
  output ina,
  output inb
  );

modport responder_port 
  (
  input clk,
  input rst_n,  
  input en_i,
  input ina,
  input inb
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

