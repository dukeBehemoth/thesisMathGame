extends Control

@onready var question_label: Label = %QuestionLabel
@onready var equation_label: Label = %EquationLabel
@onready var answer_buttons: GridContainer = %AnswerButtons
@onready var score_label: Label = %ScoreLabel
@onready var progress_label: Label = %ProgressLabel
@onready var feedback_label: Label = %FeedbackLabel
@onready var exit_button: Button = %ExitButton

var _button_group: ButtonGroup
var _answering: bool = false
var _current_streak: int = 0
var _correct_in_game: int = 0
var _wrong_in_game: int = 0
var _btn_h: float = 64
var _btn_font_sz: float = 22

func _ready():
	_button_group = ButtonGroup.new()
	exit_button.pressed.connect(_on_quit_pressed)
	ThemeManager.theme_changed.connect(_apply_theme_colors)
	resized.connect(_fit_ui)
	call_deferred("_fit_ui")
	_start_new_game()
	_apply_theme_colors()

func _fit_ui():
	var h = get_viewport().get_visible_rect().size.y
	var safe_top = max(h * 0.07, 30)

	$TopBar.offset_top = safe_top
	$TopBar.offset_bottom = safe_top + 46
	$VBox.offset_top = safe_top + 46

	_btn_h = clamp(h * 0.08, 48, 96)
	_btn_font_sz = max(floor(_btn_h * 0.38), 16)
	exit_button.custom_minimum_size.y = _btn_h
	exit_button.add_theme_font_size_override("font_size", _btn_font_sz - 4)

func _start_new_game():
	GameManager.start_game()
	_correct_in_game = 0
	_wrong_in_game = 0
	_current_streak = 0
	feedback_label.text = ""
	feedback_label.add_theme_color_override("font_color", Color.WHITE)
	_answering = false
	_show_question()

func _show_question():
	var q = GameManager.get_current_question()
	if q.is_empty():
		return

	var parts = q.question_text.split(": ", true, 1)
	if parts.size() > 1:
		question_label.text = parts[0].strip_edges()
		equation_label.text = parts[1].strip_edges()
	else:
		question_label.text = q.question_text
		equation_label.text = ""
	progress_label.text = "Вопрос " + str(GameManager.current_question + 1) + " / " + str(GameManager.questions_per_game)
	score_label.text = "Счёт: " + str(GameManager.current_score)

	for child in answer_buttons.get_children():
		answer_buttons.remove_child(child)
		child.queue_free()

	for i in range(q.answers.size()):
		var btn = Button.new()
		btn.text = q.answers[i]
		btn.button_group = _button_group
		btn.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		btn.custom_minimum_size = Vector2(0, _btn_h)
		btn.add_theme_font_size_override("font_size", _btn_font_sz)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.pressed.connect(_on_answer_pressed.bind(i, btn))
		_apply_button_theme(btn)
		answer_buttons.add_child(btn)

func _on_answer_pressed(index: int, btn: Button):
	if _answering:
		return
	_answering = true

	var q = GameManager.get_current_question()
	var correct_answer = q.answers[q.correct_index] if not q.is_empty() else ""

	for child in answer_buttons.get_children():
		child.disabled = true

	var result = GameManager.submit_answer(index)
	var is_correct = result.correct

	if is_correct:
		_current_streak += 1
		_correct_in_game += 1
		feedback_label.text = "Правильно! +" + str(GameManager._calculate_points()) + " баллов"
		feedback_label.add_theme_color_override("font_color", Color("#4caf50"))
	else:
		_current_streak = 0
		_wrong_in_game += 1
		feedback_label.text = "Неправильно! Правильный ответ: " + correct_answer
		feedback_label.add_theme_color_override("font_color", Color("#f44336"))

	StatsManager.record_answer(q.section, is_correct)

	if GameManager.current_question >= GameManager.current_questions.size():
		_end_game()
	else:
		await get_tree().create_timer(1.0).timeout
		_answering = false
		_show_question()

func _end_game():
	feedback_label.text = "Игра окончена! Итоговый счёт: " + str(GameManager.current_score)

	var perfect = GameManager.correct_count == GameManager.questions_per_game
	StatsManager.record_game(_correct_in_game, _wrong_in_game, GameManager.current_score, _current_streak)
	AchievementsManager.check_achievements(StatsManager)
	if perfect:
		AchievementsManager.check_perfect_game()

	var continue_btn = Button.new()
	continue_btn.text = "Играть снова"
	continue_btn.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	continue_btn.custom_minimum_size = Vector2(0, _btn_h)
	continue_btn.add_theme_font_size_override("font_size", _btn_font_sz)
	continue_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	continue_btn.pressed.connect(_start_new_game)
	_apply_button_theme(continue_btn)
	answer_buttons.add_child(continue_btn)

	var menu_btn = Button.new()
	menu_btn.text = "Главное меню"
	menu_btn.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	menu_btn.custom_minimum_size = Vector2(0, _btn_h)
	menu_btn.add_theme_font_size_override("font_size", _btn_font_sz)
	menu_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://Scenes/main_menu.tscn"))
	_apply_button_theme(menu_btn)
	answer_buttons.add_child(menu_btn)

	score_label.text = "Итоговый счёт: " + str(GameManager.current_score)

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _apply_theme_colors():
	color_rect("BackgroundColor", ThemeManager.get_bg_color())
	question_label.add_theme_color_override("font_color", ThemeManager.get_accent_color())
	equation_label.add_theme_color_override("font_color", ThemeManager.get_accent_color())
	score_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	progress_label.add_theme_color_override("font_color", ThemeManager.get_text_color())
	exit_button.add_theme_color_override("font_color", ThemeManager.get_text_color())
	exit_button.add_theme_color_override("font_hover_color", Color("#555555"))
	exit_button.add_theme_color_override("font_pressed_color", Color("#555555"))
	exit_button.add_theme_stylebox_override("normal", _make_button_style(ThemeManager.get_button_color()))
	exit_button.add_theme_stylebox_override("hover", _make_button_style(ThemeManager.get_button_color().lightened(0.3)))
	exit_button.add_theme_stylebox_override("pressed", _make_button_style(ThemeManager.get_button_color().darkened(0.2)))
	for child in answer_buttons.get_children():
		if child is Button:
			_apply_button_theme(child)

func _apply_button_theme(btn: Button):
	btn.add_theme_color_override("font_color", ThemeManager.get_text_color())
	btn.add_theme_color_override("font_hover_color", Color("#555555"))
	btn.add_theme_color_override("font_pressed_color", Color("#555555"))
	var normal_style = _make_button_style(ThemeManager.get_button_color())
	var hover_style = _make_button_style(ThemeManager.get_button_color().lightened(0.3))
	var pressed_style = _make_button_style(ThemeManager.get_button_color().darkened(0.2))
	btn.add_theme_stylebox_override("normal", normal_style)
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_stylebox_override("pressed", pressed_style)

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
