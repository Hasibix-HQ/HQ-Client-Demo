@tool
extends EditorPlugin

# Engine functions

# On enter tree
func _enter_tree():
	add_custom_type("DialogueController", "Control", preload("res://addons/dialogue_system/scripts/dialogue_controller.gd"), preload("res://addons/dialogue_system/icons/Dialogue.svg"))
	add_custom_type("DialogueResponse", "Resource", preload("res://addons/dialogue_system/scripts/dialogue_response.gd"), preload("res://addons/dialogue_system/icons/DialogueResource.svg"))
	add_custom_type("DialogueData", "Resource", preload("res://addons/dialogue_system/scripts/dialogue_data.gd"), preload("res://addons/dialogue_system/icons/DialogueResource.svg"))

# On exit tree
func _exit_tree():
	remove_custom_type("DialogueController")
	remove_custom_type("DialogueData")
	remove_custom_type("DialogueResponse")
