tool
extends StaticBody2D

signal player_has_to_move(direction)

var moving_player = false

enum Direction {
	LEFT, RIGHT
}

export(Direction) var direction = Direction.LEFT setget set_direction

onready var texture_rect = $TextureRect

func _ready():
	texture_rect.flip_h = direction == Direction.RIGHT

func _process(_delta):
	if moving_player:
		emit_signal("player_has_to_move", direction)

func set_direction(value):
	direction = value
	if texture_rect != null:
		texture_rect.flip_h = direction == Direction.RIGHT

func _on_MovingArea_body_entered(_body):
	moving_player = true

func _on_MovingArea_body_exited(_body):
	moving_player = false

