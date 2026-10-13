class sa_agent extends uvm_agent;
  `uvm_component_utils(sa_agent)
  sa_config agent_config;
  sa_sequencer sa_seqr;
  sa_driver sa_drvr;
  sa_input_monitor input_mon;
  sa_output_monitor output_mon;
  uvm_analysis_port #(sa_transaction) expected_ap;
  uvm_analysis_port #(sa_transaction) actual_ap;
  function new(string name,uvm_component parent);
    super.new(name,parent);
    expected_ap=new("expected_ap",this);
    actual_ap=new("actual_ap",this);
  endfunction
  function void build_phase(uvm_phase phase);
    clk_data_config cfg;
    super.build_phase(phase);
    if (!uvm_config_db#(sa_config)::get(this,"","config",agent_config))
      `uvm_fatal("AGENT_CFG","Missing sa_config")
    if (agent_config.m_vif==null) `uvm_fatal("AGENT_VIF","Null vif")
    cfg=new("cfg");
    cfg.m_vif=agent_config.m_vif;
    cfg.is_active_sa=agent_config.is_active_sa;
    cfg.coverage_enable=agent_config.coverage_enable_sa;
    uvm_config_db#(clk_data_config)::set(this,"input_mon","config",cfg);
    uvm_config_db#(clk_data_config)::set(this,"output_mon","config",cfg);
    input_mon=sa_input_monitor::type_id::create("input_mon",this);
    output_mon=sa_output_monitor::type_id::create("output_mon",this);
    if (agent_config.is_active_sa==UVM_ACTIVE) begin
      uvm_config_db#(clk_data_config)::set(this,"sa_drvr","config",cfg);
      sa_seqr=sa_sequencer::type_id::create("sa_seqr",this);
      sa_drvr=sa_driver::type_id::create("sa_drvr",this);
    end
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    input_mon.input_ap.connect(expected_ap);
    output_mon.output_ap.connect(actual_ap);
    if (sa_drvr!=null) sa_drvr.seq_item_port.connect(sa_seqr.seq_item_export);
  endfunction
endclass
