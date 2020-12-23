extends Node

const nuclear_waste_texture = preload("res://scenes/StorageBase/nuclear_waste.png")

onready var player = $Player
onready var camera = $Camera2D
onready var panel = $UI/Panel
onready var transition = $Transition
onready var game_over_transition = $GameOverTransition
onready var storage_base = $StorageBase
onready var camera_shake_timer = $CameraShakeTimer
onready var level_change_label = $LevelChange/Label
onready var animation_player = $AnimationPlayer

var new_level = null

func _ready():
	set_process(false)
	load_level("00")
	
func load_level(level_key):
	if level_key != "00":
		SoundFx.play("enter_area_" + str(level_key))
	remove_level()
	LevelData.current_level = LevelData.levels[level_key].instance()
	LevelData.current_level_number = int(level_key)
	set_camera_limits(LevelData.current_level)
	get_tree().current_scene.add_child_below_node(camera, LevelData.current_level, false)
	connect_signals()
	level_init()

func connect_signals():
	connect_items()
	connect_teleporters()
	connect_teleporter_pass_dispatchers()
	connect_info_areas()
	connect_nuclear_containers()
	connect_locks()
	connect_player_data()
	connect_enemies()
	connect_rails()
	connect_elevator()

func level_init():
	call_deferred("set_initial_player_position")
	PlayerData.reset_between_levels()
	panel.init_panel()
	transition.fadein()
	level_change_label.text = "Area " + str(LevelData.current_level_number)
	animation_player.play("new_area")

func remove_level():
	var level = get_tree().get_nodes_in_group("LevelGroup")
	if level.size() > 0:
		remove_items()
		remove_spawners()
		remove_enemies()
		level[0].queue_free()

func remove_spawners():
	var spawners = get_tree().get_nodes_in_group("SpawnerGroup")
	for spawner in spawners:
		spawner.queue_free()
	var parent_spawners = get_tree().get_nodes_in_group("ParentSpawnerGroup")
	for parent_spawner in parent_spawners:
		parent_spawner.queue_free()

func remove_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		item.queue_free()

func remove_enemies():
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		enemy.queue_free()

func connect_items():
	var items = get_tree().get_nodes_in_group("ItemGroup")
	for item in items:
		Utils.connect_signal(item, "item_picked", player, "on_item_picked")

func connect_locks():
	var locks = get_tree().get_nodes_in_group("LockGroup")
	for lock in locks:
		Utils.connect_signal(lock, "lock_opened", player, "on_lock_opened")

func connect_teleporters():
	var teleporter_groups = get_tree().get_nodes_in_group("TeleporterGroup")
	for teleporter_group in teleporter_groups:
		Utils.connect_signal(teleporter_group, "teleporter_charged", player, "on_teleporter_charged")
		Utils.connect_signal(teleporter_group, "teleporter_activated", player, "on_teleporter_activated")

func connect_teleporter_pass_dispatchers():
	var dispatchers = get_tree().get_nodes_in_group("TeleporterPassDispatcherGroup")
	for dispatcher in dispatchers:
		Utils.connect_signal(dispatcher, "pass_dispatched", player, "on_pass_dispatched")

func connect_info_areas():
	var info_areas = get_tree().get_nodes_in_group("InfoAreaGroup")
	for info_area in info_areas:
		Utils.connect_signal(info_area, "info_area_entered", panel, "on_info_area_entered")

func connect_nuclear_containers():
	var nuclear_containers = get_tree().get_nodes_in_group("NuclearStorageGroup")
	for nuclear_container in nuclear_containers:
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", player, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", storage_base, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", self, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "time_tick_finished", panel, "on_time_changed")
		Utils.connect_signal(nuclear_container, "explosion_triggered", player, "on_explosion_triggered")
		nuclear_container.explosion_timer.start()

func connect_player_data():
	Utils.connect_signal(PlayerData, "health_changed", panel, "on_health_changed")
	Utils.connect_signal(PlayerData, "lives_changed", panel, "on_lives_changed")
	Utils.connect_signal(PlayerData, "thrust_changed", panel, "on_thrust_changed")
	Utils.connect_signal(PlayerData, "laser_changed", panel, "on_laser_changed")
	Utils.connect_signal(PlayerData, "time_changed", panel, "on_time_changed")
	Utils.connect_signal(PlayerData, "player_destroyed", player, "on_player_destroyed")
	Utils.connect_signal(PlayerData, "status_changed", player, "on_status_changed")
	Utils.connect_signal(player, "item_picked", panel, "on_item_picked")
	Utils.connect_signal(player, "item_used", player, "on_item_used")
	Utils.connect_signal(player, "item_used", panel, "on_item_used")
	Utils.connect_signal(player, "player_game_over", self, "on_game_over")
	Utils.connect_signal(player, "player_damaged", self, "on_player_damaged")
	Utils.connect_signal(player, "player_activated_elevator", self, "on_player_activated_elevator")

func set_camera_limits(level):
	camera.limit_left = level.camera_limit_left
	camera.limit_top = level.camera_limit_top - 32
	camera.limit_right = level.camera_limit_right
	camera.limit_bottom = level.camera_limit_bottom + 16
	
func set_initial_player_position():
	var start_position = LevelData.current_level.get_node("StartPosition")
	player.global_position = start_position.global_position

func connect_enemies():
	var spawners = LevelData.current_level.get_node("Spawners")
	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		Utils.connect_signal(enemy, "enemy_attacked", player, "on_enemy_attacked")
		Utils.connect_signal(enemy, "enemy_died", spawners, "on_enemy_died")

func connect_rails():
	var rails = get_tree().get_nodes_in_group("RailGroup")
	for rail in rails:
		Utils.connect_signal(rail, "player_has_to_move", player, "on_player_has_to_move")

func connect_elevator():
	var elevators = get_tree().get_nodes_in_group("ElevatorGroup")
	for elevator in elevators:
		Utils.connect_signal(elevator, "elevator_activated", player, "on_elevator_activated")

func on_nuclear_waste_stored(_storage):
	if LevelData.current_level_number == 1:
		var sprite = Sprite.new()
		sprite.name = "CustomNuclearWaste"
		sprite.texture = nuclear_waste_texture
		sprite.global_position = Vector2(64, 328)
		owner.add_child(sprite)
		#get_tree().current_scene.add_child(sprite)

func on_player_activated_elevator(level_pass):
	if has_node("CustomNuclearWaste"):
		get_node("CustomNuclearWaste").queue_free()
	new_level = level_pass.substr(4, 2)
	PlayerData.selected_item = null
	transition.fadeout()

func on_player_damaged():
	set_process(true)
	camera_shake_timer.start()

func _on_CameraShakeTimer_timeout():
	camera.offset_h = 0
	camera.offset_v = 0
	set_process(false)

func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		if not OS.window_fullscreen:
			OS.window_size = Vector2(1024, 768)

func _process(_delta):
	camera.offset_h = rand_range(-.03, .03)
	camera.offset_v = rand_range(-.03, .03)

func _on_Transition_fadeout_finished(_transition_name):
	load_level(new_level)

func on_game_over():
	game_over_transition.fadeout()
	
func _on_GameOverTransition_fadeout_finished(transition_name):
	PlayerData.reset()
	get_tree().change_scene("res://scenes/GameOver/GameOver.tscn")
