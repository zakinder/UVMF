class sa_env extends uvm_env;
  `uvm_component_utils(sa_env)
  sa_config env_config;
  sa_agent sa_agent;
  sa_scoreboard sa_sb;
  function new(string name,uvm_component parent);super.new(name,parent);endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(sa_config)::get(this,"","config",env_config))
      `uvm_fatal("ENV_CFG","Missing sa_config")
    uvm_config_db#(sa_config)::set(this,"sa_agent","config",env_config);
    sa_agent=sa_agent::type_id::create("sa_agent",this);
    sa_sb=sa_scoreboard::type_id::create("sa_sb",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sa_agent.expected_ap.connect(sa_sb.expected_export);
    sa_agent.actual_ap.connect(sa_sb.actual_export);
  endfunction
endclass
