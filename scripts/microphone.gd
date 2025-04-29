extends AudioStreamPlayer
# These Signals are the core of the program
# Whenever a mic hits a certain threshold it will send the signals to trigger
# whatever you set it too. This Demo is set up to trigger certain 
# AnimationTree parematers in AnchorPoint/Robot

signal mic_loud
signal mic_normal
signal mic_quiet
signal mic_null

@onready var buffer_timer: Timer = $BufferTimer

# GVar.emote_buffer & BufferTimer prevents flickering between expressions
func _process(delta: float) -> void:
	if GVar.mic_value > GVar.l_threshold && GVar.emote_buffer <= 3:
		GVar.emote_buffer = 3
		buffer_timer.start()
		mic_loud.emit()
	# if volume triggers N and didn't trigger L use N face
	elif GVar.mic_value > GVar.n_threshold && GVar.emote_buffer <= 2:
		GVar.emote_buffer = 2
		buffer_timer.start()
		mic_normal.emit()
	# if volume triggers W and didn't trigger N use W face
	elif GVar.mic_value > GVar.w_threshold && GVar.mic_value < GVar.n_threshold && GVar.emote_buffer <= 1:
		GVar.emote_buffer = 1
		buffer_timer.start()
		mic_quiet.emit()
	# if volume is less than W threshold
	elif GVar.mic_value < GVar.w_threshold && GVar.emote_buffer == 0:
		mic_null.emit()


func _on_buffer_timer_timeout() -> void:
	GVar.emote_buffer = 0
