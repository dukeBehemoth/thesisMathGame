extends Node

var is_dark: bool = false

signal theme_changed

const SAVE_PATH: String = "user://themes.save"
const SAVE_VERSION: int = 1

func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			if typeof(data) == TYPE_DICTIONARY and data.get("version", 0) >= SAVE_VERSION:
				is_dark = data.get("is_dark", false)

func get_bg_color() -> Color:
	return Color("#000000") if is_dark else Color("#d3d3d3")

func get_accent_color() -> Color:
	return Color("#e94560") if is_dark else Color("#1976d2")

func get_text_color() -> Color:
	return Color("#ffffff") if is_dark else Color("#000000")

func get_button_color() -> Color:
	return Color("#1a1a2e") if is_dark else Color("#e0e0e0")

func set_dark_mode(enabled: bool):
	if is_dark == enabled:
		return
	is_dark = enabled
	save_theme()
	theme_changed.emit()

func toggle():
	set_dark_mode(not is_dark)

func save_theme():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var({ "version": SAVE_VERSION, "is_dark": is_dark })


