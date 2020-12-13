tool
extends Position2D

const BlueMedusoid = preload("res://scenes/Enemies/BlueMedusoid.tscn")

const Spawners = {
	"red": preload("res://scenes/Enemies/red_enemy_spawner.png"),
	"green": preload("res://scenes/Enemies/green_enemy_spawner.png"),
	"blue": preload("res://scenes/Enemies/blue_enemy_spawner.png"),
}

const SpawnerTypes = [
	"red", "green", "blue"
]

onready var timer : Timer = $Timer
onready var sprite: Sprite = $Sprite
onready var original_position : Vector2 = global_position
onready var animation_player : AnimationPlayer = $AnimationPlayer

signal enemy_appeared(enemy)

var ready = false
var active = false

func _ready():
	if Engine.is_editor_hint():
		animation_player.play("spawn")
	timer.wait_time = rand_range(3.0, 10.0)
	timer.start()
	active = true

func spawn_enemy():
	var enemy = BlueMedusoid.instance()
	enemy.global_position = global_position
	enemy.connect("enemy_attacked", ResourceLoader.player, "on_enemy_attacked")
	enemy.connect("enemy_attack_stopped", ResourceLoader.player, "on_enemy_attack_stopped")
	enemy.connect("enemy_died", get_parent(), "on_enemy_died")
	get_tree().current_scene.add_child(enemy)
	emit_signal("enemy_appeared", enemy)

func _on_Timer_timeout():
	ready = true
	if active and get_parent().can_spawn:
		SpawnerTypes.shuffle()
		sprite.texture = Spawners[SpawnerTypes[0]]
		var offset: Vector2 = Vector2(rand_range(-4, 4), rand_range(-4, 4))
		global_position = original_position + offset
		animation_player.play("spawn")
		timer.wait_time = rand_range(3.0, 10.0)
		timer.start()
		ready = false

