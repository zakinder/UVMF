class sa_config extends uvm_object;
  `uvm_object_utils(sa_config)
  virtual sa_if m_vif;
  uvm_active_passive_enum is_active_sa = UVM_ACTIVE;
  bit checks_enable_sa = 1;
  bit coverage_enable_sa = 1;
  function new(string name="sa_config"); super.new(name);endfunction
endclass
class clk_data_config extends uvm_object;
  `uvm_object_utils(clk_data_config)
  virtual sa_if m_vif;
  uvm_active_passive_enum is_active_sa=UVM_ACTIVE;
  bit coverage_enable=1;
  function new(string name="clk_data_config"); super.new(name);endfunction
endclass
