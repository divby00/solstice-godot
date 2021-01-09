extends Node2D

const Squid = preload("res://scenes/Enemies/Squid/Squid.tscn")
const EvilOwl = preload("res://scenes/Enemies/EvilOwl/EvilOwl.tscn")
const Medusoid = preload("res://scenes/Enemies/Medusoid/Medusoid.tscn")
const MedusoidSoldier = preload("res://scenes/Enemies/MedusoidSoldier/MedusoidSoldier.tscn")

const area_enemies = {
	0: {
		"amount": 5,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl, Squid
		]
	},
	1: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier
		]
	},
	2: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier
		]
	},
	3: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl
		]
	},
	4: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl
		]
	},
	5: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl
		]
	},
	6: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl, Squid
		]
	},
	7: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl, Squid
		]
	},
	8: {
		"amount": 30,
		"allowed_types": [
			Medusoid, MedusoidSoldier, EvilOwl, Squid
		]
	},
}

onready var enemies: int = 0 setget set_enemies
onready var spawners = get_tree().get_nodes_in_group("SpawnerGroup")

func _process(_delta):
	if enemies < area_enemies[LevelData.current_level_number].amount:
		var ready_spawners = get_ready_spawners()
		if ready_spawners.size() > 0:
			ready_spawners.shuffle()
			spawn_enemy(ready_spawners[0])

func get_ready_spawners():
	var ready_spawners = []
	for spawner in spawners:
		if spawner != null and spawner.ready:
			ready_spawners.append(spawner)
	return ready_spawners

func spawn_enemy(spawner):
	spawner.starts()
	self.enemies += 1
	var allowed_types = area_enemies[LevelData.current_level_number].allowed_types
	allowed_types.shuffle()
	var enemy = allowed_types[0].instance()
	enemy.global_position = spawner.global_position
	enemy.connect("enemy_attacked", ResourceLoader.player, "on_enemy_attacked")
	enemy.connect("enemy_died", self, "on_enemy_died")
	get_tree().current_scene.add_child(enemy)

func on_enemy_died(enemy):
	self.enemies -= 1
	enemy.queue_free()

func set_enemies(value):
# warning-ignore:narrowing_conversion
	enemies = clamp(value, 0, area_enemies[LevelData.current_level_number].amount)
