set C_TypeInfoList {{ 
"filter_hls" : [[], { "return": [[], "void"]} , [{"ExternC" : 0}], [ {"data_in": [[],{ "pointer": "0"}] }, {"data_out": [[],{ "pointer": "1"}] }],[],""], 
"0": [ "pixel_t", {"typedef": [[[],"2"],""]}], 
"1": [ "pixel_t", {"typedef": [[[],"2"],""]}], 
"2": [ "", {"struct": [[],[],[{ "r": [[8], "3"]},{ "g": [[8], "3"]},{ "b": [[8], "3"]}],""]}], 
"3": [ "channel_t", {"typedef": [[[],"4"],""]}], 
"4": [ "ap_uint<8>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 8}}]],""]}}]
}}
set moduleName filter_hls
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {filter_hls}
set C_modelType { void 0 }
set C_modelArgList {
	{ data_in int 24 regular {axi_s 0 volatile  { data_in Data } }  }
	{ data_out int 24 regular {axi_s 1 ""  { data_out Data } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "data_in", "interface" : "axis", "bitwidth" : 24, "direction" : "READONLY", "bitSlice":[{"low":0,"up":7,"cElement": [{"cName": "data_in.r.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]},{"low":8,"up":15,"cElement": [{"cName": "data_in.g.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]},{"low":16,"up":23,"cElement": [{"cName": "data_in.b.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "data_out", "interface" : "axis", "bitwidth" : 24, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":7,"cElement": [{"cName": "data_out.r.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]},{"low":8,"up":15,"cElement": [{"cName": "data_out.g.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]},{"low":16,"up":23,"cElement": [{"cName": "data_out.b.V","cData": "uint8","bit_use": { "low": 0,"up": 7},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 12
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ data_in_TDATA sc_in sc_lv 24 signal 0 } 
	{ data_in_TVALID sc_in sc_logic 1 invld 0 } 
	{ data_in_TREADY sc_out sc_logic 1 inacc 0 } 
	{ data_out_TDATA sc_out sc_lv 24 signal 1 } 
	{ data_out_TVALID sc_out sc_logic 1 outvld 1 } 
	{ data_out_TREADY sc_in sc_logic 1 outacc 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "data_in_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "data_in", "role": "TDATA" }} , 
 	{ "name": "data_in_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "data_in", "role": "TVALID" }} , 
 	{ "name": "data_in_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "data_in", "role": "TREADY" }} , 
 	{ "name": "data_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":24, "type": "signal", "bundle":{"name": "data_out", "role": "TDATA" }} , 
 	{ "name": "data_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "data_out", "role": "TVALID" }} , 
 	{ "name": "data_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "data_out", "role": "TREADY" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6"],
		"CDFG" : "filter_hls",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"Port" : [
			{"Name" : "data_in", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "data_in_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "data_out", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "data_out_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "window_r_V_0_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_0_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_0_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_r_V_1_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_1_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_1_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_r_V_2_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_2_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_2_2", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "lines_r_V_0", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lines_g_V_0", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lines_b_V_0", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lines_r_V_1", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lines_g_V_1", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "lines_b_V_1", "Type" : "Memory", "Direction" : "IO"},
			{"Name" : "window_r_V_0_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_0_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_0_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_r_V_1_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_1_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_1_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_r_V_2_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_g_V_2_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "window_b_V_2_1", "Type" : "OVld", "Direction" : "IO"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_r_V_0_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_g_V_0_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_b_V_0_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_r_V_1_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_g_V_1_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.lines_b_V_1_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	filter_hls {
		data_in {Type I LastRead 1 FirstWrite -1}
		data_out {Type O LastRead -1 FirstWrite 6}
		window_r_V_0_2 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_0_2 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_0_2 {Type IO LastRead -1 FirstWrite -1}
		window_r_V_1_2 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_1_2 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_1_2 {Type IO LastRead -1 FirstWrite -1}
		window_r_V_2_2 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_2_2 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_2_2 {Type IO LastRead -1 FirstWrite -1}
		lines_r_V_0 {Type IO LastRead -1 FirstWrite -1}
		lines_g_V_0 {Type IO LastRead -1 FirstWrite -1}
		lines_b_V_0 {Type IO LastRead -1 FirstWrite -1}
		lines_r_V_1 {Type IO LastRead -1 FirstWrite -1}
		lines_g_V_1 {Type IO LastRead -1 FirstWrite -1}
		lines_b_V_1 {Type IO LastRead -1 FirstWrite -1}
		window_r_V_0_1 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_0_1 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_0_1 {Type IO LastRead -1 FirstWrite -1}
		window_r_V_1_1 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_1_1 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_1_1 {Type IO LastRead -1 FirstWrite -1}
		window_r_V_2_1 {Type IO LastRead -1 FirstWrite -1}
		window_g_V_2_1 {Type IO LastRead -1 FirstWrite -1}
		window_b_V_2_1 {Type IO LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2076608", "Max" : "2076608"}
	, {"Name" : "Interval", "Min" : "2076609", "Max" : "2076609"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	data_in { axis {  { data_in_TDATA in_data 0 24 }  { data_in_TVALID in_vld 0 1 }  { data_in_TREADY in_acc 1 1 } } }
	data_out { axis {  { data_out_TDATA out_data 1 24 }  { data_out_TVALID out_vld 1 1 }  { data_out_TREADY out_acc 0 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
