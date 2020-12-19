extends Node

onready var levels = {
	"00": preload("res://scenes/Levels/Level00.tscn"),
	"01": preload("res://scenes/Levels/Level01.tscn"),
	"02": preload("res://scenes/Levels/Level02.tscn"),
	"03": preload("res://scenes/Levels/Level03.tscn"),
}

var current_level = null
var current_level_number = 0
