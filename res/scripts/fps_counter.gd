extends Label

# Engine functions

# On step
func _process(delta):
	self.text = "FPS: " + str(Engine.get_frames_per_second())
