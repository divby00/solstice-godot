extends CanvasLayer

var sealed_containers = []

onready var background = $Background
onready var transition = $CircleTransition

func _ready():
	set_process(false)

func _process(_delta):
	for sealed_container in sealed_containers:
		var container = get_node("Background/WasteSprite" + str(sealed_container))
		container.visible = true

func add_container(level_number):
	if not sealed_containers.has(level_number):
		sealed_containers.append(level_number)

func on_nuclear_waste_stored(_storage):
	set_process(true)
	add_container(LevelData.current_level_number)
	background.visible = true
	yield(get_tree().create_timer(.75), "timeout")
	background.visible = false
	set_process(false)
	if LevelData.current_level_number == 8:
		transition.fadeout("ending")

func _on_CircleTransition_fadeout_finished(transition_name):
	if transition_name == "ending":
		get_tree().change_scene_to(ResourceLoader.Ending)
