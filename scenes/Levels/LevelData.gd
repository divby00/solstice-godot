extends Node

onready var levels = {
	"1": preload("res://scenes/Levels/Level01.tscn"),
	"2": preload("res://scenes/Levels/Level02.tscn"),
}

var current_level = null
var current_level_number = 1
