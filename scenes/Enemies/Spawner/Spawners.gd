extends Node2D

const Medusoid = preload("res://scenes/Enemies/Medusoid/Medusoid.tscn")

export(int) var MAX_ENEMIES = 50
onready var enemies: int = 0 setget set_enemies
onready var spawners = get_tree().get_nodes_in_group("SpawnerGroup")

func _process(_delta):
	if enemies < MAX_ENEMIES:
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
	var enemy = Medusoid.instance()
	enemy.global_position = spawner.global_position
	enemy.connect("enemy_attacked", ResourceLoader.player, "on_enemy_attacked")
	enemy.connect("enemy_died", self, "on_enemy_died")
	get_tree().current_scene.add_child(enemy)

func on_enemy_died(enemy):
	self.enemies -= 1
	enemy.queue_free()

func set_enemies(value):
	enemies = clamp(value, 0, MAX_ENEMIES)
