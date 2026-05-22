extends Control

const Sections = preload("res://Scripts/Quiz/Sections.gd")

@onready var title_label: Label = %TitleLabel
@onready var stats_container: VBoxContainer = %StatsContainer
@onready var back_button: Button = %BackButton
@onready var vbox: VBoxContainer = $VBox
@onready var notch_spacer: Control = %NotchSpacer

var stat_labels: Array[Label] = []
var section_stat_labels: Array[Label] = []

var stat_data: Array[Dictionary] = [
	{ "key": "games_played", "label": "Сыграно игр" },
	{ "key": "correct", "label": "Правильных ответов" },
	{ "key": "wrong", "label": "Неправильных ответов" },
	{ "key": "accuracy", "label": "Точность" },
	{ "key": "best_score", "label": "Лучший результат" },
	{ "key": "best_streak", "label": "Лучшая серия" },
	{ "key": "days_played", "label": "Дней сыграно" },
]

func _ready():
	var panel = _create_stat_panel()
	var inner_vbox = VBoxContainer.new()
	inner_vbox.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	inner_vbox.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	inner_vbox.add_theme_constant_override("separation", 14)

	for data in stat_data:
		var label = _create_stat_label(data.label)
		inner_vbox.add_child(label)
		stat_labels.append(label)

	panel.add_child(inner_vbox)
	stats_container.add_child(panel)

	var section_panel = _create_stat_panel()
	var section_vbox = VBoxContainer.new()
	section_vbox.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	section_vbox.add_theme_constant_override("separation", 10)

	for sec in Sections.get_all():
		var label = _create_stat_label(sec.icon + " " + sec.name)
		section_vbox.add_child(label)
		section_stat_labels.append(label)

	section_panel.add_child(section_vbox)
	stats_container.add_child(section_panel)
	back_button.pressed.connect(_on_back_pressed)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	resized.connect(_fit_ui)
	call_deferred("_fit_ui")
	_update_stats()
	_apply_theme_colors()

func _create_stat_panel() -> Panel:
	var panel = Panel.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.custom_minimum_size = Vector2i(0, 300)

	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 28
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)
	return panel

func _create_stat_label(text_prefix: String) -> Label:
	var label = Label.new()
	label.text = text_prefix + ": 0"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	label.add_theme_font_size_override("font_size", 20)
	return label

func _update_stats():
	var values = [
		str(StatsManager.total_games_played),
		str(StatsManager.total_correct),
		str(StatsManager.total_wrong),
		str(snapped(StatsManager.get_accuracy(), 0.1)) + "%",
		str(StatsManager.best_score),
		str(StatsManager.best_streak),
		str(StatsManager.total_days_played),
	]
	for i in stat_labels.size():
		stat_labels[i].text = stat_data[i].label + ": " + values[i]

	var idx = 0
	for sec in Sections.get_all():
		var s = StatsManager.get_section_stats(sec.id)
		var total = s.correct + s.wrong
		var acc = StatsManager.get_section_accuracy(sec.id)
		section_stat_labels[idx].text = sec.icon + " " + sec.name + ": " + str(s.correct) + "/" + str(total) + " (" + str(snapped(acc, 0.1)) + "%)"
		idx += 1

func _fit_ui():
	var h = get_viewport().get_visible_rect().size.y
	var scale = h / 900.0
	notch_spacer.custom_minimum_size.y = max(h * 0.07, 30)

	var btn_h = clamp(h * 0.07, 36, 72)
	var font_sz = max(floor(btn_h * 0.42), 14)
	back_button.custom_minimum_size.y = btn_h
	back_button.add_theme_font_size_override("font_size", font_sz)

	title_label.add_theme_font_size_override("font_size", floor(36 * scale))
	for lbl in stat_labels + section_stat_labels:
		lbl.add_theme_font_size_override("font_size", floor(20 * scale))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	title_label.add_theme_color_override("font_color", ThemeManager.get_text_color())

	var text_color = Color("#000000") if not ThemeManager.is_dark else Color("#ffffff")
	var panel_color = ThemeManager.get_button_color() as Color

	var panel = stats_container.get_child(0) if stats_container.get_child_count() > 0 else null
	if panel is Panel:
		var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
		if style:
			style.bg_color = panel_color

	for label in stat_labels:
		label.add_theme_color_override("font_color", text_color)

	var section_panel = stats_container.get_child(1) if stats_container.get_child_count() > 1 else null
	if section_panel is Panel:
		var section_style = section_panel.get_theme_stylebox("panel") as StyleBoxFlat
		if section_style:
			section_style.bg_color = panel_color

	for label in section_stat_labels:
		label.add_theme_color_override("font_color", text_color)

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
