tool
extends KinematicBody2D

enum Direction {
	LEFT, RIGHT
}

export(Direction) var direction = Direction.LEFT setget set_direction

onready var texture_rect = $TextureRect

func _ready():
	texture_rect.flip_h = direction == Direction.RIGHT

func set_direction(value):
	direction = value
	if texture_rect != null:
		texture_rect.flip_h = direction == Direction.RIGHT
