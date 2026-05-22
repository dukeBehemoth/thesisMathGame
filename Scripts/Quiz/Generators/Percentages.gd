extends Node

const H = preload("res://Scripts/Quiz/QuestionHelpers.gd")

static func generate(difficulty: int, count: int) -> Array:
	var questions = []
	for i in range(count):
		questions.append(_gen_problem(difficulty))
	return questions

static 		func _gen_problem(diff: int) -> Dictionary:
	match diff:
		0:
			var p = [10, 20, 25, 50][randi() % 4]
			var n = (randi() % 5 + 2) * (100 / p)
			var ans = n * p / 100
			return H.make_question_custom("Сколько будет " + str(p) + "% от " + str(n) + "?", ans, [n * p, n / p, n * p / 10], diff, "percentages")
		1:
			var t = randi() % 2
			match t:
				0:
					var part = randi() % 30 + 10
					var whole = part * (randi() % 3 + 2)
					var ans = 100 * part / whole
					return H.make_question_custom("Сколько процентов составляет " + str(part) + " от " + str(whole) + "?", ans, [part * 100, 100 / whole * part, part * whole / 100], diff, "percentages")
				1:
					var v = (randi() % 20 + 5) * 5
					var pct = [10, 20, 25, 30, 40, 50][randi() % 6]
					var ans = v + v * pct / 100
					return H.make_question_custom("Увеличьте " + str(v) + " на " + str(pct) + "%. Найдите новое значение.", ans, [v * pct / 100, v + pct, v + v * pct / 50], diff, "percentages")
				_:
					return {}
		2:
			var t = randi() % 2
			match t:
				0:
					var old = (randi() % 10 + 5) * 20
					var pct_change = [10, 15, 20, 25, 30][randi() % 5]
					var new_v = old + old * pct_change / 100
					var ans = (new_v - old) * 100 / old
					return H.make_question_custom("Значение выросло с " + str(old) + " до " + str(new_v) + ". На сколько процентов увеличилось?", ans, [(new_v - old) * 100 / new_v, (new_v - old) * 100, pct_change], diff, "percentages")
				1:
					var whole = randi() % 20 + 10
					var ratio_a = randi() % 3 + 1
					var ratio_b = randi() % 3 + 1
					var part_a = whole * ratio_a / (ratio_a + ratio_b)
					var big = max(part_a, whole - part_a)
					return H.make_question_custom("Разделите " + str(whole) + " в отношении " + str(ratio_a) + ":" + str(ratio_b) + ". Найдите большую часть.", big, [whole - big, whole * ratio_a / ratio_b, whole], diff, "percentages")
				_:
					return {}
		_:
			return {}
