extends KinematicBody2D

signal item_used
signal player_damaged
signal player_game_over
signal player_invincible
signal player_not_invincible
signal player_activated_bomb
signal item_picked(item_texture)
signal player_activated_elevator(level_pass)

const BigExplosion = preload("res://scenes/Effects/BigExplosion/BigExplosion.tscn")

onready var laser = $Laser
onready var plasma = $Plasma
onready var sprite : Sprite = $Sprite
onready var plasma_timer = $PlasmaTimer
onready var damage_timer = $DamageTimer
onready var plasma_collider = $Plasma/CollisionShape2D
onready var particles : CPUParticles2D = $SmokeParticles
onready var damage_particles : CPUParticles2D = $DamageParticles
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var rebuild_particles : CPUParticles2D = $RebuildParticles

enum Facing {
	LEFT, RIGHT
}

export(int) var ACCELERATION = 400
export(int) var MAX_SPEED = 80
export(int) var GRAVITY = 150
export(float) var FRICTION = .2

var on_destroy_process = false
var motion = Vector2.ZERO
var facing = Facing.RIGHT
var is_in_magnetic_area = false
var status = PlayerData.Status.OK setget set_status
var prev_status = PlayerData.Status.OK
var item_definitions = ResourceLoader.item_defs.definitions

func set_status(value):
	prev_status = status
	status = value
	if prev_status != status:
		match status:
			PlayerData.Status.OK:
				animation_player.play("rotation")
			PlayerData.Status.DAMAGED:
				damage_particles.emitting = true
				animation_player.play("hurt")
				damage_timer.start()
			PlayerData.Status.DESTROYED:
				animation_player.play("destroyed")
			PlayerData.Status.TELEPORT:
				animation_player.play("teleport")
			PlayerData.Status.INVINCIBLE:
				animation_player.play("invincible")
			PlayerData.Status.REBUILDING:
				animation_player.play("rebuilding")

func _ready():
	ResourceLoader.player = self

func _process(_delta):
	if Input.is_action_pressed("primary"):
		laser.fire()
	
	if Input.is_action_pressed("secondary"):
		var selected_item = PlayerData.selected_item
		match selected_item:
			"redbarrel":
				SoundFx.play("thrustup")
				PlayerData.thrust = PlayerData.MAX_THRUST
				emit_signal("item_used")
			"battery":
				SoundFx.play("laserup")
				PlayerData.laser = PlayerData.MAX_LASER
				emit_signal("item_used")
			"bomb":
				emit_signal("player_activated_bomb")
				emit_signal("item_used")
	
	if Input.is_action_just_released("plasma"):
		if not plasma.visible and PlayerData.plasma > 0:
			turn_on_plasma(PlayerData.plasma * .5)

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_vertical_force(input_vector, delta)
	apply_friction(input_vector)
	apply_gravity(delta)
	update_animation(input_vector)
	motion = move_and_slide(motion, Vector2.UP)

func turn_on_plasma(duration):
	if duration > 0:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)
		self.status = PlayerData.Status.INVINCIBLE
		plasma.visible = true
		plasma_timer.start()
		plasma_collider.call_deferred("set_disabled", false)
		animation_player.play("invincible")
		emit_signal("player_invincible")
	else:
		self.status = PlayerData.Status.OK

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	if Input.get_action_strength("up") and PlayerData.thrust > 5:
		input_vector.y = -1
		particles.emitting = true
		PlayerData.thrust -= .025
	else:
		particles.emitting = false
	if input_vector.x < 0:
		facing = Facing.LEFT
	elif input_vector.x > 0:
		facing = Facing.RIGHT
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
	if !is_on_floor() and !is_in_magnetic_area and self.status != PlayerData.Status.TELEPORT:
		motion.y += GRAVITY * delta

func update_animation(_input_vector):
	var current_animation = animation_player.current_animation
	if facing == Facing.LEFT:
		animation_player.play_backwards(current_animation)
	elif facing == Facing.RIGHT:
		animation_player.play(current_animation)

