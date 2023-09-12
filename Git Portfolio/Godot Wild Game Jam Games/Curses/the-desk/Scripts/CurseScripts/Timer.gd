extends "res://Scripts/Curse.gd"

const TIMER_LENGTH = 15;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# TODO: position logic?

func _init().(TIMER_LENGTH, null): # TODO: add sprite initialization here
	pass

func activate():
	self.timer.start();
	# TODO: add active sprite
	

func process_input(input:InputEvent):
	if input is InputEventKey and input.pressed: # not final
		if input.scancode == KEY_SPACE: self.flip_timer();
	else:
		self.update_timer_sprite();


func flip_timer():
	timer.stop();
	var flipped_time = TIMER_LENGTH - timer.wait_time;
	timer.start(flipped_time)


func update_timer_sprite():
	pass # TODO: make this...

