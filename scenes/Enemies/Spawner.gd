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

onready var timer: Timer = $Timer
onready var sprite: Sprite = $Sprite
onready var original_position: Vector2 = global_position
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var ready = false

func _ready():
	if Engine.is_editor_hint():
		animation_player.play("spawn")
	timer.wait_time = rand_range(4, 10)
	timer.start()

func starts():
	audio_player.play()
	SpawnerTypes.shuffle()
	sprite.texture = Spawners[SpawnerTypes[0]]
	var offset: Vector2 = Vector2(rand_range(-4, 4), rand_range(-4, 4))
	global_position = original_position + offset
	animation_player.play("spawn")
	timer.wait_time = rand_range(4, 10)
	timer.start()
	ready = false

func _on_Timer_timeout():
	ready = true
