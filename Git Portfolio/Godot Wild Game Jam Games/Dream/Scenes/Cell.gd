extends Node2D

var am_i_in_body = false

func _ready():
	self.visible = true #false
	var timer = Timer.new()
	self.add_child(timer)
	timer.start(0.1)
	timer.connect("timeout", self, "on_timer_timeout")

func on_timer_timeout():
	if (!am_i_in_body):
		self.queue_free()

func _on_Area2D_area_entered(area):
	am_i_in_body = true


func _on_Area2D_area_exited(area):
	pass
