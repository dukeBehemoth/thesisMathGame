extends Node

var total_games_played: int = 0
var total_correct: int = 0
var total_wrong: int = 0
var best_score: int = 0
var best_streak: int = 0
var current_streak: int = 0
var total_days_played: int = 0
var last_play_date: String = ""
var section_stats: Dictionary = {}

const SAVE_PATH: String = "user://stats.save"

func _ready():
	load_stats()
	_check_daily()

func _check_daily():
	var today = Time.get_datetime_string_from_system(false, true).substr(0, 10)
	if last_play_date != today:
		total_days_played += 1
		last_play_date = today
		save_stats()

func record_game(correct: int, wrong: int, score: int, streak: int):
	total_games_played += 1
	total_correct += correct
	total_wrong += wrong
	if score > best_score:
		best_score = score
	if streak > best_streak:
		best_streak = streak
	save_stats()

func record_answer(section_id: String, is_correct: bool):
	if is_correct:
		current_streak += 1
	else:
		if current_streak > best_streak:
			best_streak = current_streak
		current_streak = 0
	if not section_stats.has(section_id):
		section_stats[section_id] = { "correct": 0, "wrong": 0 }
	if is_correct:
		section_stats[section_id].correct += 1
	else:
		section_stats[section_id].wrong += 1
	save_stats()

func get_section_stats(section_id: String) -> Dictionary:
	return section_stats.get(section_id, { "correct": 0, "wrong": 0 })

func get_section_accuracy(section_id: String) -> float:
	var s = get_section_stats(section_id)
	var total = s.correct + s.wrong
	if total == 0:
		return 0.0
	return float(s.correct) / float(total) * 100.0

func get_section_total(section_id: String) -> int:
	var s = get_section_stats(section_id)
	return s.correct + s.wrong

func get_accuracy() -> float:
	var total = total_correct + total_wrong
	if total == 0:
		return 0.0
	return float(total_correct) / float(total) * 100.0

func save_stats():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"total_games_played": total_games_played,
			"total_correct": total_correct,
			"total_wrong": total_wrong,
			"best_score": best_score,
			"best_streak": best_streak,
			"total_days_played": total_days_played,
			"last_play_date": last_play_date,
			"section_stats": section_stats,
		}
		file.store_var(data)

func load_stats():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = file.get_var()
		total_games_played = data.get("total_games_played", 0)
		total_correct = data.get("total_correct", 0)
		total_wrong = data.get("total_wrong", 0)
		best_score = data.get("best_score", 0)
		best_streak = data.get("best_streak", 0)
		total_days_played = data.get("total_days_played", 0)
		last_play_date = data.get("last_play_date", "")
		section_stats = data.get("section_stats", {})

func reset_all():
	total_games_played = 0
	total_correct = 0
	total_wrong = 0
	best_score = 0
	best_streak = 0
	current_streak = 0
	total_days_played = 0
	last_play_date = ""
	section_stats.clear()
	save_stats()
