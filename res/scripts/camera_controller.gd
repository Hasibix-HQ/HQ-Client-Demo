@icon("res://addons/dialogue_system/icons/CameraController3D.svg")
extends CharacterBody3D
class_name CameraController3D

# Constant variables
@onready var CAMERA : Camera3D = $camera

# Exported variables
@export_category("CameraController3D")
@export_group("Controls")
@export var toggle_freecam_button : IconButton = null
@export var freecam_enabled_icon : Texture2D = null
@export var freecam_disabled_icon : Texture2D = null
@export var toggle_orthogonal_button : IconButton = null
@export var orthogonal_icon : Texture2D = null
@export var perspective_icon : Texture2D = null
@export_group("Rotation")
@export var starting_rotation := Vector2(-35.3, 0)
@export var can_rotate := false
@export var camera_sensitivity := Vector2(0.25, 0.25)
@export var camera_mouse_sensitivity := Vector2(0.25, 0.25)
@export_group("Zoom")
@export var can_zoom := true
@export var camera_min_zoom := 6.0
@export var camera_max_zoom := 10.0
@export var camera_zoom_speed := 0.5
@export_group("Movement")
@export var target : Node3D = null
@export var smoothness := 50.0
@export var freecam := false
@export var speed := 5
@export var run_speed := 10

# Member variables
var camera_zoom := camera_min_zoom
var can_move_view := false

# Self functions

# Toggle freecam
func toggle_frecam():
	freecam = !freecam
	if freecam:
		toggle_freecam_button.icon = freecam_enabled_icon
	else:
		toggle_freecam_button.icon = freecam_disabled_icon

# Switch camera projection modes (Perspective/Orthogonal)
func toggle_orthogonal_mode():
	if CAMERA.projection == Camera3D.PROJECTION_PERSPECTIVE:
		CAMERA.projection = Camera3D.PROJECTION_ORTHOGONAL
	elif CAMERA.projection == Camera3D.PROJECTION_ORTHOGONAL:
		CAMERA.projection = Camera3D.PROJECTION_PERSPECTIVE

# Camera rotation
func cam_rotation():
	if can_rotate:
		var input_x = Input.get_axis("camera_left", "camera_right")
		var input_y = Input.get_axis("camera_down", "camera_up")

		if input_x != 0.0:
			if target:
				target.rotation_degrees.y = wrapf(target.rotation_degrees.y - (input_x * camera_mouse_sensitivity.x), 0.0, 360.0)
			self.rotation_degrees.y = wrapf(self.rotation_degrees.y - (input_x * camera_mouse_sensitivity.x), 0.0, 360.0)
		if input_y != 0.0:
			self.rotation_degrees.x = clamp(self.rotation_degrees.x - (input_y * camera_mouse_sensitivity.y), -30.0, 90.0)
	else:
		self.rotate_y(target.global_rotation.y)

# Camera rotation mouse
func cam_mouse_event(event : InputEvent):
	if can_rotate:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				can_move_view = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				can_move_view = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and can_move_view:
			if target:
				target.rotation_degrees.y = wrapf(target.rotation_degrees.y - (event.relative.x * camera_mouse_sensitivity.x), 0.0, 360.0)

			self.rotation_degrees.x = clamp(self.rotation_degrees.x - (event.relative.y * camera_mouse_sensitivity.y), -90.0, 30.0)
			self.rotation_degrees.y = wrapf(self.rotation_degrees.y - (event.relative.x * camera_mouse_sensitivity.x), 0.0, 360.0)

# Camera zoom
func cam_zoom():
	if can_zoom:
		if camera_zoom < camera_min_zoom:
			camera_zoom = camera_min_zoom
		elif camera_zoom > camera_max_zoom:
			camera_zoom = camera_max_zoom

		if (camera_zoom < camera_max_zoom) and (Input.is_action_pressed("camera_zoom_plus_kb") or Input.is_action_just_released("camera_zoom_plus_mouse")):
			camera_zoom += camera_zoom_speed
		elif (camera_zoom > camera_min_zoom) and (Input.is_action_pressed("camera_zoom_minus_kb") or Input.is_action_just_released("camera_zoom_minus_mouse")):
			camera_zoom -= camera_zoom_speed
	else:
		camera_zoom = camera_min_zoom
	CAMERA.size = camera_zoom
	CAMERA.fov = camera_zoom * 5

# Camera movement
func cam_movement(delta):
	if freecam:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var input_dir_y = Input.get_axis("crouch", "jump")
		var direction = (transform.basis * Vector3(input_dir.x, input_dir_y, input_dir.y)).normalized()
		if direction:
			if Input.is_action_pressed("run"):
				velocity.x = direction.x * run_speed
				velocity.y = direction.y * run_speed
				velocity.z = direction.z * run_speed
			else:
				velocity.x = direction.x * speed
				velocity.y = direction.y * speed
				velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		move_and_slide()
	else:
		if !target:
			return
		var direction = (target.global_position - self.global_position)
		if direction != Vector3.ZERO:
			if Input.is_action_pressed("run"):
				velocity = velocity.lerp(direction * run_speed, smoothness * delta)
			else:
				velocity = velocity.lerp(direction * speed, smoothness * delta)
		move_and_slide()

# Engine functions

# On ready
func _ready():
	toggle_freecam_button.pressed.connect(self.toggle_frecam)
	toggle_orthogonal_button.pressed.connect(self.toggle_orthogonal_mode)

	self.rotation_degrees.x = clamp(starting_rotation.x, -30.0, 90.0)
	self.rotation_degrees.y = wrapf(starting_rotation.y, 0.0, 360.0)

func _input(event):
	cam_mouse_event(event)

# On step
func _process(delta):
	if CAMERA.projection == Camera3D.PROJECTION_PERSPECTIVE:
		toggle_orthogonal_button.icon = perspective_icon
	elif CAMERA.projection == Camera3D.PROJECTION_ORTHOGONAL:
		toggle_orthogonal_button.icon = orthogonal_icon
	cam_rotation()
	cam_zoom()

# On physics step
func _physics_process(delta):
	cam_movement(delta)
	pass
