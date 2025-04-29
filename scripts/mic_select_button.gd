extends OptionButton

func _ready():
	for mic in AudioServer.get_input_device_list(): #List all mic
		add_item(mic) #add mics to OptionButton
	
	if !GVar.user_mic == "": #Check if a mic was previously saved
		AudioServer.set_input_device(GVar.user_mic) #set saved mic to global variable
	
# Change mic to indexed list
func _on_item_selected(index):
	var selected_mic = AudioServer.get_input_device_list() [index]
	AudioServer.set_input_device(selected_mic)
	GVar.user_mic = selected_mic #set global variable to indexed mic
	Settings.save_mic_settings("Start_Up", GVar.user_mic) #saves global variable to settings
	print("New Mic Selected: ", "[",index, "] ", selected_mic)
