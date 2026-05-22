extends Node

const Sections = preload("res://Scripts/Quiz/Sections.gd")

var sound_volume: float = 0.8
var music_volume: float = 0.6
var difficulty: int = 1
var questions_per_game: int = 10
var enabled_sections: Array = []

signal settings_changed

const SAVE_PATH: String = "user://settings.save"

func _ready():
	enabled_sections = Sections.ALL_SECTIONS.duplicate()
	load_settings()

func apply_settings():
	settings_changed.emit()
	save_settings()

func set_sound_volume(value: float):
	sound_volume = clamp(value, 0.0, 1.0)
	apply_settings()

func set_music_volume(value: float):
	music_volume = clamp(value, 0.0, 1.0)
	apply_settings()

func set_difficulty(value: int):
	difficulty = clamp(value, 0, 2)
	apply_settings()

func set_questions_per_game(value: int):
	questions_per_game = clampi(value, 1, 100)
	apply_settings()

func toggle_section(section_id: String):
	if section_id in enabled_sections:
		enabled_sections.erase(section_id)
	else:
		enabled_sections.append(section_id)
	settings_changed.emit()
	save_settings()

func is_section_enabled(section_id: String) -> bool:
	return section_id in enabled_sections

func set_all_sections(enabled: bool):
	if enabled:
		enabled_sections = Sections.ALL_SECTIONS.duplicate()
	else:
		enabled_sections.clear()
	settings_changed.emit()
	save_settings()

func save_settings():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"sound_volume": sound_volume,
			"music_volume": music_volume,
			"difficulty": difficulty,
			"questions_per_game": questions_per_game,
			"enabled_sections": enabled_sections
		}
		file.store_var(data)

func load_settings():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = file.get_var()
		sound_volume = data.get("sound_volume", 0.8)
		music_volume = data.get("music_volume", 0.6)
		difficulty = data.get("difficulty", 1)
		questions_per_game = data.get("questions_per_game", 10)
		enabled_sections = data.get("enabled_sections", Sections.ALL_SECTIONS.duplicate())

func reset_defaults():
	sound_volume = 0.8
	music_volume = 0.6
	difficulty = 1
	questions_per_game = 10
	enabled_sections = Sections.ALL_SECTIONS.duplicate()
	apply_settings()
