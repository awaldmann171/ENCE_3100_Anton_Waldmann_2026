create_clock -name manual_clock -period 20.000 [get_ports {KEY[1]}]

derive_clock_uncertainty

set_false_path -from [get_ports {KEY[0]}]

set_false_path -from [get_ports {SW[*]}]

set_false_path -to [get_ports {LEDR[*]}]