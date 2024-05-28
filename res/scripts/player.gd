@icon("res://addons/dialogue_system/icons/Player3D.svg")
extends CharacterBody3D
class_name Player3D

# Constant variables
@onready var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var MESH := $mesh

# Exported variables
@export_category("Player3D")
@export_group("Movement")
@export var rotation_speed := 10.0
@export var speed := 5.0
@export var run_speed := 10.0
@export var crouch_speed := 2.5
@export var jump_force := 7.5
@export_group("Others")
@export var camera_controller : CameraController3D = null

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

# Player movement
func player_movement(delta : float):
	if camera_controller and camera_controller.freecam:
		return
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if rotation_speed < 0:
			MESH.look_at(position + direction, Vector3.UP)
		else:
			look_towards(MESH, position + direction, delta, rotation_speed)
			
		if Input.is_action_pressed("run"):
			velocity.x = direction.x * run_speed
			velocity.z = direction.z * run_speed
		elif Input.is_action_pressed("crouch"):
			velocity.x = direction.x * crouch_speed
			velocity.z = direction.z * crouch_speed
		else:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func player_collision():
	if is_on_floor():
		for i in get_slide_collision_count():
			check_for_collision(get_slide_collision(i))

func check_for_collision(collision):
	var col_obj = collision.get_collider()
	if col_obj.get_collision_layer() == 2:
		var push_direction = (col_obj.global_transform.origin - global_transform.origin).normalized()
		col_obj.apply_impulse(push_direction * speed, Vector3.ZERO )

# Engine functions

# On ready
func _ready():
	pass

# On step
func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

# On physics step
func _physics_process(delta):
	player_movement(delta)
	player_collision()
