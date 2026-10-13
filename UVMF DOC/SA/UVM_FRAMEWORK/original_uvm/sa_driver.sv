class sa_driver extends uvm_driver #(sa_transaction);
  `uvm_component_utils(sa_driver)
  virtual sa_if m_vif;
  clk_data_config drv_config;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(clk_data_config)::get(this,"","config",drv_config))
      `uvm_fatal("DRIVER_CFG","Missing clk_data_config")
    m_vif = drv_config.m_vif;
    if (m_vif == null) `uvm_fatal("DRIVER_VIF","Null virtual interface")
  endfunction
  task run_phase(uvm_phase phase);
    sa_transaction req;
    m_vif.sig_en_i = 0;
    m_vif.sig_ina = 0;
    m_vif.sig_inb = 0;
    forever begin
      seq_item_port.get_next_item(req);
      // DUT consumes at rising edges; present stimulus at falling edges.
      for (int cycle=0; cycle<6; cycle++) begin
        @(negedge m_vif.sig_clock);
        m_vif.sig_en_i <= (cycle == 0);
        m_vif.sig_ina  <= (cycle == 0) ? req.ina[1] :
                          (cycle == 1) ? req.ina[0] : 1'b0;
        m_vif.sig_inb  <= (cycle == 0) ? req.inb[1] :
                          (cycle == 1) ? req.inb[0] : 1'b0;
      end
      // At posedge after cycle 5 the RTL completes its six-cycle operation.
      @(posedge m_vif.sig_clock);
      seq_item_port.item_done();
    end
  endtask
endclass
