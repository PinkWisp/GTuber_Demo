extends BoxContainer
# This probably could be optimized better... 
# but if it aint broke dont fix it!

var selected_threshold : String = "" # W, N, L. Holds which threshold is selected
var colorNull = Color(1,1,1,1) # removes color changes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets Values to saved thresholds
	%WSlider.value = GVar.w_threshold
	%NSlider.value = GVar.n_threshold
	%LSlider.value = GVar.l_threshold

func _process(delta):
	# check if selected threhold's value are valid
	# does not let inputslider move into invalid ranges
	if %InputSlider.get_modulate() == Color.RED:
		if selected_threshold == "W":
			%InputSlider.value = %NSlider.value #WSlider maxes at NSlider
		if selected_threshold == "N":
			if %InputSlider.value < %WSlider.value:
				%InputSlider.value = %WSlider.value #NSlider mins at WSlider
			if %InputSlider.value > %LSlider.value:
				%InputSlider.value = %LSlider.value #NSlider maxes at LSlider
		if selected_threshold == "L":
			%InputSlider.value = %NSlider.value #LSlider mins at NSlider
			
	# Change slider color as mic hits thresholds
	if selected_threshold == "":
		if GVar.mic_value > %LSlider.value:
			%LSlider.set_modulate(Color.RED)
		elif GVar.mic_value > %NSlider.value && GVar.mic_value > %WSlider.value:
			%NSlider.set_modulate(Color.YELLOW)
		elif GVar.mic_value > %WSlider.value:
			%WSlider.set_modulate(Color.GREEN)
		elif GVar.mic_value < %WSlider.value:
			%WSlider.set_modulate(colorNull)
			%NSlider.set_modulate(colorNull)
			%LSlider.set_modulate(colorNull)

# When dragging InputSlider
func _on_input_slider_value_changed(value):
	if selected_threshold == "W":
		%WButton.text = str(value)
		if value >= %NSlider.value:
			%InputSlider.set_modulate(Color.RED) #changes InputSlider to Red for range checks
			%WButton.set_modulate(Color.RED)
			%SliderTimer.start() #sets timer to remove red tint
		else:
			%InputSlider.set_modulate(colorNull)
			%WButton.set_modulate(Color.GREEN)
	if selected_threshold == "N":
		%NButton.text = str(value)
		if value >= %LSlider.value || value <= %WSlider.value:
			%InputSlider.set_modulate(Color.RED)
			%NButton.set_modulate(Color.RED)
			%SliderTimer.start()
		else:
			%InputSlider.set_modulate(colorNull)
			%NButton.set_modulate(Color.GREEN)
	if selected_threshold == "L":
		%LButton.text = str(value)
		if value <= %NSlider.value:
			%InputSlider.set_modulate(Color.RED)
			%LButton.set_modulate(Color.RED)
			%SliderTimer.start()
		else:
			%InputSlider.set_modulate(colorNull)
			%LButton.set_modulate(Color.GREEN)

# Desync InputSlider from Threhold Slider, unselect buttons
func _on_input_slider_drag_ended(value_changed):
	if value_changed:
		%WButton.text = "W"
		%NButton.text = "N"
		%LButton.text = "L"
		_input_slider_off()
		selected_threshold = ""
		%SliderTimer.start()

func _on_w_button_mouse_entered():
	%WSlider.self_modulate = Color.GREEN
	%WButton.text = str(%WSlider.value)
	if %WSlider.get_modulate() == colorNull:
		if selected_threshold == "W" || selected_threshold == "":
			%InputSlider.value = %WSlider.value
			%WSlider.set_modulate(Color.GREEN)
	
func _on_w_button_mouse_exited():
	%WSlider.self_modulate = colorNull
	%WButton.text = "W"
	if !selected_threshold == "W":
		if !%WSlider.get_modulate() == colorNull:
			%WSlider.set_modulate(colorNull)
	
func _on_w_button_pressed():
	selected_threshold = "W"
	_input_slider_active()
	%WSlider.grab_focus()
	_clear_grabbers()

