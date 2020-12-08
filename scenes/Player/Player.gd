extends KinematicBody2D

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var particles : CPUParticles2D = $Particles

export(int) var ACCELERATION = 400
export(int) var MAX_SPEED = 80
export(int) var GRAVITY = 150
export(float) var FRICTION = .2

signal item_picked(item)
signal item_used

enum Facing {
	LEFT, RIGHT
}

var motion = Vector2.ZERO
var facing = Facing.RIGHT
var is_in_magnetic_area = false

var player_stats = ResourceLoader.player_stats
var item_definitions = ResourceLoader.item_defs.definitions

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_vertical_force(input_vector, delta)
	apply_friction(input_vector)
	apply_gravity(delta)
	update_animation(input_vector)
	motion = move_and_slide(motion, Vector2.UP)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.get_action_strength("ui_up"):
		input_vector.y = -1
		particles.emitting = true
	else:
		particles.emitting = false
	return input_vector

func apply_horizontal_force(input_vector, delta):
	if input_vector != Vector2.ZERO:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_vertical_force(input_vector, delta):
	if not is_in_magnetic_area:
		motion.y += input_vector.y * ACCELERATION * delta
		motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	else:
		motion.y -= ACCELERATION * delta
		motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector == Vector2.ZERO && is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)

func apply_gravity(delta):
	if !is_on_floor() and !is_in_magnetic_area:
		motion.y += GRAVITY * delta

func update_animation(input_vector):
	var current_animation = animation_player.current_animation
	if input_vector.x < 0:
		facing = Facing.LEFT
		animation_player.play_backwards(current_animation)
	elif input_vector.x > 0:
		facing = Facing.RIGHT
		animation_player.play(current_animation)

func on_player_over_item(item):
	if Input.is_action_just_pressed("ui_down"):
		if player_stats.selected_item != null:
			create_new_item(item)
		player_stats.selected_item = item.item_name
		item.queue_free()
		emit_signal("item_picked", item_definitions[player_stats.selected_item].texture)

func create_new_item(item):
	var item_scene = item_definitions[player_stats.selected_item].scene.instance()
	item_scene.global_position = item.global_position
	item_scene.connect("player_over_item", self, "on_player_over_item")
	get_tree().current_scene.add_child(item_scene)

func on_player_can_open(lock):
	if Input.is_action_just_pressed("ui_accept"):
		player_stats.selected_item = null
		emit_signal("item_used")
		lock.open()

func on_player_over_charger(teleporter_group, teleporter):
	if Input.is_action_just_pressed("ui_accept") and player_stats.selected_item == 'teleportpass':
		player_stats.selected_item = null
		teleporter_group.charges += 2
		emit_signal("item_used")

func on_teleporter_activated(teleporter_group, teleporter):
	for tele in teleporter_group.get_children():
		if tele.name != teleporter.name:
			global_position.x = tele.global_position.x + 24
			global_position.y  = tele.global_position.y - 16
