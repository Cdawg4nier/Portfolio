extends Control

var standard_slider_size = Vector2(300, 50)
	
func setup_graphics_tab():
	var graphics_main_vbox_container = VBoxContainer.new()
	graphics_main_vbox_container.name = "Graphics"
	graphics_main_vbox_container.add_child(setup_window_size_graphics_hbox_container())
	graphics_main_vbox_container.add_child(VSplitContainer.new())
	return graphics_main_vbox_container

func setup_window_size_graphics_hbox_container():
	var master_graphics_hbox_container = HBoxContainer.new()
	var master_graphics_label = Label.new()
	var master_graphics_popup_menu = PopupMenu.new()
	master_graphics_hbox_container.add_child(master_graphics_label)
	
	master_graphics_label.text = "Window Size"
	
	master_graphics_label.set_custom_minimum_size(standard_slider_size)
	
	return master_graphics_hbox_container
	
