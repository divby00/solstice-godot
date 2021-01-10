extends Node

const red_circle_in = preload("res://resources/animated_textures/red_circle_in.tres")
const nuclear_waste_texture = preload("res://scenes/UI/StorageBase/nuclear_waste.png")

onready var help = $UI/Help
onready var player = $Player
onready var panel = $UI/Panel
onready var pause = $UI/Pause
onready var camera = $Camera2D
onready var transition = $UI/Transition
onready var storage_base = $UI/StorageBase
onready var nova = $UI/NovaEffect/TextureRect
onready var animation_player = $AnimationPlayer
onready var bomb_transition = $UI/BombTransition
onready var camera_shake_timer = $CameraShakeTimer
onready var level_change_label = $UI/LevelChange/Label
onready var game_over_transition = $UI/GameOverTransition

var cheats = false
var new_level = null

func _ready():
	help.help_is_posible = false
	set_process(false)
	if GameState.loading:
		var saved_data = GameState.load()
		if saved_data != null:
			load_level(saved_data.level)
	else:
		load_level("01")

func _input(_event):
	if cheats and (Input.is_key_pressed(KEY_KP_ADD) or Input.is_key_pressed(KEY_PLUS)):
		PlayerData.lives += 1
	
	if Input.is_action_just_pressed("screenshot"):
		take_screenshot()

func take_screenshot():
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("res://area_0" + str(LevelData.current_level_number) + ".png")

func load_level(level_key):
	if level_key != "00":
		SoundFx.play("enter_area_" + str(level_key))
	remove_level()
	LevelData.current_level = LevelData.levels[level_key].instance()
	LevelData.current_level_number = int(level_key)
	for i in LevelData.current_level_number:
		storage_base.sealed_containers.append(i + 1)
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
	connect_cheats()

func level_init():
	call_deferred("set_initial_player_position")
	PlayerData.reset_between_levels()
	player.status = PlayerData.Status.OK
	if GameState.loading:
		var saved_game = GameState.load()
		PlayerData.lives = saved_game.lifes
	if LevelData.current_level_number == 1 or LevelData.current_level_number == 0:
		PlayerData.lives = PlayerData.LIVES
	nova.visible = false
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
		level[0].audio_player.stop()
		level[0].queue_free()
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db2linear(0))

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
	# Disconnect evil owls
	var owls = get_tree().get_nodes_in_group("EvilOwlGroup")
	for owl in owls:
		owl.move_timer.stop()
		owl.position_timer.stop()
		
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
		Utils.connect_signal(info_area, "info_area_exited", panel, "on_info_area_exited")

func connect_nuclear_containers():
	var nuclear_containers = get_tree().get_nodes_in_group("NuclearStorageGroup")
	var elevators = get_tree().get_nodes_in_group("ElevatorGroup")
	for nuclear_container in nuclear_containers:
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", elevators[0], "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", player, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", storage_base, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "nuclear_waste_stored", self, "on_nuclear_waste_stored")
		Utils.connect_signal(nuclear_container, "time_tick_finished", panel, "on_time_changed")
		Utils.connect_signal(nuclear_container, "explosion_triggered", self, "on_explosion_triggered")
		nuclear_container.explosion_timer.start()

func connect_player_data():
	Utils.connect_signal(PlayerData, "health_changed", panel, "on_health_changed")
	Utils.connect_signal(PlayerData, "plasma_changed", panel, "on_plasma_changed")
	Utils.connect_signal(PlayerData, "lives_changed", panel, "on_lives_changed")
	Utils.connect_signal(PlayerData, "thrust_changed", panel, "on_thrust_changed")
	Utils.connect_signal(PlayerData, "laser_changed", panel, "on_laser_changed")
	Utils.connect_signal(PlayerData, "time_changed", panel, "on_time_changed")
	Utils.connect_signal(PlayerData, "player_destroyed", player, "on_player_destroyed")
	Utils.connect_signal(player, "item_picked", panel, "on_item_picked")
	Utils.connect_signal(player, "item_used", player, "on_item_used")
	Utils.connect_signal(player, "item_used", panel, "on_item_used")
	Utils.connect_signal(player, "player_game_over", self, "on_game_over")
	Utils.connect_signal(player, "player_damaged", self, "on_player_damaged")
	Utils.connect_signal(player, "player_activated_elevator", self, "on_player_activated_elevator")
	Utils.connect_signal(player, "player_invincible", self, "on_player_invincible")
	Utils.connect_signal(player, "player_not_invincible", self, "on_player_not_invincible")
	Utils.connect_signal(player, "player_activated_bomb", self, "on_player_activated_bomb")

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

func connect_cheats():
	Utils.connect_signal(pause, "cheats_activated", self, "on_cheats_activated")

func on_nuclear_waste_stored(_storage):
	if LevelData.current_level_number == 1:
		var sprite = Sprite.new()
		sprite.name = "CustomNuclearWaste"
		sprite.texture = nuclear_waste_texture
		sprite.global_position = Vector2(64, 328)
		get_tree().current_scene.add_child(sprite)

func on_player_activated_elevator(level_pass):
	if has_node("CustomNuclearWaste"):
		get_node("CustomNuclearWaste").queue_free()
	if level_pass != null:
		new_level = level_pass.substr(4, 2)
	else:
		new_level = "0" + str(LevelData.current_level_number + 1)
	PlayerData.selected_item = null
	transition.fadeout()

func on_player_damaged():
	set_process(true)
	camera_shake_timer.start()

func on_player_activated_bomb():
	SoundFx.play("explosion")
	set_process(true)
	camera_shake_timer.start()
	bomb_transition.fadein()

	var spawners = get_tree().get_nodes_in_group("SpawnerGroup")
	for spawner in spawners:
		if spawner.global_position.distance_to(player.global_position) < 300:
			spawner.ready = false
			spawner.timer.stop()
			spawner.timer.wait_time = rand_range(4, 10)
			spawner.timer.start()

	var enemies = get_tree().get_nodes_in_group("EnemyGroup")
	for enemy in enemies:
		if enemy.global_position.distance_to(player.global_position) < 300:
			if enemy.has_node("Hurtbox"):
				enemy.hurtbox.health = 0

func _on_CameraShakeTimer_timeout():
	camera.offset_h = 0
	camera.offset_v = 0
	set_process(false)

func _process(_delta):
	camera.offset_h = rand_range(-.05, .05)
	camera.offset_v = rand_range(-.05, .05)

func _on_Transition_fadeout_finished(_transition_name):
	GameState.save({"level": new_level, "lifes": PlayerData.lives})
	load_level(new_level)

func on_game_over():
	game_over_transition.fadeout()
	
func _on_GameOverTransition_fadeout_finished(_transition_name):
	PlayerData.reset()
	player.status = PlayerData.Status.OK
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(ResourceLoader.GameOver)

func on_explosion_triggered():
	set_process(false)
	transition.circle_in = red_circle_in
	transition.fadein("explosion")

func _on_Transition_fadein_finished(transition_name):
	help.help_is_posible = true
	if transition_name == "explosion":
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(ResourceLoader.TimeOver)

func on_cheats_activated():
	cheats = true

func on_player_invincible():
	nova.visible = true

func on_player_not_invincible():
	nova.visible = false
