create_project work_in_progress ./ -part xc7z020clg400-1
set_property board_part digilentinc.com:zybo-z7-20:part0:1.0 [current_project]
add_files -scan_for_includes [glob ../sourcecode/*]
add_files -fileset constrs_1 -norecurse ./constraints/zybo-z7.xdc
update_compile_order -fileset sources_1

