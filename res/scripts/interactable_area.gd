@icon("res://addons/dialogue_system/icons/InteractableArea3D.svg")
extends Area3D
class_name InteractableArea3D

signal player_interacted
signal player_entered
signal player_exitted

# Exported variables
@export_category("InteractableArea3D")
@export var interact_hold_timer : Timer = null
@export var player : Node3D = null
@export var interact_btn : Button = null
@export var interaction_progress_bar : ProgressBar = null

# Member variables
var player_can_interact := false

# Self functions

# Called when player interacted
func interact():
	emit_signal("player_interacted")

func interact_btn_pressed():
	if player_can_interact:
		interact_hold_timer.start()

func interact_btn_released():
	interact_hold_timer.stop()

# Engine functions

# On ready
func _ready():
	interact_btn.button_down.connect(self.interact_btn_pressed)
	interact_btn.button_up.connect(self.interact_btn_released)
	interact_hold_timer.timeout.connect(self.interact)

# On step
func _process(delta):
	interaction_progress_bar.max_value = interact_hold_timer.wait_time

	if player_can_interact:
		interact_btn.visible = true
		interaction_progress_bar.visible = true
	else:
		interact_btn.visible = false
		interaction_progress_bar.visible = false

	if player_can_interact and Input.is_action_just_pressed("interact"):
		interact_btn_pressed()
	elif player_can_interact and Input.is_action_just_released("interact"):
		interact_btn_released()

	if !player_can_interact and !interact_hold_timer.is_stopped():
		interact_hold_timer.stop()

func _physics_process(delta):
	if interact_hold_timer.is_stopped():
		interaction_progress_bar.value = 0
	else:
		interaction_progress_bar.value = interact_hold_timer.wait_time - interact_hold_timer.time_left

# On body entered
func _on_body_entered(body):
	if body == player:
		player_can_interact = true
		emit_signal("player_entered")

#On body exitted
func _on_body_exited(body):
	if body == player:
		player_can_interact = false
		emit_signal("player_exitted")
