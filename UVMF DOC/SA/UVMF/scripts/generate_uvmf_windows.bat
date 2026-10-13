@echo off
setlocal
set "UVMF_HOME=C:\UVMF_2023.4"
cd /d "%~dp0..\yaml"
python "%UVMF_HOME%\scripts\yaml2uvmf.py" adder_in_interface.yaml adder_out_interface.yaml adder_predictor.yaml simpleadder_environment.yaml simpleadder_bench.yaml
if errorlevel 1 exit /b 1
echo Generated UVMF files under yaml\uvmf_template_output
endlocal
PAUSE