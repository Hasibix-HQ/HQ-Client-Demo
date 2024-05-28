extends Node

# Constant variables
@onready var ANIMATOR = $animator
@onready var CONTROLS = $controls
@onready var RESUME_BTN = $controls/resume_btn
@onready var OPTIONS_BTN = $controls/options_btn
@onready var ABOUT_BTN = $controls/about_btn
@onready var QUIT_BTN = $controls/quit_btn

# Exported variables
@export var pause_btn : BaseButton = null

# Self functions

func pause():
	get_tree().paused = true
	ANIMATOR.play("pause")

func resume():
	get_tree().paused = false
	ANIMATOR.play("resume")

func quit():
	get_tree().quit()

# Engine functions

# On ready
func _ready():
	pause_btn.pressed.connect(self.pause)
	RESUME_BTN.pressed.connect(self.resume)
	QUIT_BTN.pressed.connect(self.quit)
	self.visible = get_tree().paused
