// Independent agents: input monitor reports expected transactions;
// output monitor reconstructs serial DUT results.
import "DPI-C" function chandle cl_predict_new(string name);
import "DPI-C" function int cl_predict_set_values_handle(int x,int y,chandle handle);

class sa_input_monitor extends uvm_monitor;
  `uvm_component_utils(sa_input_monitor)
  virtual sa_if m_vif;
  clk_data_config mon_config;
  uvm_analysis_port #(sa_transaction) input_ap;
  chandle hPredict;
  sa_transaction coverage_tx;
  covergroup sa_cg;
    ina_cp: coverpoint coverage_tx.ina;
    inb_cp: coverpoint coverage_tx.inb;
    ab_cross: cross ina_cp,inb_cp;
  endgroup
  function new(string name,uvm_component parent);
    super.new(name,parent);
    input_ap = new("input_ap",this);
    sa_cg = new();
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(clk_data_config)::get(this,"","config",mon_config))
      `uvm_fatal("INPUT_CFG","Missing clk_data_config")
    m_vif = mon_config.m_vif;
    if (m_vif == null) `uvm_fatal("INPUT_VIF","Null virtual interface")
    hPredict = cl_predict_new("serial_adder_predictor");
    if (hPredict == null) `uvm_fatal("DPI","Failed to allocate predictor")
  endfunction
  task run_phase(uvm_phase phase);
    sa_transaction tx;
    int state = 0;
    forever begin
      // Inputs were driven on negedge and are stable at this posedge.
      @(posedge m_vif.sig_clock);
      if (state == 0 && m_vif.sig_en_i) begin
        tx = sa_transaction::type_id::create("input_tx");
        tx.ina = {1'b0,m_vif.sig_ina};
        tx.inb = {1'b0,m_vif.sig_inb};
        state = 1;
      end else if (state == 1) begin
        tx.ina = {tx.ina[0],m_vif.sig_ina};
        tx.inb = {tx.inb[0],m_vif.sig_inb};
        tx.out = cl_predict_set_values_handle(int'(tx.ina),int'(tx.inb),hPredict);
        coverage_tx = tx;
        if (mon_config.coverage_enable) sa_cg.sample();
        // One unique transaction object is allocated per transfer.
        input_ap.write(tx);
        `uvm_info("INPUT_MON",tx.convert2string(),UVM_MEDIUM)
        tx = null;
        state = 0;
      end
    end
  endtask
endclass

class sa_output_monitor extends uvm_monitor;
  `uvm_component_utils(sa_output_monitor)
  virtual sa_if m_vif;
  clk_data_config mon_config;
  uvm_analysis_port #(sa_transaction) output_ap;
  function new(string name,uvm_component parent);
    super.new(name,parent);
    output_ap = new("output_ap",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(clk_data_config)::get(this,"","config",mon_config))
      `uvm_fatal("OUTPUT_CFG","Missing clk_data_config")
    m_vif = mon_config.m_vif;
    if (m_vif == null) `uvm_fatal("OUTPUT_VIF","Null virtual interface")
  endfunction
  task run_phase(uvm_phase phase);
    sa_transaction tx;
    int state = 0;
    forever begin
      // Sample at negedge: RTL posedge nonblocking updates are settled.
      @(negedge m_vif.sig_clock);
      if (state == 0 && m_vif.sig_en_o) begin
        tx = sa_transaction::type_id::create("output_tx");
        tx.out = {m_vif.sig_out,2'b0};
        state = 1;
      end else if (state == 1) begin
        tx.out[1] = m_vif.sig_out;
        state = 2;
      end else if (state == 2) begin
        tx.out[0] = m_vif.sig_out;
        output_ap.write(tx);
        `uvm_info("OUTPUT_MON",tx.convert2string(),UVM_MEDIUM)
        tx = null;
        state = 0;
      end
    end
  endtask
endclass
