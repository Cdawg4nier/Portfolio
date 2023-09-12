extends PathFollow2D

var elements = {
	Fire = 0,
	Water = 1,
	Electric = 2,
	Earth = 3,
	Poison = 4,
	Ice = 5,
	Acid = 6,
	Radiation = 7,
	Wind = 8,
	elementalLight = 9,
	Shadow = 10,
	Basic = 100
}
var types = {
	Piercing = 0,
	Bludgeoning = 1,
	Slashing = 2,
	Abrasion = 3
}
var ailments = {
	isBurning = false,
	isSoaked = false,
	isElectrocuted = false,
	isDirtied = false,
	isPoisoned = false,
	isFrozen = false,
	isDissolving = false,
	isIrradiated = false,
}

#Vars needed throughout code
var speed
var enemylevel
export var health = 100
var maxHealth
var stealthed
var flying
var isElemental
var attunedElement
var attunedType
var other_enemy_nodes_lightning = []
var other_enemy_nodes_radiation = []
onready var sprite = get_node("Sprite")
var villageDamageMultiplier = 1.0

#Ready
func _ready():
	sprite.play("level_1_dog")
	add_to_group("Enemies")
	get_node("Area2D").add_to_group("EnemyHitbox")
	randomize()
	
	rng.randomize()
	burnSprite.visible = false
	soakedSprite.visible = false
	brittleSprite.visible = false
	poisonSprite.visible = false
	frozenSprite.visible = false
	meltSprite.visible = false
	irradiatedSprite.visible = false
	darkSprite.visible = false
	lightSprite.visible = false
	
#Process
var timer = 0
var distance_to_move = 0
func _process(delta):
	if (canCheckDisorientation && is_disoriented): check_disorientation()
	
	for a in other_enemy_nodes_lightning:
		if (!is_instance_valid(a)):
			other_enemy_nodes_lightning.erase(a)
	for a in other_enemy_nodes_radiation:
		if (!is_instance_valid(a)):
			other_enemy_nodes_radiation.erase(a)
		
		
		
	timer += 1
	#if (timer%100 == 0):
	#	print (health)
	
	wind_speed_multiplier = 1.0
	if (windTimer > 0):
		wind_speed_multiplier = windLevel * -.8
		windTimer -= 1
	distance_to_move = speed*delta*frozenSpeedMultiplier*disoriented_speed_multiplier*wind_speed_multiplier
	distance_to_move *= deepFreezeSpeedMultiplier
	if (distance_to_move + offset < 0): offset = 0
	else: offset += distance_to_move
	
	if (unit_offset == 1.0):
		queue_free()
	if (totalRadDamage == maxHealth*.5): queue_free()
	if (radiationLevel == 5):
		for i in other_enemy_nodes_radiation:
				if (i.totalRadDamage < totalRadDamage): i.irradiate_me_daddy(i,1)
	
#speed, level, health, stealthed, flying, isElemental, attunedElement, attunedType
func set_Data(array := [150.0, 1, 100, false, false, false, "Basic", "Slashing"]):
	speed = array[0]
	enemylevel = array[1]
	health = array[2]
	stealthed = array[3]
	flying = array[4]
	isElemental = array[5]
	attunedElement = elements[array[6]]
	attunedType = types[array[7]]
	
	maxHealth = health
	tempFlying = flying
	tempStealthed = stealthed
	
	
#Deal damage. Incoming values must be a negative number
func update_healthbar(value):
	health += ceil(value * brittleDamageMultiplier*villageDamageMultiplier)
	if (health < 1) : queue_free()
	
#Burning
var isBurning = false
var burningLevel = 0
onready var burnTimer = get_node("Timers/burnTimer")
var burnCountDown = 3
onready var burnSprite = get_node("BurningSprite")
var burn_damage_equation

func burn_me_daddy():
	update_healthbar(burn_damage_equation)
	if (burningLevel != 5): burnCountDown -= 1
	if (burnCountDown == 0):
		isBurning = false
		burnTimer.stop()
		burnSprite.visible = false
		burningLevel = 0

