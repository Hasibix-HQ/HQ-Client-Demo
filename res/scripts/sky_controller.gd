extends WorldEnvironment
class_name SkyController

# Constant variables
@onready var DELAY_TIMER = $time_delay
@onready var SKY = $sky
@onready var SUN = $sky/sun
@onready var SUN_VISUAL = $sky/sun/mesh
@onready var MOON = $sky/moon

var MAX_TIME := 1440
var TIME_PER_TICK := 1
var SKY_ROTATION_PER_TICK := 0.1666666666666667

# Exported variables
@export var camera_controller : CameraController3D = null
@export var time_delay := 0.25
@export var timescale := 1.0
@export var time_counter : Label = null
@export var day_counter : Label = null
@export var sky_colors : GradientTexture1D = null
@export_group("Time")
@export var sunrise_time := 0
@export var day_time := 0
@export var sunset_time := 0
@export var night_time := 720

# Member variables
var day := 0
var time := 0
var sky_rotation := 0.0

# Self functions

# Format time in HH:MM pattern
func format_time(time_in_seconds: int) -> String:
	var hours = int(time_in_seconds / 60)
	var minutes = int(time_in_seconds % 60)

	var hours_str = ("0" + str(hours)) if hours < 10 else str(hours)
	var minutes_str = ("0" + str(minutes)) if minutes < 10 else str(minutes)

	return hours_str + ":" + minutes_str

# Step an in-game time
func step():
	if time != MAX_TIME:
		time += int(round(float(TIME_PER_TICK) * timescale))
		sky_rotation = wrapf(sky_rotation + (SKY_ROTATION_PER_TICK * timescale), -180, 180)

# Engine functions

# On ready
func _ready():
	DELAY_TIMER.timeout.connect(self.step)
	DELAY_TIMER.start(time_delay)
	print(str(SKY_ROTATION_PER_TICK))

# On physics step
func _process(delta):
	if time < MAX_TIME:
		time_counter.text = "Time: " + format_time(time)
		SKY.global_rotation_degrees.z = sky_rotation
	if time == MAX_TIME:
		day += 1
		time = 0
		time_counter.text = "Time: " + str(time)
		day_counter.text = "Day: " + str(day)
		sky_rotation = 0
		SKY.global_rotation_degrees.z = 0
		print("A day has passed! Current day: " + str(day))

	SKY.global_position = camera_controller.global_position
	SUN_VISUAL.look_at(camera_controller.CAMERA.global_position, Vector3.UP)
	SUN_VISUAL.global_rotation = camera_controller.CAMERA.global_rotation
	MOON.look_at(camera_controller.CAMERA.global_position, Vector3.UP)
	MOON.global_rotation = camera_controller.CAMERA.global_rotation
