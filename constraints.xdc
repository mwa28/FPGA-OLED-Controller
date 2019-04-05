# OLED display
set_property PACKAGE_PIN U10  [get_ports {oled_dc}];  # "OLED-DC"
set_property PACKAGE_PIN U9   [get_ports {oled_res}];  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports {oled_sclk}];  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports {oled_sdin}];  # "OLED-SDIN"
set_property PACKAGE_PIN U11  [get_ports {oled_vbat}];  # "OLED-VBAT"
set_property PACKAGE_PIN U12  [get_ports {oled_vdd}];  # "OLED-VDD"

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