func create_new_item(item):
	var item_scene = item_definitions[PlayerData.selected_item].scene.instance()
	get_tree().current_scene.call_deferred("add_child", item_scene)
	item_scene.global_position = item.global_position
	item_scene.connect("item_picked", self, "on_item_picked")

func create_teleporter_pass(position: Vector2):
	var item_scene = item_definitions["teleportpass"].scene.instance()
	get_tree().current_scene.call_deferred("add_child", item_scene)
	item_scene.global_position = position
	item_scene.connect("item_picked", self, "on_item_picked")

func on_item_picked(item):
	SoundFx.play("accept")
	if PlayerData.selected_item != null:
		create_new_item(item)
	PlayerData.selected_item = item.item_name
	item.queue_free()
	emit_signal("item_picked", item_definitions[PlayerData.selected_item].texture)

func on_lock_opened(_lock):
	emit_signal("item_used")

func on_teleporter_charged(_teleporter_group, _teleporter):
	emit_signal("item_used")

func on_teleporter_activated(teleporter_group, teleporter):
	self.status = PlayerData.Status.TELEPORT
	set_process(false)
	set_physics_process(false)
	for tele in teleporter_group.get_children():
		if tele.name != teleporter.name and tele is Teleporter:
			yield(get_tree().create_timer(.4), "timeout")
			global_position.x = tele.global_position.x + 24
			global_position.y  = tele.global_position.y - 16
			tele.particles.emitting = true
			yield(get_tree().create_timer(.4), "timeout")
			self.status = PlayerData.Status.OK
			set_process(true)
			set_physics_process(true)

func on_pass_dispatched(dispatcher):
	PlayerData.health = 0
	create_teleporter_pass(dispatcher.spawner.global_position)

func on_nuclear_waste_stored(_storage):
	emit_signal("item_used")

func create_explosion():
	var explosion = BigExplosion.instance()
	get_tree().current_scene.call_deferred("add_child", explosion)
	explosion.emitting = true
	explosion.global_position = Vector2(global_position.x + rand_range(-8, +8), global_position.y + rand_range(-8, +8))
	explosion.z_index = 2

func on_player_destroyed():
	on_destroy_process = true
	damage_timer.stop()
	create_explosion()
	PlayerData.lives -= 1
	if PlayerData.lives > 0:
		PlayerData.health = PlayerData.MAX_HEALTH
		self.status = PlayerData.Status.REBUILDING
	else:
		emit_signal("player_game_over")

func on_enemy_attacked(damage):
	if self.status != PlayerData.Status.INVINCIBLE and self.status != PlayerData.Status.REBUILDING:
		self.status = PlayerData.Status.DAMAGED
		SoundFx.play("hurt")
		PlayerData.health -= damage
		emit_signal("player_damaged")

func on_item_used():
	PlayerData.selected_item = null

func on_player_has_to_move(direction):
	if direction == 0:
		motion.x = Vector2.LEFT.x * 75
	else:
		motion.x = Vector2.RIGHT.x * 75

func on_elevator_activated(level_pass):
	emit_signal("player_activated_elevator", level_pass)
	emit_signal("item_used")

func on_player_got_powerup(_powerup):
	PlayerData.plasma += 1

func _on_DamageTimer_timeout():
	if not plasma_timer.is_stopped():
		self.status = PlayerData.Status.INVINCIBLE
	else:
		self.status = PlayerData.Status.OK

func _on_PlasmaTimer_timeout():
	PlayerData.plasma -= 1
	if PlayerData.plasma == 0:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
		plasma_collider.call_deferred("set_disabled", true)
		plasma.visible = false
		plasma_timer.stop()
		PlayerData.plasma = 0
		self.status = PlayerData.Status.OK
		emit_signal("player_not_invincible")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "rebuilding":
		on_destroy_process = false
		set_process(true)
		set_physics_process(true)
		turn_on_plasma(PlayerData.plasma * .5)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "rebuilding":
		set_physics_process(false)
		set_process(false)
		rebuild_particles.emitting = true
