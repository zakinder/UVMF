@echo off
setlocal
set "UVMF_HOME=C:\UVMF_2023.4"
if "%UVMF_HOME%"=="" (echo UVMF_HOME is not set & exit /b 1)
cd /d "%~dp0..\yaml"
python "%UVMF_HOME%\scripts\yaml2uvmf.py" sa_in_interface.yaml sa_out_interface.yaml sa_environment.yaml sa_bench.yaml
if errorlevel 1 exit /b 1
echo Generated output should be under yaml\uvmf_template_output
