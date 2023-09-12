extends Node2D

export var max_health = 1000
var health = max_health
var cleaning_amount
export var type = 1


var ailment_texture_1 = preload("res://Assets/Game/ailment_1.png")
var ailment_texture_2 = preload("res://Assets/Game/ailment_2.png")
var ailment_texture_3 = preload("res://Assets/Game/ailment_3.png")
var ailment_texture_4 = preload("res://Assets/Game/ailment_4.png")

#Ailment 1 is "Relax"
#Ailment 2 is "Clean / Disinfect"
#Ailment 3 is "Replenish"
#Ailment 4 is "Focus Repairs"


func _ready():
	setup_ailment()
	health = max_health
	
func setup_ailment():
	match type:
		1:
			$Sprite.texture = ailment_texture_1
			$Area2D.set_collision_layer_bit(0, true)
			minimum_pixel_threshold = 5
			maximum_pixel_threshold = 35
			cleaning_amount = 10.0
		2:
			$Sprite.texture = ailment_texture_2
			$Area2D.set_collision_layer_bit(1, true)
			minimum_pixel_threshold = 20
			maximum_pixel_threshold = 50
			cleaning_amount = 20.0
			
		3:
			$Sprite.texture = ailment_texture_3
			$Area2D.set_collision_layer_bit(2, true)
			minimum_pixel_threshold = 2
			maximum_pixel_threshold = 15
			cleaning_amount = 8.0
		4:
			$Sprite.texture = ailment_texture_4
			$Area2D.set_collision_layer_bit(3, true)
			minimum_pixel_threshold = 0
			maximum_pixel_threshold = 5
			cleaning_amount = 5.0

var can_check = false
var prev_mouse_pos = Vector2.ZERO
var minimum_pixel_threshold
var maximum_pixel_threshold

func _process(_delta):
	var current_mouse_pos = get_global_mouse_position()
	if (can_check and $Area2D.is_monitorable()):
		var mouse_delta = current_mouse_pos.distance_squared_to(prev_mouse_pos)
		if (mouse_delta >= pow(minimum_pixel_threshold, 2) and mouse_delta <= pow(maximum_pixel_threshold, 2)):
			if Input.is_action_pressed("left_click"):
				health -= cleaning_amount
	if (health <= max_health*.2): queue_free()
	prev_mouse_pos = current_mouse_pos
	self.set_modulate(Color(1, 1, 1, (health / max_health)))


func _on_Area2D_area_entered(_area):
	can_check = true


func _on_Area2D_area_exited(_area):
	can_check = false
