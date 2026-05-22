extends Control

const QuestionBank = preload("res://Scripts/Quiz/QuestionBank.gd")

@onready var sound_slider: HSlider = %SoundSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var questions_spinbox: SpinBox = %QuestionsSpinBox
@onready var back_button: Button = %BackButton
@onready var sound_label: Label = %SoundLabel
@onready var music_label: Label = %MusicLabel
@onready var dark_mode_check: CheckButton = %DarkModeCheck
@onready var title_label: Label = %TitleLabel
@onready var questions_label: Label = %QuestionsLabel
@onready var reset_button: Button = %ResetDataButton
@onready var reset_confirm: ConfirmationDialog = %ResetConfirm

func _ready():
	sound_slider.value = SettingsManager.sound_volume * 100.0
	music_slider.value = SettingsManager.music_volume * 100.0
	questions_spinbox.value = SettingsManager.questions_per_game
	dark_mode_check.button_pressed = ThemeManager.is_dark
	sound_label.text = "Звук: " + str(int(sound_slider.value)) + "%"
	music_label.text = "Музыка: " + str(int(music_slider.value)) + "%"

	sound_slider.value_changed.connect(_on_sound_changed)
	music_slider.value_changed.connect(_on_music_changed)
	questions_spinbox.value_changed.connect(_on_questions_changed)
	back_button.pressed.connect(_on_back_pressed)
	dark_mode_check.toggled.connect(_on_dark_mode_toggled)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	reset_button.pressed.connect(_on_reset_pressed)
	reset_confirm.confirmed.connect(_on_reset_confirmed)
	reset_confirm.get_label().autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	get_tree().root.size_changed.connect(_on_screen_resized)
	_apply_theme_colors()

func _on_sound_changed(value: float):
	SettingsManager.set_sound_volume(value / 100.0)
	sound_label.text = "Звук: " + str(int(value)) + "%"

func _on_music_changed(value: float):
	SettingsManager.set_music_volume(value / 100.0)
	music_label.text = "Музыка: " + str(int(value)) + "%"

func _on_questions_changed(value: float):
	var clamped = clampi(int(value), 1, 100)
	if clamped != int(value):
		questions_spinbox.set_value_no_signal(clamped)
	SettingsManager.set_questions_per_game(clamped)
	GameManager.questions_per_game = clamped

func _on_dark_mode_toggled(button_pressed: bool):
	ThemeManager.set_dark_mode(button_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_screen_resized():
	if reset_confirm.visible:
		reset_confirm.popup_centered_clamped(Vector2i(360, 0), 0.9)

func _on_reset_pressed():
	reset_confirm.popup_centered_clamped(Vector2i(360, 0), 0.9)

func _on_reset_confirmed():
	SettingsManager.reset_defaults()
	SettingsManager.save_settings()
	ThemeManager.set_dark_mode(false)
	StatsManager.reset_all()
	AchievementsManager.reset_all()
	QuestionBank.clear_pool()

	sound_slider.value = SettingsManager.sound_volume * 100.0
	music_slider.value = SettingsManager.music_volume * 100.0
	questions_spinbox.value = SettingsManager.questions_per_game
	dark_mode_check.button_pressed = false
	sound_label.text = "Звук: " + str(int(sound_slider.value)) + "%"
	music_label.text = "Музыка: " + str(int(music_slider.value)) + "%"
	_apply_theme_colors()

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	dark_mode_check.button_pressed = ThemeManager.is_dark
	dark_mode_check.add_theme_color_override("font_color", ThemeManager.get_text_color())
	dark_mode_check.add_theme_color_override("font_hover_color", ThemeManager.get_text_color())
	dark_mode_check.add_theme_color_override("font_pressed_color", ThemeManager.get_text_color())
	dark_mode_check.add_theme_color_override("font_focus_color", ThemeManager.get_text_color())
	title_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	sound_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	music_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	questions_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	reset_button.add_theme_color_override("font_color", ThemeManager.get_text_color())
	reset_button.add_theme_color_override("font_hover_color", Color("#555555"))
	reset_button.add_theme_color_override("font_pressed_color", Color("#555555"))
	reset_button.add_theme_stylebox_override("normal", _make_button_style(ThemeManager.get_button_color()))
	reset_button.add_theme_stylebox_override("hover", _make_button_style(ThemeManager.get_button_color().lightened(0.3)))
	reset_button.add_theme_stylebox_override("pressed", _make_button_style(ThemeManager.get_button_color().darkened(0.2)))
	back_button.add_theme_color_override("font_color", ThemeManager.get_text_color())
	back_button.add_theme_color_override("font_hover_color", Color("#555555"))
	back_button.add_theme_color_override("font_pressed_color", Color("#555555"))
	back_button.add_theme_stylebox_override("normal", _make_button_style(ThemeManager.get_button_color()))
	back_button.add_theme_stylebox_override("hover", _make_button_style(ThemeManager.get_button_color().lightened(0.3)))
	back_button.add_theme_stylebox_override("pressed", _make_button_style(ThemeManager.get_button_color().darkened(0.2)))

func color_rect(name: String, color: Color):
	var rect = get_node_or_null(name) as ColorRect
	if rect:
		rect.color = color

func _make_button_style(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style
