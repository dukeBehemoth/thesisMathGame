extends Node

const H = preload("res://Scripts/Quiz/QuestionHelpers.gd")

static func generate(difficulty: int, count: int) -> Array:
	var questions = []
	for i in range(count):
		questions.append(_gen_problem(difficulty))
	return questions

static func _gen_problem(diff: int) -> Dictionary:
	match diff:
		0:
			var s = (randi() % 10 + 1) * 1000
			var p = [5, 8, 10, 12, 15][randi() % 5]
			var result = s + s * p / 100
			return H.make_question_custom("Вклад " + str(s) + " руб. под " + str(p) + "% годовых. Сколько рублей будет через 1 год?", result, [s * p / 100, s, s + s * p / 50], diff, "economics")
		1:
			var s = (randi() % 5 + 1) * 1000
			var p = [5, 10, 20][randi() % 3]
			var rate = 1.0 + float(p) / 100.0
			var result = int(s * rate * rate)
			return H.make_question_custom("Вклад " + str(s) + " руб. под " + str(p) + "% годовых (сложный процент). Сколько рублей будет через 2 года?", result, [int(s * rate), s + 2 * s * p / 100, int(s * rate * 2)], diff, "economics")
		2:
			var t = randi() % 2
			match t:
				0:
					var p1 = [10, 20, 30][randi() % 3]
					var p2 = [10, 20, 25][randi() % 3]
					var total = (100 + p1) * (100 + p2) / 100 - 100
					return H.make_question_custom("Цена повысилась на " + str(p1) + "%, затем на " + str(p2) + "%. На сколько процентов повысилась цена в итоге?", total, [p1 + p2, total + 100, p1 + p2 + p1 * p2 / 100], diff, "economics")
				1:
					var s = (randi() % 5 + 1) * 10000
					var p = [10, 15, 20][randi() % 3]
					var yearly = s * p / 100
					var months = [3, 4, 6, 12][randi() % 4]
					var profit = yearly * months / 12
					return H.make_question_custom("Вклад " + str(s) + " руб. под " + str(p) + "% годовых. Какой доход (в рублях) будет через " + str(months) + " месяцев?", profit, [yearly, s * p / 100 * months, profit * 2], diff, "economics")
				_:
					return {}
		_:
			return {}
