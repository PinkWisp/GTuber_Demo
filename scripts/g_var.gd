extends Node
var user_mic : String = ""
var mic_value #mic volume

var w_threshold : int = -40
var n_threshold : int = -20
var l_threshold : int = -10

var emote_buffer : int = 0 #0= not talking, 1= whisper, 2 = normal, 3= loud

var tablet_calibrated : bool = false
var tablet_TRight : Vector2 = Vector2.ZERO
var tablet_BRight : Vector2 = Vector2.ZERO
var tablet_TLeft : Vector2 = Vector2.ZERO
var tablet_BLeft : Vector2 = Vector2.ZERO

#
### From my model
#var tablet_on : bool = false
#
#var current_monitor : String = ""
#
#var overlay : bool = false
#var overlay_controller : int = 0 #0 = gamepad, 1 = mouse and keyboard
#
#var face_emote : int = 0 # 0 = Not talking, 3 = Loud, 2 = Normal, 1 = Quiet
#var face_emote_override : bool = false
#var face_override : String = "Default"
#
#var should_close : bool = false
#var ranting : bool = false
#
#var emote : String = "Rest"
#var emoting : bool = false
