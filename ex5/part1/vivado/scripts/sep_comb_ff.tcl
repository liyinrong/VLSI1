create_project sep_comb_ff . -part xc7z020clg400-1 -force

add_files -norecurse ../sourcecode/fsm_bad.sv ../sourcecode/fsm_good.sv ../sourcecode/fsm_all.sv

update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 8
