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
			var t = randi() % 3
			match t:
				0:
					return H.make_question_custom("Вычислите: sin²30° + cos²30°", 1, [0, 2, 3], diff, "trigonometry")
				1:
					return H.make_question_custom("Вычислите: sin 90°", 1, [0, 2, 3], diff, "trigonometry")
				2:
					return H.make_question_custom("Вычислите: tg 45°", 1, [0, 2, 3], diff, "trigonometry")
				_:
					return {}
		1:
			var t = randi() % 3
			match t:
				0:
					return H.make_question_custom("Вычислите: 2sin 90° + cos 0°", 3, [1, 2, 4], diff, "trigonometry")
				1:
					var a = randi() % 3 + 1
					return H.make_question_custom("Вычислите: " + str(a) + "sin²30° + " + str(a) + "cos²30°", a, [0, a + 1, 2 * a], diff, "trigonometry")
				2:
					return H.make_question_custom("Вычислите: 2tg45° + 2ctg45°", 4, [0, 2, 8], diff, "trigonometry")
				_:
					return {}
		2:
			var t = randi() % 3
			match t:
				0:
					return H.make_question_custom("Вычислите: 2sin²45° + 4cos²45°", 3, [1, 2, 6], diff, "trigonometry")
				1:
					return H.make_question_custom("Вычислите: (sin30° + cos60°) × tg45°", 1, [0, 2, 3], diff, "trigonometry")
				2:
					return H.make_question_custom("Вычислите: sin30° × cos60° + sin60° × cos30°", 1, [0, 2, 3], diff, "trigonometry")
				_:
					return {}
		_:
			return {}