func _on_n_button_mouse_entered():
	%NSlider.self_modulate = Color.GREEN
	%NButton.text = str(%NSlider.value)
	if %NSlider.get_modulate() == (colorNull):
		if selected_threshold == "N" || selected_threshold == "":
			%InputSlider.value = %NSlider.value
			%NSlider.set_modulate(Color.GREEN)
	
func _on_n_button_mouse_exited():
	%NSlider.self_modulate = colorNull
	%NButton.text = "N"
	if !selected_threshold == "N":
		if !%NSlider.get_modulate() == (colorNull):
			%NSlider.set_modulate(colorNull)
	
func _on_n_button_pressed():
	selected_threshold = "N"
	_input_slider_active()
	_clear_grabbers()


func _on_l_button_mouse_entered():
	%LSlider.self_modulate = Color.GREEN
	%LButton.text = str(%LSlider.value)
	if %LSlider.get_modulate() == (colorNull):
		if selected_threshold == "L" || selected_threshold == "":
			%InputSlider.value = %LSlider.value
			%LSlider.set_modulate(Color.GREEN)

func _on_l_button_mouse_exited():
	%LSlider.self_modulate = colorNull
	%LButton.text = "L"
	if !selected_threshold == "L":
		if !%LSlider.get_modulate() == (colorNull):
			%LSlider.set_modulate(colorNull)

func _on_l_button_pressed():
	selected_threshold = "L"
	_input_slider_active()
	_clear_grabbers()

# Sync InputSlider and Threhold Sliders
func _input_slider_active():
	%InputSlider.editable = true
	%InputSlider.visible = true
	if selected_threshold == "W":
		%InputSlider.value = %WSlider.value
	if selected_threshold == "N":
		%InputSlider.value = %NSlider.value
	if selected_threshold == "L":
		%InputSlider.value = %LSlider.value
		
# On InputSlider value changed, change selected threshold to that value
func _input_slider_off():
	%InputSlider.editable = false #editable off so no accidental changes
	%InputSlider.visible = false #hides InputSlider
	if selected_threshold == "W":
		%WSlider.value = %InputSlider.value
		GVar.w_threshold = %InputSlider.value
		Settings.save_mic_settings("Whisper", GVar.w_threshold) #save global variable after change
	if selected_threshold == "N":
		%NSlider.value = %InputSlider.value
		GVar.n_threshold = %InputSlider.value
		Settings.save_mic_settings("Normal", GVar.n_threshold)
	if selected_threshold == "L":
		%LSlider.value = %InputSlider.value
		GVar.l_threshold = %InputSlider.value
		Settings.save_mic_settings("Loud", GVar.l_threshold)

# Clears NOT selected threhold of color changes
func _clear_grabbers():
	if selected_threshold == "W":
		%WButton.set_modulate(Color.GREEN)
		%NButton.set_modulate(colorNull)
		%LButton.set_modulate(colorNull)
		
		%WSlider.set_modulate(Color.GREEN)
		%NSlider.set_modulate(colorNull)
		%LSlider.set_modulate(colorNull)
	elif selected_threshold == "N":
		%WButton.set_modulate(colorNull)
		%NButton.set_modulate(Color.GREEN)
		%LButton.set_modulate(colorNull)
		
		%WSlider.set_modulate(colorNull)
		%NSlider.set_modulate(Color.GREEN)
		%LSlider.set_modulate(colorNull)
	elif selected_threshold == "L":
		%WButton.set_modulate(colorNull)
		%NButton.set_modulate(colorNull)
		%LButton.set_modulate(Color.GREEN)
		
		%WSlider.set_modulate(colorNull)
		%NSlider.set_modulate(colorNull)
		%LSlider.set_modulate(Color.GREEN)
	elif selected_threshold == "":
		%WButton.set_modulate(colorNull)
		%NButton.set_modulate(colorNull)
		%LButton.set_modulate(colorNull)
		
		%WSlider.set_modulate(colorNull)
		%NSlider.set_modulate(colorNull)
		%LSlider.set_modulate(colorNull)

# Clear color changes and selected threhold at timeout
func _on_slider_timer_timeout():
	if %InputSlider.get_modulate() == Color.RED:
		%InputSlider.set_modulate(colorNull)
	selected_threshold = ""
	_clear_grabbers()
