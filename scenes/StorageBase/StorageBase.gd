extends CanvasLayer

var sealed_containers = []

onready var background = $Background

func _process(delta):
	for sealed_container in sealed_containers:
		var container = get_node("Background/WasteSprite" + str(sealed_container))
		container.visible = true

func add_container(level_number):
	if not sealed_containers.has(level_number):
		sealed_containers.append(level_number)

func on_nuclear_waste_stored(storage):
	add_container(LevelData.current_level_number)
	background.visible = true
	yield(get_tree().create_timer(.75), "timeout")
	background.visible = false