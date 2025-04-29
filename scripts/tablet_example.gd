extends Node3D
# Similar process to the Robot. Animate things in the Player 
# but instead of things being activated by mic volume
# we syncing the pen position with the mouse.

var pen_pos = DisplayServer.mouse_get_position()
var calibrating = false

func _ready() -> void:
	Settings.load_tablet_calibration() #Loads Settings
	_sync_calibration()

func _on_tablet_button_pressed() -> void:
	visible = !visible

func _process(delta: float) -> void:
	# checks if the tablet has been previously calibrated 
	if GVar.tablet_calibrated == true:
		# syncs cursor position and pen
		$TabletAniTree.set("parameters/Pen/blend_position", DisplayServer.mouse_get_position())
	else:
		_calibrating()
		
func _on_tabler_cali_button_button_down() -> void:
	%TablerCaliButton.text = "Starting Calibration..."
	# reset values to so we can recalibrate them
	GVar.tablet_TRight = Vector2.ZERO
	GVar.tablet_BRight = Vector2.ZERO
	GVar.tablet_TLeft = Vector2.ZERO
	GVar.tablet_BLeft = Vector2.ZERO
	$Timer2.start()
	
func _on_timer_2_timeout() -> void:
	%TablerCaliButton.self_modulate = Color.YELLOW
	%TablerCaliButton.text = "Calibrating..."
	%DebugLabel.text = "Click TOP RIGHT corner of your Tablet"
	calibrating = true #checks if we are in the process of calibrating the tablet
	GVar.tablet_calibrated = false
	
# user creates a Draw Area that the pen will sync too
func _calibrating():
	var TabletPen = $TabletAniTree.get_tree_root().get_node("Pen")
	if calibrating == true:
		if GlobalInput.is_action_just_released("Pen_Down"):
			#Top Right
			if GVar.tablet_TRight == Vector2.ZERO:
				GVar.tablet_TRight = DisplayServer.mouse_get_position()
				TabletPen.set_max_space(GVar.tablet_TRight) #sets max area for the "Pen" Blendpsace2D
				%DebugLabel.text = str("Top Right: ", GVar.tablet_TRight, ". Click the BOTTOM RIGHT corner..")
			#Bottom Right
			elif GVar.tablet_BRight == Vector2.ZERO:
				GVar.tablet_BRight = DisplayServer.mouse_get_position()
				%DebugLabel.text = str("Bottom Right: ", GVar.tablet_BRight, ". Click the BOTTOM LEFT corner..")
			#Bottom Left
			elif GVar.tablet_BLeft == Vector2.ZERO:
				GVar.tablet_BLeft = DisplayServer.mouse_get_position()
				%DebugLabel.text = str("Bottom Left: ", GVar.tablet_BLeft, ". Click the TOP LEFT corner..")
			#Top Left
			elif GVar.tablet_TLeft == Vector2.ZERO:
				GVar.tablet_TLeft = DisplayServer.mouse_get_position()
				TabletPen.set_min_space(GVar.tablet_TLeft) #sets min area for the "Pen" Blendpsace2D
				%TablerCaliButton.text = "Calibrating Finished."
				%TablerCaliButton.self_modulate = Color.GREEN
				%DebugLabel.text = str("Top Left: ", GVar.tablet_TLeft)
				$Timer.start()

# Resets text and saves calibrated points
func _on_timer_timeout() -> void:
	_sync_calibration()
	%TablerCaliButton.text = "Calibrate Tablet"
	%TablerCaliButton.self_modulate = Color(1,1,1,1)
	%DebugLabel.text = "GTuber Demo by PinkWisp"
	GVar.tablet_calibrated = true
	Settings.save_tablet_calibration("Tablet_Calibrated", GVar.tablet_calibrated)
	Settings.save_tablet_calibration("TopRight", GVar.tablet_TRight)
	Settings.save_tablet_calibration("BottomRight", GVar.tablet_BRight)
	Settings.save_tablet_calibration("BottomLeft", GVar.tablet_BLeft)
	Settings.save_tablet_calibration("TopLeft", GVar.tablet_TLeft)

# moves animated blendpoints to the corresponding coordinates
# to create a 1:1 movement with the cursor and pen
func _sync_calibration():
	var TabletPen = $TabletAniTree.get_tree_root().get_node("Pen")
	TabletPen.set_blend_point_position(0, GVar.tablet_TRight)
	TabletPen.set_blend_point_position(1, GVar.tablet_BRight)
	TabletPen.set_blend_point_position(2, GVar.tablet_TLeft)
	TabletPen.set_blend_point_position(3, GVar.tablet_BLeft)