#Soaked
var isSoaked = false
var soakedLevel = 0
onready var soakTimer = get_node("Timers/soakTimer")
var soakedCountDown = 7
onready var soakedSprite = get_node("SoakedSprite")
var tempFlying
var tempStealthed

func soak_me_daddy():
	isSoaked = false
	flying = tempFlying
	stealthed = tempStealthed
	soakTimer.stop()
	soakedSprite.visible = false
	soakedLevel = 0

#Lightning
var rng = RandomNumberGenerator.new()

func zap_me_daddy(level):
	if (isBrittle):
		update_healthbar(level*-5)
		return
	var num_targets = rng.randi_range(3, 5)
	if (num_targets >= other_enemy_nodes_lightning.size()):
		for i in other_enemy_nodes_lightning:
			if (i.isSoaked): 
				i.update_healthbar(level*-2)
			else: i.update_healthbar(level*-1)
	else:
		var targeted_nodes = []
		while (num_targets >=0):
			num_targets -= 1
			var goOn = true
			while(goOn):
				other_enemy_nodes_lightning.shuffle()
				var temp = other_enemy_nodes_lightning[0]
				if (!targeted_nodes.has(temp)):
					goOn = false
					targeted_nodes.append(temp)
		for i in targeted_nodes:
			if (i.isSoaked): i.update_healthbar(level*-2)
			else: i.update_healthbar(level*-1)

#Brittle
var isBrittle = false
var brittleLevel = 0
onready var brittleTimer = get_node("Timers/brittleTimer")
var brittleCountDown = 3
onready var brittleSprite = get_node("BrittleSprite")
var brittleDamageMultiplier = 1.0

func embrittle_me_daddy():
	isBrittle = false
	brittleTimer.stop()
	brittleSprite.visible = false
	brittleDamageMultiplier = 1.0
	brittleLevel = 0

#Poison
var isPoisoned = false
var poisonLevel = 0
onready var poisonTimer = get_node("Timers/poisonTimer")
var poisonCountDown = 3
onready var poisonSprite = get_node("PoisonSprite")
var poisonStacks = 0

func poison_me_daddy():
	update_healthbar(poisonStacks*poisonLevel * -1)
	if (poisonLevel != 5): poisonCountDown -= 1
	if (poisonCountDown == 0):
		isPoisoned = false
		poisonSprite.visible = false
		poisonTimer.stop()
		poisonStacks = 0
		poisonLevel = 0

#Frozen
var isFrozen = false
var frozenLevel = 0
onready var frozenTimer = get_node("Timers/frozenTimer")
onready var frozenSprite = get_node("FrozenSprite")
var frozenSpeedMultiplier = 1.0

func freeze_me_daddy():
	isFrozen = false
	frozenTimer.stop()
	frozenSprite.visible = false
	frozenSpeedMultiplier = 1.0
	frozenLevel = 0

#Acid
var isMelting = false
var acidLevel = 0
onready var meltTimer = get_node("Timers/meltTimer")
var meltCountDown = 3
onready var meltSprite = get_node("MeltingSprite")
var acid_damage_equation

func melt_me_daddy():
	update_healthbar(acid_damage_equation)
	if (acidLevel != 5): meltCountDown -= 1
	if (meltCountDown == 0):
		isMelting= false
		meltTimer.stop()
		meltSprite.visible = false
		acidLevel = 0
		
#Radiation
var isIrradiated = false
var radiationLevel = 0
var totalRadDamage = 0
onready var irradiatedSprite = get_node("IrradiatedSprite")

func irradiate_me_daddy(node, amount):
	node.isIrradiated = true
	node.irradiatedSprite.visible = true
	node.totalRadDamage += amount

#Wind
var windTimer = 0
var windLevel = 0
var wind_speed_multiplier = 1.0
var isWindy = false

#Light and Dark
var isLight = false
var isDark = false
onready var darkSprite = get_node("DarkSprite")
onready var lightSprite = get_node("LightSprite")
onready var disorientedTimer = get_node("Timers/disorientedTimer")
var disoriented_countdown = 3
var disoriented_level = 0
var is_disoriented = false
var disoriented_speed_multiplier = 1.0

