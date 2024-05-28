@icon("res://addons/dialogue_system/icons/WorldVoid.svg")
extends Area3D
class_name WorldVoid3D

# Exported variables
@export_category("WorldVoid3D")
@export var player : Node3D = null
@export var camera : Node3D = null

# Engine functions

# On body entered
func _on_body_entered(body):
	if body == player:
		get_tree().reload_current_scene()
	elif body != camera:
		body.queue_free()
