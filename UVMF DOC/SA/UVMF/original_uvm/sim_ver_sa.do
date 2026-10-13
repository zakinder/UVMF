# Launch after building the DPI shared library and setting PREDICT_LIB.
do compile_sa.do
if {![info exists PREDICT_LIB]} {
  echo "ERROR: set PREDICT_LIB to the C++ DPI shared-library path (without extension)"
} else {
  vsim -c -sv_lib $PREDICT_LIB work.sa_tb_top +UVM_TESTNAME=sa_test
  run -all
  quit -sim
}
