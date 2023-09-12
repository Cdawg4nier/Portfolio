extends PathFollow2D

var first_enemy = preload("res://Scenes/Enemies/BasicEnemy.tscn").instance()


func _ready():
	first_enemy.set_Data()
	add_child(first_enemy)
	print (first_enemy.get_parent())
	

func _process(delta):
	offset += first_enemy.get_speed()
	
