extends Control

@onready var grid: GridContainer = %AchievementsGrid
@onready var back_button: Button = %BackButton
@onready var title_label: Label = %TitleLabel
@onready var notch_spacer: Control = %NotchSpacer

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	resized.connect(_fit_ui)
	call_deferred("_fit_ui")
	call_deferred("_populate_achievements")
	_apply_theme_colors()

func _populate_achievements():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	grid.columns = clampi(int(grid.size.x / 180), 1, 3)

	for ach in AchievementsManager.achievements:
		var card = _create_achievement_card(ach)
		grid.add_child(card)

func _create_achievement_card(ach) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.custom_minimum_size = Vector2(200, 90)

	var style = StyleBoxFlat.new()
	style.bg_color = ThemeManager.get_button_color()
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	panel.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 5)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	panel.add_child(vbox)

	var icon_label = Label.new()
	icon_label.text = ach.icon + "  " + ach.name
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon_label.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	icon_label.add_theme_font_size_override("font_size", 16)
	icon_label.add_theme_color_override("font_color", ThemeManager.get_text_color() if ach.unlocked else Color.GRAY)
	vbox.add_child(icon_label)

	var desc_label = Label.new()
	desc_label.text = ach.description
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	desc_label.add_theme_font_size_override("font_size", 13)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_label.add_theme_color_override("font_color", ThemeManager.get_text_color() if ach.unlocked else Color.GRAY)
	vbox.add_child(desc_label)

	if ach.unlocked:
		var unlock_label = Label.new()
		unlock_label.text = "✓ ОТКРЫТО"
		unlock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unlock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		unlock_label.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		unlock_label.add_theme_font_size_override("font_size", 13)
		unlock_label.add_theme_color_override("font_color", Color("#4caf50"))
		vbox.add_child(unlock_label)
	else:
		var lock_label = Label.new()
		lock_label.text = "🔒 ЗАКРЫТО"
		lock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lock_label.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		lock_label.add_theme_font_size_override("font_size", 13)
		lock_label.add_theme_color_override("font_color", Color("#757575"))
		vbox.add_child(lock_label)

	return panel

func _fit_ui():
	var h = get_viewport().get_visible_rect().size.y
	notch_spacer.custom_minimum_size.y = max(h * 0.07, 30)

	var btn_h = clamp(h * 0.07, 36, 72)
	var font_sz = max(floor(btn_h * 0.42), 14)
	back_button.custom_minimum_size.y = btn_h
	back_button.add_theme_font_size_override("font_size", font_sz)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	title_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
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
