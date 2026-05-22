extends Node

class Achievement:
	var id: String
	var name: String
	var description: String
	var icon: String
	var unlocked: bool

	func _init(p_id: String, p_name: String, p_desc: String, p_icon: String):
		id = p_id
		name = p_name
		description = p_desc
		icon = p_icon
		unlocked = false

var achievements: Array = []
var _unlocked_ids: Array = []

signal achievement_unlocked(achievement_id)

const SAVE_PATH: String = "user://achievements.save"

func _ready():
	_define_achievements()
	load_achievements()

func _define_achievements():
	achievements = [
		Achievement.new("first_game", "Первые шаги", "Пройдите первую игру", "🎮"),
		Achievement.new("correct_5", "Быстрый старт", "Ответьте на 5 вопросов правильно", "✅"),
		Achievement.new("correct_50", "Искатель знаний", "Ответьте на 50 вопросов правильно", "📚"),
		Achievement.new("correct_200", "Учёный математик", "Ответьте на 200 вопросов правильно", "🎓"),
		Achievement.new("perfect_game", "Идеальный результат", "Ответьте на все вопросы в одной игре", "⭐"),
		Achievement.new("score_100", "Сотня", "Наберите 100 очков за одну игру", "💯"),
		Achievement.new("score_500", "Рекордсмен", "Наберите 500 очков за одну игру", "🔥"),
		Achievement.new("streak_5", "В огне", "Ответьте на 5 вопросов подряд", "🔥"),
		Achievement.new("streak_10", "Неудержимый", "Ответьте на 10 вопросов подряд", "💪"),
		Achievement.new("games_10", "Преданный", "Сыграйте 10 игр", "🎯"),
		Achievement.new("games_50", "Ветеран математики", "Сыграйте 50 игр", "🏆"),
		Achievement.new("days_3", "Постоянный игрок", "Играйте в течение 3 разных дней", "📅"),
		Achievement.new("days_7", "Недельный воин", "Играйте в течение 7 разных дней", "📅"),
		Achievement.new("days_30", "Преданный математике", "Играйте в течение 30 разных дней", "🗓️"),
		Achievement.new("accuracy_80", "Острый ум", "Достигните точности 80%+", "🧠"),
	]

func check_achievements(stats: StatsManager):
	var newly_unlocked = []

	if stats.total_games_played >= 1:
		newly_unlocked.append("first_game")
	if stats.total_correct >= 5:
		newly_unlocked.append("correct_5")
	if stats.total_correct >= 50:
		newly_unlocked.append("correct_50")
	if stats.total_correct >= 200:
		newly_unlocked.append("correct_200")
	if stats.total_games_played >= 10:
		newly_unlocked.append("games_10")
	if stats.total_games_played >= 50:
		newly_unlocked.append("games_50")
	if stats.best_score >= 100:
		newly_unlocked.append("score_100")
	if stats.best_score >= 500:
		newly_unlocked.append("score_500")
	if stats.best_streak >= 5:
		newly_unlocked.append("streak_5")
	if stats.best_streak >= 10:
		newly_unlocked.append("streak_10")
	if stats.get_accuracy() >= 80.0:
		newly_unlocked.append("accuracy_80")
	if stats.total_days_played >= 3:
		newly_unlocked.append("days_3")
	if stats.total_days_played >= 7:
		newly_unlocked.append("days_7")
	if stats.total_days_played >= 30:
		newly_unlocked.append("days_30")

	for ach_id in newly_unlocked:
		_unlock(ach_id)

func check_perfect_game():
	_unlock("perfect_game")

func _unlock(achievement_id: String):
	if achievement_id in _unlocked_ids:
		return
	for ach in achievements:
		if ach.id == achievement_id:
			ach.unlocked = true
			_unlocked_ids.append(achievement_id)
			achievement_unlocked.emit(achievement_id)
			save_achievements()
			return

func is_unlocked(achievement_id: String) -> bool:
	return achievement_id in _unlocked_ids

func get_achievement(id: String) -> Achievement:
	for ach in achievements:
		if ach.id == id:
			return ach
	return null

func save_achievements():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(_unlocked_ids)

func load_achievements():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		_unlocked_ids = file.get_var()
		for ach_id in _unlocked_ids:
			for ach in achievements:
				if ach.id == ach_id:
					ach.unlocked = true

func reset_all():
	_unlocked_ids.clear()
	for ach in achievements:
		ach.unlocked = false
	save_achievements()