func check_disorientation():
	disoriented_speed_multiplier = 1.0
	if (rng.randi_range(1,200) <= disoriented_level):
		disoriented_speed_multiplier = -1.0
		canCheckDisorientation = false
		get_node("Timers/checkDisorientationTimer").start(.2)
	
var canCheckDisorientation = true

func disorient_me_daddy():
	if (disoriented_level != 5): disoriented_countdown -= 1
	if (disoriented_countdown == 0):
		disorientedTimer.stop()
		isDark = false
		isLight = false
		lightSprite.visible = false
		darkSprite.visible = false
		disoriented_level = 0

func heat_shock_me_daddy(damage):
	update_healthbar(-250)
	isBurning = false
	isFrozen = false
	apply_element("Water", burningLevel, damage)
	burningLevel = 0
	frozenLevel = 0
	burnCountDown = 0
	burnTimer.stop()
	frozenTimer.stop()
	burnSprite.visible = false
	frozenSprite.visible = false
	frozenSpeedMultiplier = 1.0
	
func steam_me_daddy(_damage):
	update_healthbar(maxHealth/100*burningLevel*-1*burnCountDown)
	isBurning = false
	burningLevel = 0
	burnCountDown = 0
	burnTimer.stop()
	burnSprite.visible = false
	
var deepFreezeSpeedMultiplier = 1.0
var DeepFrozen = false
onready var deepFreezeTimer = get_node("Timers/deepFreezeTimer")

func deep_freeze_me_daddy():
	DeepFrozen = false
	deepFreezeSpeedMultiplier = 1.0
	
