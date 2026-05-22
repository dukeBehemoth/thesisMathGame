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
			var w = randi() % 8 + 2
			var h = randi() % 8 + 2
			return H.make_question_custom("Найдите площадь прямоугольника со сторонами " + str(w) + " и " + str(h) + ".", w * h, [(w + h) * 2, w + h, w * h + h], diff, "geometry")
		1:
			var type = randi() % 3
			match type:
				0:
					var r = randi() % 8 + 2
					return H.make_question_custom("Вычислите площадь круга радиусом " + str(r) + ". π ≈ 3,14", int(3.14 * r * r), [int(2 * 3.14 * r), int(3.14 * r), r * r], diff, "geometry")
				1:
					var a = randi() % 10 + 2
					var b = randi() % 10 + 2
					var h2 = int(sqrt(a * a + b * b))
					return H.make_question_custom("По теореме Пифагора найдите гипотенузу: √(" + str(a) + "² + " + str(b) + "²)", h2, [a + b, h2 + 1, h2 - 1], diff, "geometry")
				2:
					var s = randi() % 10 + 3
					return H.make_question_custom("Найдите периметр квадрата со стороной " + str(s) + ".", s * 4, [s, s * 2, s * s], diff, "geometry")
				_:
					return H.make_question("", 0, diff, "geometry")
		2:
			var r = randi() % 6 + 3
			var h = randi() % 8 + 3
			return H.make_question_custom("Найдите объём цилиндра: π × " + str(r) + "² × " + str(h) + " (π ≈ 3)", 3 * r * r * h, [3 * r * h, 3 * r * r, 3 * 2 * r * h], diff, "geometry")
		_:
			return {}
