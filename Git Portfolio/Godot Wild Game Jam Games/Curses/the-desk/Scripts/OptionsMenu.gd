extends Control

var static_access_main_container
var static_access_tab_container

var audio_tab = preload("res://Scenes/OptionsMenuPieces/AudioTab.tscn")
var graphics_tab = preload("res://Scenes/OptionsMenuPieces/GraphicsTab.tscn")

var standard_button_size = Vector2(300, 50) 

func _ready():
	setup_options_menu()

func _process(delta):
	pass

func setup_options_menu():
	setup_main_container()
	setup_tab_container()
	
func setup_main_container():
	var main_container = CenterContainer.new()
	main_container.anchor_left = 0
	main_container.anchor_right = 1
	main_container.anchor_top = 0
	main_container.anchor_bottom = 1
	static_access_main_container = main_container
	self.add_child(main_container)
	
func setup_tab_container():
	var tab_container = TabContainer.new()
	static_access_tab_container = tab_container
	static_access_main_container.add_child(tab_container)
	
	instance_audio_tab()
	instance_graphics_tab()
	
func instance_audio_tab():
	audio_tab = audio_tab.instance()
	static_access_tab_container.add_child(audio_tab.setup_audio_tab())
	
func instance_graphics_tab():
	graphics_tab = graphics_tab.instance()
	static_access_tab_container.add_child(graphics_tab.setup_graphics_tab())
