extends Node2D
# For this Demo I used a 2D model but you can do the same with a 3D one
# Animate things in the AnimationPlayer and set it to trigger via AnimationTree parameters

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

# Recives loud signal from AudioStreamPlayer
func _on_audio_stream_player_mic_loud() -> void:
	# I animated change the color, eye.png, and blinking in the Animation Player
	animation_tree.set("parameters/Eyes/transition_request", "Angry") #sets eye animation to "Angry"
	animation_tree.set("parameters/Mouth/add_amount", 1) #plays mouth animation
	animation_tree.set("parameters/Talking/transition_request", "Talking_Normal") #sets mouth animation to "Talking_Normal"

# Recives normal signal from AudioStreamPlayer
func _on_audio_stream_player_mic_normal() -> void:
	animation_tree.set("parameters/Eyes/transition_request", "Default")
	animation_tree.set("parameters/Mouth/add_amount", 1)
	animation_tree.set("parameters/Talking/transition_request", "Talking_Normal")
	
# Recives quiet signal from AudioStreamPlayer
func _on_audio_stream_player_mic_quiet() -> void:
	animation_tree.set("parameters/Eyes/transition_request", "Sad")
	animation_tree.set("parameters/Mouth/add_amount", 1)
	animation_tree.set("parameters/Talking/transition_request", "Talking_Whisper")

# Recives null signal from AudioStreamPlayer
func _on_audio_stream_player_mic_null() -> void:
	animation_tree.set("parameters/Eyes/transition_request", "Default")
	animation_tree.set("parameters/Mouth/add_amount", 0)
	animation_tree.set("parameters/Talking/transition_request", "Talking_Null")
