extends WorldEnvironment
class_name SkyController

# Constant variables
@onready var DELAY_TIMER = $time_delay
@onready var SKY = $sky
@onready var SUN = $sky/sun
@onready var SUN_VISUAL = $sky/sun/mesh
@onready var MOON = $sky/moon

# Exported variables
@export var camera_controller : CameraController3D = null
@export var smoothness := 5.0
@export var time_delay := 0.25
@export var time_counter : Label = null
@export var day_counter : Label = null
@export_group("Sky Colors")
@export_subgroup("Sunrise")
@export var sunrise_sky : Color;
@export var sunrise_horizon : Color;
@export_subgroup("Day")
@export var day_sky : Color;
@export var day_horizon : Color;
@export_subgroup("Sunset")
@export var sunset_sky : Color;
@export var sunset_horizon : Color;
@export_subgroup("Night")
@export var night_sky : Color;
@export var night_horizon : Color;
@export_group("Time")
@export var sunrise_time := 0.0
@export var day_time := 0.0
@export var sunset_time := 0.0
@export var night_time := 0.0

# Member variables
var day := 0
var time := 0
var sky_rotation := 0.0

# Self functions

# Step an in-game time
func step():
	if time != 240:
		time += 1
		sky_rotation += 1.5

# Engine functions

# On ready
func _ready():
	DELAY_TIMER.timeout.connect(self.step)
	DELAY_TIMER.start(time_delay)

# On physics step
func _process(delta):
	if time < 240:
		time_counter.text = "Time: " + str(time)
		SKY.global_rotation_degrees.z = wrapf(lerp(SKY.global_rotation_degrees.z, sky_rotation, smoothness * delta), -360.0, 0.0)
	if time == 240:
		day += 1
		time = 0
		time_counter.text = "Time: " + str(time)
		day_counter.text = "Day: " + str(day)
		sky_rotation = 0
		SKY.global_rotation_degrees.z = 0
		print("A day has passed! Current day: " + str(day))

	SUN_VISUAL.look_at(camera_controller.CAMERA.global_position, Vector3.UP)
	SUN_VISUAL.global_rotation = camera_controller.CAMERA.global_rotation
	MOON.look_at(camera_controller.CAMERA.global_position, Vector3.UP)
	MOON.global_rotation = camera_controller.CAMERA.global_rotation
