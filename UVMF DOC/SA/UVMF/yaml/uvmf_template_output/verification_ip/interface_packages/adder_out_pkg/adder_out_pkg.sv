//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <adder_out_typedefs_hdl>
//    - <adder_out_typedefs.svh>
//    - <adder_out_transaction.svh>

//    - <adder_out_configuration.svh>
//    - <adder_out_driver.svh>
//    - <adder_out_monitor.svh>

//    - <adder_out_transaction_coverage.svh>
//    - <adder_out_sequence_base.svh>
//    - <adder_out_random_sequence.svh>

//    - <adder_out_responder_sequence.svh>
//    - <adder_out2reg_adapter.svh>
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
package adder_out_pkg;
  
   import uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import adder_out_pkg_hdl::*;

   `include "uvm_macros.svh"

   // pragma uvmf custom package_imports_additional begin 
   // pragma uvmf custom package_imports_additional end
   `include "src/adder_out_macros.svh"

   export adder_out_pkg_hdl::*;
   
 

   // Parameters defined as HVL parameters

   `include "src/adder_out_typedefs.svh"
   `include "src/adder_out_transaction.svh"

   `include "src/adder_out_configuration.svh"
   `include "src/adder_out_driver.svh"
   `include "src/adder_out_monitor.svh"

   `include "src/adder_out_transaction_coverage.svh"
   `include "src/adder_out_sequence_base.svh"
   `include "src/adder_out_random_sequence.svh"

   `include "src/adder_out_responder_sequence.svh"
   `include "src/adder_out2reg_adapter.svh"

   `include "src/adder_out_agent.svh"

   // pragma uvmf custom package_item_additional begin
   // UVMF_CHANGE_ME : When adding new interface sequences to the src directory
   //    be sure to add the sequence file here so that it will be
   //    compiled as part of the interface package.  Be sure to place
   //    the new sequence after any base sequences of the new sequence.
   // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

