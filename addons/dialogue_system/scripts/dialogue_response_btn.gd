extends Button
class_name DialogueResponseButton

@onready var DIALOGUE_CONTROLLER : DialogueController = $"../.."

var response : DialogueResponse = null

func _ready():
	self.pressed.connect(self.on_pressed)

func on_pressed():
	DIALOGUE_CONTROLLER.play_response_result(response)
	DIALOGUE_CONTROLLER.clear_all_responses()
