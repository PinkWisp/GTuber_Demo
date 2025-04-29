extends Node

var config = ConfigFile.new()
const settingsPath = "user://settings.ini"

# Save Global Variables to Settings
func _ready():
	if !FileAccess.file_exists(settingsPath): #makes settings.ini file
		# Mic Settings. Thresholds, Selected Mic
		config.set_value("Mic", "Whisper", GVar.w_threshold)
		config.set_value("Mic", "Normal", GVar.n_threshold)
		config.set_value("Mic", "Loud", GVar.l_threshold)
		config.set_value("Mic", "Start_Up", GVar.user_mic)
		# Tablet Calibration
		config.set_value("Tablet", "Tablet_Calibrated", GVar.tablet_calibrated)
		config.set_value("Tablet", "TopRight", GVar.tablet_TRight)
		config.set_value("Tablet", "BottomRight", GVar.tablet_BRight)
		config.set_value("Tablet", "BottomLeft", GVar.tablet_BLeft)
		config.set_value("Tablet", "TopLeft", GVar.tablet_TLeft)
		
		config.save(settingsPath)
	else:
		config.load(settingsPath) #load usesr settings
		load_mic_settings() #set mic settings to global variables
		print("Settings Loaded. Path: ", settingsPath)

func save_mic_settings(key: String, value):
	config.set_value("Mic", key, value)
	config.save(settingsPath)
	print("Settings Saved: ", key, ": ", value)
	
func save_tablet_calibration(key: String, value):
	config.set_value("Tablet", key, value)
	config.save(settingsPath)
	print("Settings Saved: ", key, ": ", value)
	
func load_mic_settings():
	GVar.w_threshold = Settings.config.get_value("Mic", "Whisper")
	GVar.n_threshold = Settings.config.get_value("Mic", "Normal")
	GVar.l_threshold = Settings.config.get_value("Mic", "Loud")
	GVar.user_mic = Settings.config.get_value("Mic", "Start_Up")
	print("Load Prev Mic: ", GVar.user_mic)
	print("Loaded Prev Mic Settings...")
	print("W Threshold: ", GVar.w_threshold)
	print("N Threshold: ", GVar.n_threshold)
	print("L Threshold: ", GVar.l_threshold)

func load_tablet_calibration():
	GVar.tablet_calibrated = Settings.config.get_value("Tablet", "Tablet_Calibrated")
	GVar.tablet_TRight = Settings.config.get_value("Tablet", "TopRight")
	GVar.tablet_BRight = Settings.config.get_value("Tablet", "BottomRight")
	GVar.tablet_TLeft = Settings.config.get_value("Tablet", "BottomLeft")
	GVar.tablet_BLeft = Settings.config.get_value("Tablet", "TopLeft")
	print("Load Tablet Calibration: ", GVar.tablet_calibrated)
	print("TopRight: ", GVar.tablet_TRight)
	print("BottomRight: ", GVar.tablet_BRight)
	print("BottomLeft: ", GVar.tablet_TLeft )
	print("TopLeft: ", GVar.tablet_BLeft )
