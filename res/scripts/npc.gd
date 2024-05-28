@icon("res://addons/dialogue_system/icons/NPC3D.svg")
extends CharacterBody3D
class_name NPC3D

enum State { IDLE, TALKING, WALKING }

# Constant variables
@onready var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var AI : NavigationAgent3D = $ai
@onready var MESH : Node3D = $mesh
@onready var ANIMATOR : AnimationPlayer = $mesh/animator
@onready var INTERACTION_AREA : InteractableArea3D = $interaction_area
@onready var TARGET : CharacterBody3D = $"../player"

# Exported variables
@export_category("NPC3D")
@export var speed := 5.0
@export var dialogue_controller : DialogueController = null
@export var dialogues : Array[DialogueData] = []

# Member variables
var state := State.IDLE
var target_reached := true

# Self functions

# Smoothed out `look_at(Vector3)`
func look_towards(node: Object, vector, deltaTime, smooth_speed:= 1.0, return_only:= false):
	var smooth
	if smooth_speed == 0:
		smooth = false
	else:
		smooth = true
	if vector is Object:
		vector = vector.global_transform.origin
	elif !vector is Vector3:
		get_tree().paused = true
		return
	var looker = Node3D.new()
	node.add_child(looker)
	looker.look_at(vector, Vector3.UP)
	var finalRot = node.rotation_degrees + looker.rotation_degrees
	if return_only == true:
		return finalRot
	elif smooth == false:
		node.rotation_degrees = finalRot
	else:
		looker.look_at(vector, Vector3.UP)
		finalRot = node.rotation_degrees + looker.rotation_degrees
		node.rotation_degrees = lerp(node.rotation_degrees, finalRot, deltaTime * smooth_speed)
	looker.queue_free()
	pass

# On interaction
func interact():
	dialogue_controller.play(dialogues[0])

# Stop interaction
func stop_interaction():
	dialogue_controller.stop()

# Engine functions

# On ready
func _ready():
	INTERACTION_AREA.player_interacted.connect(self.interact)
	INTERACTION_AREA.player_exitted.connect(self.stop_interaction)

# On step
func _process(delta):
	if dialogue_controller.is_playing:
		state = State.TALKING

	if state == State.IDLE:
		if ANIMATOR.get_current_animation() != "idle":
			ANIMATOR.play("idle")
	elif state == State.TALKING:
		if (ANIMATOR.get_current_animation() == "idle" || ANIMATOR.get_current_animation() == "walking"):
			_animation_talking()
	elif state == State.WALKING:
		if ANIMATOR.get_current_animation() != "walk":
			ANIMATOR.play("walk")

# On physics step
func _physics_process(delta):
	if TARGET and !target_reached:
		if not is_on_floor():
			velocity.y -= GRAVITY * delta
		var direction = Vector3()
		AI.target_position = TARGET.global_position
		direction = AI.get_next_path_position() - global_position
		direction = direction.normalized()
		if direction:
			look_towards(MESH, Vector3((position + direction).x, (position + direction).y / 2, (position + direction).z), delta, 4)
			print(position + direction)
			state = State.WALKING
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

		move_and_slide()
	else:
		state = State.IDLE
		if not is_on_floor():
			velocity.y -= GRAVITY * delta
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		move_and_slide()

func _animation_talking():
	var animation_to_play = randi_range(0, 1)
	if animation_to_play == 0:
		ANIMATOR.play("talk_1")
	elif animation_to_play == 1:
		ANIMATOR.play("talk_2")
	else:
		print("THIS IS NOT POSSIBLE")

func _on_call_hasibot_btn_pressed():
	target_reached = false
	print("I'm coming :3")

func _on_target_reached():
	print("Target reached!")
	target_reached = true

func _on_path_changed():
	target_reached = false
