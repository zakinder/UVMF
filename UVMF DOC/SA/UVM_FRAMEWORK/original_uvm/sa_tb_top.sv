`timescale 1ns/1ps
`include "sa_if.sv"
`include "sa_pkg.sv"
module sa_tb_top;
  import uvm_pkg::*;
  import sa_pkg::*;
  sa_if vif();
  sa dut(.clk(vif.sig_clock),.en_i(vif.sig_en_i),.ina(vif.sig_ina),
                  .inb(vif.sig_inb),.en_o(vif.sig_en_o),.result_o(vif.sig_out));
  initial begin
    sa_config cfg;
    cfg=sa_config::type_id::create("cfg");
    cfg.m_vif=vif;
    cfg.is_active_sa=UVM_ACTIVE;
    cfg.checks_enable_sa=1;
    cfg.coverage_enable_sa=1;
    uvm_config_db#(sa_config)::set(null,"uvm_test_top.sa_env","config",cfg);
    run_test("sa_test");
  end
  initial vif.sig_clock=0;
  always #5 vif.sig_clock=~vif.sig_clock;
endmodule
