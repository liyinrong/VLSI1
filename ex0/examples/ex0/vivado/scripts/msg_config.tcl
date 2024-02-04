# Demote warnings on type mismatches between pins to information.
set_msg_config -id {BD 41-1731} -new_severity {INFO}
# Demote warnings on single pins of an interface being manually connected to information.
set_msg_config -id {BD 41-1306} -new_severity {INFO}
# Demote warnings on pin properties inherited from connected IPs to information.
set_msg_config -id {BD 41-927} -new_severity {INFO}
