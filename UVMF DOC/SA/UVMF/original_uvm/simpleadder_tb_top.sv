`include "simpleadder_pkg.sv"
`include "simpleadder.v"
`include "simpleadder_if.sv"
`timescale  10ns/100ps
module simpleadder_tb_top;
 import uvm_pkg::*;
 simpleadder_if vif();
 simpleadder dut( vif.sig_clock ,
      vif.sig_en_i ,
      vif.sig_ina ,
      vif.sig_inb ,
      vif.sig_en_o ,
      vif.sig_out );
 simpleadder_pkg::simpleadder_config    env_config;
 simpleadder_pkg::simpleadder_test    test;
 initial begin
  test       = new( name("test"), .parent(null));
  env_config = new(.name("env_config") );
  if( !env_config.randomize() )
   `uvm_fatal("tb_top", "Fail to randomize config object..");
  env_config.m_vif                  = vif;
  env_config.is_active_sa           = UVM_ACTIVE;
  env_config.checks_enable_sa       = 1;
  env_config.coverage_enable_sa     = 1;
  uvm_config_db#(simpleadder_pkg::simpleadder_config)::set( null    , 
                 "test.*env*"  , 
                 "config"   , 
                 env_config);
  uvm_top.set_config_int("*", "recording_detail", UVM_FULL);
  run_test();
 end
 initial begin
  vif.sig_clock <= 1'b1;
 end
 always
  #5 vif.sig_clock = ~vif.sig_clock;
endmodule