create_project bad_generics . -part xc7z020clg400-1 -force

add_files -norecurse ../sourcecode/bad_generics.sv

update_compile_order -fileset sources_1

# launch_runs synth_1 -jobs 8
