extends KinematicBody2D

const BigExplosionEffect = preload("res://scenes/Effects/BigExplosionEffect.tscn") 

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var particles : CPUParticles2D = $Particles
onready var timer = $InvincibleTimer

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
	if Input.get_action_strength("ui_up") and PlayerData.thrust > 5:
		input_vector.y = -1
		particles.emitting = true
		PlayerData.thrust -= .025
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
	if !is_on_floor() and !is_in_magnetic_area and PlayerData.status != PlayerData.Status.TELEPORT:
		motion.y += GRAVITY * delta

func update_animation(input_vector):
	var current_animation = animation_player.current_animation
	if input_vector.x < 0:
		facing = Facing.LEFT
		animation_player.play_backwards(current_animation)
	elif input_vector.x > 0:
		facing = Facing.RIGHT
		animation_player.play(current_animation)

func on_item_picked(item):
	if PlayerData.selected_item != null:
		create_new_item(item)
	PlayerData.selected_item = item.item_name
	item.queue_free()
	emit_signal("item_picked", item_definitions[PlayerData.selected_item].texture)

func create_new_item(item):
	var item_scene = item_definitions[PlayerData.selected_item].scene.instance()
	item_scene.global_position = item.global_position
	item_scene.connect("item_picked", self, "on_item_picked")
	get_tree().current_scene.add_child(item_scene)
	
func on_lock_opened(lock):
	PlayerData.selected_item = null
	emit_signal("item_used")

func on_teleporter_charged(teleporter_group, teleporter):
	PlayerData.selected_item = null
	emit_signal("item_used")

func on_teleporter_activated(teleporter_group, teleporter):
	PlayerData.status = PlayerData.Status.TELEPORT
	set_physics_process(false)
	for tele in teleporter_group.get_children():
		if tele.name != teleporter.name:
			yield(get_tree().create_timer(.4), "timeout")
			global_position.x = tele.global_position.x + 24
			global_position.y  = tele.global_position.y - 16
			tele.particles.emitting = true
			yield(get_tree().create_timer(.4), "timeout")
			PlayerData.status = PlayerData.Status.OK
			set_physics_process(true)

func on_pass_dispatched(dispatcher):
	PlayerData.health = 0
	create_teleporter_pass(dispatcher.spawner.global_position)

func create_teleporter_pass(position: Vector2):
	var item_scene = item_definitions["teleportpass"].scene.instance()
	item_scene.global_position = position
	item_scene.connect("item_picked", self, "on_item_picked")
	get_tree().current_scene.add_child(item_scene)

func on_nuclear_waste_stored(storage):
	PlayerData.selected_item = null
	emit_signal("item_used")

func on_player_destroyed():
	var sprite_size = sprite.texture.get_size()
	for i in 5:
		var position = Vector2(global_position.x + rand_range(-8, 8), global_position.y + rand_range(-8, 8))
		var explosion = BigExplosionEffect.instance()
		explosion.global_position = position
		get_tree().current_scene.add_child(explosion)
	PlayerData.lives -= 1
	PlayerData.health = PlayerData.MAX_HEALTH
	PlayerData.status = PlayerData.Status.INVINCIBLE
	timer.start()

func _on_InvincibleTimer_timeout():
	PlayerData.status = PlayerData.Status.OK

func on_enemy_attacked(enemy):
	if timer.is_stopped():
		PlayerData.status = PlayerData.Status.DAMAGED

func on_status_changed(old_status, new_status):
	match new_status:
		PlayerData.Status.OK:
			animation_player.play("rotation")
		PlayerData.Status.DAMAGED:
			animation_player.play("hurt")
		PlayerData.Status.DESTROYED:
			animation_player.play("destroyed")
		PlayerData.Status.INVINCIBLE:
			animation_player.play("invincible")
		PlayerData.Status.TELEPORT:
			animation_player.play("teleport")

func on_enemy_attack_stopped(enemy):
	if timer.is_stopped():
		PlayerData.status = PlayerData.Status.OK
	else:
		PlayerData.status = PlayerData.Status.INVINCIBLE
