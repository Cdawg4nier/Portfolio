extends Control


var static_access_main_container
var static_access_vbox_container
onready var menu_node = get_node("Menus")

var standard_button_size = Vector2(300, 100) 

func _ready():
	setup_main_menu()

func _process(delta):
	pass

func setup_main_menu():
	setup_main_container()
	setup_vbox_container()
	setup_start_button()
	setup_options_button()
	setup_quit_button()
	
func setup_main_container():
	var main_container = CenterContainer.new()
	main_container.anchor_left = 0
	main_container.anchor_right = 1
	main_container.anchor_top = 0
	main_container.anchor_bottom = 1
	static_access_main_container = main_container
	menu_node.add_child(main_container)

func setup_vbox_container():
	var vbox_container = VBoxContainer.new()
	static_access_vbox_container = vbox_container
	static_access_main_container.add_child(vbox_container)

func setup_start_button():
	var start_button = Button.new()
	start_button.text = "Start Button"
	start_button.connect("pressed", self, "on_start_button_pressed")
	start_button.set_custom_minimum_size(standard_button_size)
	static_access_vbox_container.add_child(start_button)
	
func setup_options_button():
	var options_button = Button.new()
	options_button.text = "Options Button"
	options_button.connect("pressed", self, "on_options_button_pressed")
	options_button.set_custom_minimum_size(standard_button_size)
	static_access_vbox_container.add_child(options_button)
	
func setup_quit_button():
	var quit_button = Button.new()
	quit_button.text = "Quit Button"
	quit_button.connect("pressed", self, "on_quit_button_pressed")
	quit_button.set_custom_minimum_size(standard_button_size)
	static_access_vbox_container.add_child(quit_button)
	
func testing_code():
	var color_panel = ColorRect.new()
	color_panel.color = Color.aquamarine
	color_panel.set_custom_minimum_size (Vector2(100, 100))
	#static_access_main_container.add_child(color_panel)
	
func on_start_button_pressed():
	static_access_main_container.hide()
	#set_process_input(false)
	#TODO: Start the game
	
func on_options_button_pressed():
	print ("Options button pressed")
	#TODO: Suspend the start menu, enable the Options menu variant 1

func on_quit_button_pressed():
	get_tree().quit()
