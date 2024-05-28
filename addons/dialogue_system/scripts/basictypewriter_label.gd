@icon("res://addons/dialogue_system/icons/BasicTypeWriterLabel.svg")
class_name BasicTypeWriterLabel
extends Label

signal char_typed
signal started
signal stopped

# Exported variables
@export_category("BasicTypeWriterLabel")
@export var timer : Timer = null
@export var voice_player : AudioStreamPlayer = null
@export var typing_delay := 0.25
@export var is_instant := false
@export var voice_enabled := false
@export var voice_bytes : Array[AudioStream] = []

# Member variables
var is_playing := false
var counter := 0

# Self functions

# Play a random voice byte
func play_vb():
	if voice_bytes.is_empty() or !voice_player:
		return
	var vb = voice_bytes[randi_range(0, (voice_bytes.size()-1))]
	if vb:
		voice_player.stream = vb
		voice_player.play()

# Play typewriter animation
func play():
	if !is_playing:
		self.visible_characters = 0
		timer.start()
		is_playing = true
		emit_signal("started")
	else:
		stop()
		self.visible_characters = 0
		timer.start()
		is_playing = true
		emit_signal("started")

# Stop typewriter animation
func stop():
	if is_playing:
		timer.stop()
		self.visible_characters = -1
		is_playing = false
		emit_signal("stopped")

# Write character (animation)
func write_char():
	if is_instant:
		if voice_enabled:
			play_vb()
		emit_signal("char_typed")
		counter = self.text.length()
		is_playing = false
	if counter < self.text.length():
		is_playing = true
		counter += 1
		self.visible_characters += 1
		if voice_enabled and self.text[counter-1] != " ":
			play_vb()
		emit_signal("char_typed")
	else:
		counter = 0
		self.visible_characters = -1
		is_playing = false
		timer.stop()

# Engine functions

# On readyw
func _ready():
	timer.timeout.connect(self.write_char)

func _process(delta):
	timer.wait_time = typing_delay
