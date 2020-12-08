extends Node

const MAX_CHARGES = 10
onready var animatorA = $TeleporterA/AnimationPlayer
onready var animatorB = $TeleporterB/AnimationPlayer

signal player_over_charger(teleporter_group, teleporter)
signal teleporter_activated(teleporter_group, teleporter)

enum Status {
	IDLE,
	CHARGED,
	WORKING
}

var charges = 0 setget set_charges
var status = Status.IDLE setget set_status

func set_charges(value):
	charges = clamp(value, 0, MAX_CHARGES)
	if charges <= 0:
		self.status = Status.IDLE
		self.status = Status.IDLE
	else:
		self.status = Status.CHARGED
		self.status = Status.CHARGED

func set_status(value):
	if value == Status.IDLE:
		animatorA.play("idle")
		animatorB.play("idle")
	elif value == Status.CHARGED:
		animatorA.play("charged")
		animatorB.play("charged")
	elif value == Status.WORKING:
		animatorA.play("working")
		animatorB.play("working")

func _on_TeleporterA_player_over_charger(teleporter):
	emit_signal("player_over_charger", self, teleporter)

func _on_TeleporterB_player_over_charger(teleporter):
	emit_signal("player_over_charger", self, teleporter)

func _on_TeleporterA_teleporter_activated(teleporter):
	self.status = Status.WORKING
	yield(get_tree().create_timer(.4), "timeout")
	self.charges -= 1
	emit_signal("teleporter_activated", self, teleporter)

func _on_TeleporterB_teleporter_activated(teleporter):
	self.status = Status.WORKING
	yield(get_tree().create_timer(.4), "timeout")
	self.charges -= 1
	emit_signal("teleporter_activated", self, teleporter)
