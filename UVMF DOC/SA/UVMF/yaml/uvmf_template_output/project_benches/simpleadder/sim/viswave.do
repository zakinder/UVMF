 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { adder_in_agent }
wave add uvm_test_top.environment.adder_in_agent.adder_in_agent_monitor.txn_stream -radix string -tag F0
wave group adder_in_agent_bus
wave add -group adder_in_agent_bus hdl_top.adder_in_agent_bus.* -radix hexadecimal -tag F0
wave group adder_in_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]
wave spacer -backgroundcolor Salmon { adder_out_agent }
wave add uvm_test_top.environment.adder_out_agent.adder_out_agent_monitor.txn_stream -radix string -tag F0
wave group adder_out_agent_bus
wave add -group adder_out_agent_bus hdl_top.adder_out_agent_bus.* -radix hexadecimal -tag F0
wave group adder_out_agent_bus -collapse
wave insertion [expr [wave index insertpoint] +1]



wave update on
WaveSetStreamView

