@icon("res://addons/dialogue_system/icons/ThemeManager.svg")
extends Node
class_name ThemeManager

# Exported variables
@export var toggle_dark_mode_btn : IconButton = null
@export var light_mode_icon : Texture2D = null
@export var dark_mode_icon : Texture2D = null
@export var ui_root : Control = null
@export var light_mode_theme : Theme = null
@export var dark_mode_theme : Theme = null

# Self functions

# Toggle dark mode
func toggle_dark_mode():
	Global.config.dark_mode = !Global.config.dark_mode
	print("dark mode: " + str(Global.config.dark_mode))
	pass

# Set dark mode
func set_dark_mode(dark_mode := true):
	Global.config.dark_mode = dark_mode
	print("dark mode: " + str(Global.config.dark_mode))
	pass

# Engine functions

# On ready
func _ready():
	toggle_dark_mode_btn.pressed.connect(self.toggle_dark_mode)

# On step
func _process(delta):
	if Global.config.dark_mode:
		toggle_dark_mode_btn.icon = dark_mode_icon
		ui_root.theme = dark_mode_theme
	else:
		toggle_dark_mode_btn.icon = light_mode_icon
		ui_root.theme = light_mode_theme