func apply_element(type, level, damage):
	if (type == "Fire"):
		if (!isBurning):
			burnSprite.visible = true
			isBurning = true
			burningLevel = level
			burnCountDown = 3
			burnTimer.start(1.0)
			burn_damage_equation = maxHealth/100*burningLevel*-1
		else:
			burnCountDown = 3
			if (level > burningLevel): burningLevel = level
		if (isSoaked):
			steam_me_daddy(damage)
		if (isFrozen):
			heat_shock_me_daddy(damage)
		if (isMelting):
			burn_damage_equation = maxHealth/100*burningLevel*-2
			acid_damage_equation = maxHealth/50*acidLevel*-3
		else:
			burn_damage_equation = maxHealth/100*burningLevel*-1
			acid_damage_equation = maxHealth/50*acidLevel*-2
	elif (type == "Water"):
		if (!isSoaked):
			soakedSprite.visible = true
			isSoaked = true
			soakedLevel = level
			soakedCountDown = soakedLevel * 4
			soakTimer.start(soakedCountDown)
			flying = false
			stealthed = false
		else:
			if (soakedLevel < level): soakedLevel = level
			if (soakedLevel == 5):
				soakTimer.stop()
				return
			soakTimer.start(soakedLevel*4)
		if (isBurning):
			steam_me_daddy(damage)
		if (isFrozen):
			deepFreezeSpeedMultiplier = 0.0
			if (!DeepFrozen): 
				deepFreezeTimer.start(2)
				DeepFrozen = true
	elif (type == "Electric"):
		zap_me_daddy(level)
	elif (type == "Earth"):
		if (!isBrittle):
			brittleSprite.visible = true
			isBrittle = true
			brittleLevel = level
			brittleCountDown = brittleLevel * 2
			brittleTimer.start(brittleCountDown)
			brittleDamageMultiplier = 1.0 + .2*brittleLevel
		else:
			if (brittleLevel < level): brittleLevel = level
			if (brittleLevel == 5):
				brittleTimer.stop()
				return
			brittleTimer.start(brittleCountDown)
	elif (type == "Poison"):
		if (!isPoisoned):
			poisonSprite.visible = true
			isPoisoned = true
			poisonLevel = level
			poisonStacks = 1
			poisonCountDown = 3
			poisonTimer.start(1.0)
		else:
			poisonStacks += 1
			if (level > poisonLevel): poisonLevel = level
			poisonCountDown = 3
	elif (type == "Ice"):
		if (!isFrozen):
			frozenSprite.visible = true
			isFrozen = true
			frozenLevel = level
			frozenTimer.start(4.0)
			frozenSpeedMultiplier = 1.0 - .1*frozenLevel
		else:
			if (frozenLevel < level): frozenLevel = level
			frozenSpeedMultiplier = 1.0 - .1*frozenLevel
			if (frozenLevel == 5):
				frozenTimer.stop()
				return
			frozenTimer.start(4.0)
		if (isBurning):
			heat_shock_me_daddy(damage)
		if (isSoaked):
			deepFreezeSpeedMultiplier = 0.0
			if (!DeepFrozen): 
				deepFreezeTimer.start(2)
				DeepFrozen = true
	elif (type == "Acid"):
		if (!isMelting):
			meltSprite.visible = true
			isMelting = true
			acidLevel = level
			meltCountDown = 3
			meltTimer.start(1.0)
			acid_damage_equation = maxHealth/50*acidLevel*-2
		else:
			meltCountDown = 3
			if (level > acidLevel): acidLevel = level
		if (isBurning):
			burn_damage_equation = maxHealth/100*burningLevel*-2
			acid_damage_equation = maxHealth/50*acidLevel*-3
		else:
			burn_damage_equation = maxHealth/100*burningLevel*-1
			acid_damage_equation = maxHealth/50*acidLevel*-2
	elif (type == "Radiation"):
		if (!isIrradiated):
			isIrradiated = true
			totalRadDamage += level
			radiationLevel = level
			irradiatedSprite.visible = true
		else:
			if (level > radiationLevel): radiationLevel = level
	elif (type == "Wind"):
		isWindy = true
		windLevel = level
		windTimer = 10
		if (isBurning):
			for i in other_enemy_nodes_radiation:
				i.apply_element("Fire", burningLevel, damage)
		if (isSoaked):
			for i in other_enemy_nodes_radiation:
				i.apply_element("Water", soakedLevel, damage)
		if (isFrozen):
			for i in other_enemy_nodes_radiation:
				i.apply_element("Ice", frozenLevel, damage)
		if (isIrradiated):
			for i in other_enemy_nodes_radiation:
				i.irradiate_me_daddy(i, 1)
	elif (type == "Light"):
		if (!isLight && !isDark):
			isLight = true
			is_disoriented = true
			disoriented_level = level
			disoriented_countdown = 3
			lightSprite.visible = true
			disorientedTimer.start(1.0)
		else:
			if (!isLight): isLight = true
			lightSprite.visible = true
			if (disoriented_level < level): disoriented_level = level
			disoriented_countdown = 3
			if (isDark):
				isDark = false
				darkSprite.visible = false
				update_healthbar(damage*-2)
	elif (type == "Dark"):
		if (!isDark && !isLight):
			isDark = true
			is_disoriented = true
			disoriented_level = level
			darkSprite.visible = true
			disorientedTimer.start(1.0)
		else:
			if (!isDark): isDark = true
			darkSprite.visible = true
			if (disoriented_level < level): disoriented_level = level
			disoriented_countdown = 3
			if (isLight):
				isLight = false
				lightSprite.visible = false
				update_healthbar(damage*-2)
	else:
		print ("Invalid Elemental Type")
	

func _on_LightningArea_area_entered(area):
	if (area.get_parent().get_groups().has("Enemies")): other_enemy_nodes_radiation.append(area.get_parent())
func _on_LightningArea_area_exited(area):
	other_enemy_nodes_lightning.erase(area.get_parent())
func _on_RadiationArea_area_entered(area):
	if (area.get_parent().get_groups().has("Enemies")): other_enemy_nodes_radiation.append(area.get_parent())
func _on_RadiationArea_area_exited(area):
	other_enemy_nodes_radiation.erase(area.get_parent())
func _on_checkDisorientationTimer_timeout():
	canCheckDisorientation = true
	disoriented_speed_multiplier = 1.0
	get_node("Timers/checkDisorientationTimer").stop()
