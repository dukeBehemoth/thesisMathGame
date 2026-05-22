extends Control

const Sections = preload("res://Scripts/Quiz/Sections.gd")

@onready var sections_list: VBoxContainer = %SectionsList
@onready var back_button: Button = %BackButton
@onready var select_all_button: Button = %SelectAllButton
@onready var deselect_all_button: Button = %DeselectAllButton
@onready var title_label: Label = %TitleLabel
@onready var notch_spacer: Control = %NotchSpacer

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	select_all_button.pressed.connect(_on_select_all)
	deselect_all_button.pressed.connect(_on_deselect_all)
	SettingsManager.settings_changed.connect(_populate_sections)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	resized.connect(_fit_ui)
	call_deferred("_fit_ui")
	_populate_sections()
	_apply_theme_colors()

func _populate_sections():
	for child in sections_list.get_children():
		sections_list.remove_child(child)
		child.queue_free()

	for sec in Sections.get_all():
		var card = _create_section_card(sec)
		sections_list.add_child(card)

func _create_section_card(sec) -> Panel:
	var panel = Panel.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.custom_minimum_size = Vector2(0, 40)

	var enabled = SettingsManager.is_section_enabled(sec.id)
	var bg = ThemeManager.get_button_color()
	var style = StyleBoxFlat.new()
	style.bg_color = bg if enabled else bg.darkened(0.3)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 16
	style.content_margin_right = 16
	panel.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND
	hbox.size_flags_vertical = Control.SIZE_EXPAND
	hbox.anchors_preset = Control.PRESET_FULL_RECT
	hbox.add_theme_constant_override("separation", 12)
	panel.add_child(hbox)

	var icon_label = Label.new()
	icon_label.text = sec.icon
	icon_label.add_theme_font_size_override("font_size", 24)
	icon_label.custom_minimum_size = Vector2(40, 0)
	icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	hbox.add_child(icon_label)

	var name_label = Label.new()
	name_label.text = sec.name
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	name_label.size_flags_horizontal = Control.SIZE_EXPAND
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(name_label)

	var toggle_label = Label.new()
	toggle_label.text = "Вкл" if enabled else "Выкл"
	toggle_label.add_theme_font_size_override("font_size", 14)
	toggle_label.add_theme_color_override("font_color", Color("#4caf50") if enabled else Color("#f44336"))
	toggle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	toggle_label.custom_minimum_size = Vector2(48, 0)
	toggle_label.anchors_preset = Control.PRESET_TOP_RIGHT
	toggle_label.anchor_left = 1.0
	toggle_label.anchor_right = 1.0
	toggle_label.offset_left = -56
	toggle_label.offset_right = -16
	toggle_label.offset_top = 6
	panel.add_child(toggle_label)

	panel.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			SettingsManager.toggle_section(sec.id)
	)

	return panel

func _fit_ui():
	var h = get_viewport().get_visible_rect().size.y
	notch_spacer.custom_minimum_size.y = max(h * 0.07, 30)

	var btn_h = clamp(h * 0.07, 36, 72)
	var font_sz = max(floor(btn_h * 0.42), 14)

	for btn in [back_button, select_all_button, deselect_all_button]:
		btn.custom_minimum_size.y = btn_h
		btn.add_theme_font_size_override("font_size", font_sz)

func _on_select_all():
	SettingsManager.set_all_sections(true)

func _on_deselect_all():
	SettingsManager.set_all_sections(false)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	_populate_sections()
	title_label.add_theme_color_override("font_color", ThemeManager.get_text_color())

	for btn in [back_button, select_all_button, deselect_all_button]:
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
