@tool
@icon("res://addons/dialogue_system/icons/IconButton.svg")
extends TextureButton
class_name IconButton

# Constant variables
@onready var ICON_IMG : TextureRect = $icon

# Exported variables
@export_category("IconButton")
@export var icon : Texture2D = null

# Engine variables

# On step
func _process(delta):
	ICON_IMG.set_texture(icon)
