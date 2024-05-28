@icon("res://addons/dialogue_system/icons/DialogueResource.svg")
extends Resource
class_name DialogueData

# Exported variables
@export_category("DialogueData")
@export var image : Texture2D
@export var author : String
@export var text : String
@export_group("Responses")
@export var responses : Array[DialogueResponse] = []
@export_group("TypeWriter")
@export var typewriter_enabled := false
@export var typewriter_delay := 0.25
@export var typewriter_is_instant := false
@export var typewriter_voice_enabled := false
@export var voice_bytes : Array[AudioStream] = []
