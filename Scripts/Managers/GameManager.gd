extends Node

const QuestionBank = preload("res://Scripts/Quiz/QuestionBank.gd")

enum Difficulty { EASY, MEDIUM, HARD }

var difficulty: Difficulty = Difficulty.MEDIUM
var questions_per_game: int = 10
var current_score: int = 0
var current_question: int = 0
var correct_count: int = 0
var current_questions: Array = []

signal score_changed(new_score)
signal question_updated(current, total)
signal game_started
signal game_ended

func start_game():
	current_score = 0
	current_question = 0
	correct_count = 0
	questions_per_game = SettingsManager.questions_per_game
	current_questions = QuestionBank.get_questions(difficulty, questions_per_game, SettingsManager.enabled_sections)
	game_started.emit()

func submit_answer(answer_index: int) -> Dictionary:
	var question = current_questions[current_question]
	var is_correct = answer_index == question.correct_index
	if is_correct:
		current_score += _calculate_points()
		correct_count += 1
		score_changed.emit(current_score)
	current_question += 1
	if current_question >= current_questions.size():
		game_ended.emit()
	else:
		question_updated.emit(current_question, current_questions.size())
	return { "correct": is_correct, "correct_index": question.correct_index }

func get_current_question() -> Dictionary:
	if current_question < current_questions.size():
		return current_questions[current_question]
	return {}

func get_accuracy() -> float:
	if current_question == 0:
		return 0.0
	return float(correct_count) / float(current_question) * 100.0

func _calculate_points() -> int:
	match difficulty:
		Difficulty.EASY:
			return 10
		Difficulty.MEDIUM:
			return 20
		Difficulty.HARD:
			return 35
	return 10

func _ready():
	if OS.get_name() == "Android":
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)

func reset():
	current_score = 0
	current_question = 0
	correct_count = 0
	current_questions = []
