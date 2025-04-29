extends Node
# Assets by PinkWisp
# Base Mic code from MrEliptik (https://github.com/MrEliptik/godot_stream_overlays)
# GlobalInput addon by Darnoman (https://github.com/Darnoman/Godot-GlobalInput-Addon)

var effect_record = null
var effect_capture = null
var recording = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().set_transparent_background(true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true, 0) #sets window to transparent
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true, 0) #sets window always ontop
	var idx = AudioServer.get_bus_index("Mic")
	effect_capture = AudioServer.get_bus_effect(idx, 0)
	
	Settings.load_mic_settings()
	
func _process(delta: float) -> void:
	
	GVar.mic_value = process_mic()
	
	%ProgressBar.value = GVar.mic_value #shows mic input

	
# Gets value from live microphone 
func process_mic() -> float:
	var frames = effect_capture.get_buffer(effect_capture.get_frames_available())
	
	var data = PackedFloat32Array()
	data.resize(frames.size())

	var max_value := 0.0
	for i in range(frames.size()):
		var value: float = (frames[i].x + frames[i].y) / 2.0
		max_value = max(value, max_value)
		data[i] = value
		
	if max_value < GVar.w_threshold:
		return 0.0
	
	var volume_db = linear_to_db(max_value) #changes values to dicibels
	return (volume_db) #value in func process(delta)
