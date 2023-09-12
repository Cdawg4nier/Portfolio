extends Node2D

signal lose_life;
signal curse_satisfied;

var timer = null;
var timer_length = 0;
var curse_sprite = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func _init(timer_length:int, sprite):
	self.timer = Timer.new();
	self.timer_length = timer_length;
	self.initialize_timer();
	self.curse_sprite = sprite;

func emit_lose_life():
	emit_signal("lose_life");

	
func emit_curse_satisfied():
	emit_signal("curse_satisfied");


func initialize_timer():
	self.timer.wait_time = timer_length;
	self.timer.one_shot = true;


func activate():
  pass


func process_input(input:InputEvent):
  pass


func _on_timer_timeout():
	emit_lose_life();
	self.initialize_timer();



