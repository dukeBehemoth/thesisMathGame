extends Control

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var stats_button: Button = %StatsButton
@onready var achievements_button: Button = %AchievementsButton
@onready var theme_button: Button = %ThemeButton
@onready var quit_button: Button = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var vbox: VBoxContainer = $VBox
@onready var notch_spacer: Control = %NotchSpacer

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	stats_button.pressed.connect(_on_stats_pressed)
	achievements_button.pressed.connect(_on_achievements_pressed)
	theme_button.pressed.connect(_on_theme_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	title_label.resized.connect(_fit_title_font_size)
	resized.connect(_fit_ui)
	call_deferred("_fit_title_font_size")
	call_deferred("_fit_ui")
	_apply_theme_colors()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/task_screen.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_stats_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn")

func _on_achievements_pressed():
	get_tree().change_scene_to_file("res://Scenes/achievements.tscn")

func _on_theme_pressed():
	get_tree().change_scene_to_file("res://Scenes/theme_selection.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_theme_changed():
	_apply_theme_colors()

func _fit_ui():
	var vp_size = get_viewport().get_visible_rect().size
	var h = vp_size.y

	notch_spacer.custom_minimum_size.y = max(h * 0.07, 30)

	var sep = vbox.get_theme_constant("separation")
	var total_sep = sep * 8
	var title_min_h = title_label.get_minimum_size().y
	var spacer_h = $VBox/Spacer.custom_minimum_size.y
	var available_h = h - notch_spacer.custom_minimum_size.y - title_min_h - spacer_h - total_sep

	var buttons = [start_button, settings_button, stats_button, achievements_button, theme_button, quit_button]
	var btn_count = buttons.size()

	if btn_count > 0 and available_h > 0:
		var btn_h = available_h / btn_count
		var font_sz = max(floor(btn_h * 0.42), 14)

		for btn in buttons:
			btn.custom_minimum_size.y = btn_h
			btn.add_theme_font_size_override("font_size", font_sz)

func _fit_title_font_size():
	var font = title_label.get_theme_default_font()
	if not font:
		return
	var available = title_label.size.x - 16
	if available <= 0:
		return
	var text = title_label.text
	for size in range(48, 7, -1):
		var w = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		if w <= available:
			title_label.add_theme_font_size_override("font_size", size)
			return

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	title_label.add_theme_color_override("font_color", ThemeManager.get_accent_color())
	_fit_title_font_size()
	for btn in [start_button, settings_button, stats_button, achievements_button, theme_button, quit_button]:
		btn.add_theme_color_override("font_color", ThemeManager.get_text_color())
		btn.add_theme_color_override("font_hover_color", Color("#555555"))
		btn.add_theme_color_override("font_pressed_color", Color("#555555"))
		btn.add_theme_stylebox_override("normal", _make_button_style(ThemeManager.get_button_color()))
		btn.add_theme_stylebox_override("hover", _make_button_style(ThemeManager.get_button_color().lightened(0.3)))
		btn.add_theme_stylebox_override("pressed", _make_button_style(ThemeManager.get_button_color().darkened(0.2)))

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
