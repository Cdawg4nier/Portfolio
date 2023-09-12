extends "res://Scripts/Curse.gd"

const TIMER_LENGTH = 20;

var typed_word = "";
var target_word = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init().(TIMER_LENGTH, null): # TODO: add sprites
	pass
	

func activate():
	target_word = get_target_word();
	# TODO: load sprite


func process_input(input:InputEvent):
	if input is InputEventKey and input.pressed:
		if input.scancode == KEY_BACKSPACE and typed_word.length() > 0:
			typed_word = typed_word.substr(0, typed_word.length()-1);
		if input.scancode == KEY_ENTER:
			if typed_word == target_word: emit_curse_satisfied();
			else: emit_lose_life();
		else:
			typed_word += char(input.unicode);
	update_typing();


func get_target_word():
	pass # TODO: decide best way to do this


func update_typing():
	pass

