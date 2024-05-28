@icon("res://addons/dialogue_system/icons/Dialogue.svg")
extends Control
class_name DialogueController

# Constant variables
@onready var DIALOGUE_BOX : Panel = $dialogue_box
@onready var DIALOGUE_IMAGE : TextureRect = $dialogue_box/dialogue_image
@onready var DIALOGUE_AUTHOR : Label = $dialogue_box/dialogue_author
@onready var DIALOGUE_TEXT : TypeWriterLabel = $dialogue_box/dialogue_text
@onready var RESPONSE_BOX : Panel = $response_box
@onready var RESPONSE_1 : DialogueResponseButton = $response_box/response_1
@onready var RESPONSE_2 : DialogueResponseButton = $response_box/response_2
@onready var RESPONSE_3 : DialogueResponseButton = $response_box/response_3
@onready var RESPONSE_4 : DialogueResponseButton = $response_box/response_4

# Exported variables

# Member variables
var is_playing := false
var should_play := false
var current_dialogue : DialogueData = null

# Self functions

func assign_response(button : DialogueResponseButton, response : DialogueResponse): 
	button.text = response.response_text
	button.response = response
	button.visible = true

func clear_response(button : DialogueResponseButton): 
	button.text = "undefined"
	button.response = null
	button.visible = false

func clear_all_responses():
	clear_response(RESPONSE_1)
	clear_response(RESPONSE_2)
	clear_response(RESPONSE_3)
	clear_response(RESPONSE_4)
	RESPONSE_BOX.visible = false

# Play a dialogue
func play(dialogue : DialogueData):
	if !dialogue:
		print("Dialogue not found.")
		return
	current_dialogue = dialogue
	should_play = true

func play_response_result(response : DialogueResponse):
	if !response:
		return
	current_dialogue = response.result_dialogue
	should_play = true

func stop():
	if DIALOGUE_TEXT.is_playing:
		DIALOGUE_TEXT.stop()
	if !current_dialogue:
		return
	if current_dialogue.responses.size() > 0:
		if current_dialogue.responses.size() > 4:
			push_warning("Too many responses. Only 4 of them will be used, rest will be ignored.")
		RESPONSE_BOX.visible = true

		var current_responses := current_dialogue.responses
		current_dialogue = null
		var buttons := [RESPONSE_1, RESPONSE_2, RESPONSE_3, RESPONSE_4]

		for n in 4:
			if current_responses.size() - n <= 0:
				break
			assign_response(buttons[n], current_responses[n])
	else:
		current_dialogue = null

# Engine functions

# On step
func _process(delta):
	if !current_dialogue:
		DIALOGUE_BOX.visible = false
	else:
		if Input.is_action_just_pressed("skip"):
			if DIALOGUE_TEXT.is_playing:
				DIALOGUE_TEXT.stop()
			else:
				stop()
		if should_play:
			DIALOGUE_BOX.visible = true
			DIALOGUE_IMAGE.texture = current_dialogue.image

			if current_dialogue.author:
				DIALOGUE_AUTHOR.text = current_dialogue.author
			else:
				DIALOGUE_AUTHOR.text = "undefined"

			if current_dialogue.text:
				DIALOGUE_TEXT.text = current_dialogue.text
			else:
				DIALOGUE_TEXT.text = "undefined"
			if current_dialogue.typewriter_enabled:
				DIALOGUE_TEXT.typing_delay = current_dialogue.typewriter_delay
				DIALOGUE_TEXT.is_instant = current_dialogue.typewriter_is_instant
				DIALOGUE_TEXT.voice_enabled = current_dialogue.typewriter_voice_enabled
				DIALOGUE_TEXT.voice_bytes = current_dialogue.voice_bytes
				DIALOGUE_TEXT.play()
			should_play = false
	is_playing = DIALOGUE_TEXT.is_playing
