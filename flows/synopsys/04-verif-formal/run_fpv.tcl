set_fml_appmode FPV

read_file -top semaforo_fpv -format sverilog -sva \
  { ../../../common/rtl/semaphore/rtl/semaphore.v  semaforo_fpv.sv }

create_clock clk   -period 10
create_reset rst_n -sense low
sim_run -stable
sim_save_reset

check_fv
report_fv -list