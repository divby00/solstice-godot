extends "res://scenes/Enemies/Enemy.gd"

const FlyingMine = preload("res://scenes/Enemies/FlyingMine/FlyingMine.tscn")

onready var move_timer = $MoveTimer
onready var position_timer = $PositionTimer
onready var animation_player = $AnimationPlayer

var angle = 0
var can_attack = false
var motion = Vector2.ZERO
var player_position = Vector2.ZERO

func _ready():
	animation_player.play("spawn")
	var respawn = rand_range(5.0, 10.0)
	move_timer.wait_time = respawn
	position_timer.wait_time = respawn / 2

func _process(delta):
	motion = Vector2(ResourceLoader.player.global_position - global_position).normalized() * 40
	angle += delta * 5
	global_position.x += sin(angle)
	global_position.y += cos(angle)

func _physics_process(_delta):
	move_and_slide(motion)

func create_mine():
	var flying_mine = FlyingMine.instance()
	get_tree().current_scene.add_child(flying_mine)
	flying_mine.global_position = global_position

func on_player_collided(damage):
	if can_attack:
		emit_signal("enemy_attacked", damage)

func on_enemy_died():
	.create_powerup()
	.create_green_explosion()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn" or anim_name == "dissolve" or anim_name == "appear":
		can_attack = true
		animation_player.play("idle")
	if anim_name == "dissolve":
		can_attack = false
		if in_screen:
			create_mine()
			global_position = player_position
		animation_player.play("appear")

func _on_MoveTimer_timeout():
	can_attack = false
	if in_screen:
		SoundFx.play("enemy_spawn")
	animation_player.play("dissolve")

func _on_PositionTimer_timeout():
	player_position = ResourceLoader.player.global_position
