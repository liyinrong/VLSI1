create_project inferred_latch . -part xc7z020clg400-1 -force

add_files -norecurse ../sourcecode/panel_mux_prim.sv

update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 8
