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
			var b = randi() % 5 + 1
			var c = randi() % 5 + 1
			var a = b / c if b % c == 0 else 1
			return H.make_question_custom("При каком значении a уравнение a·x = " + str(b) + " имеет корень x = " + str(c) + "?", a, [b, c, b * c], diff, "parameters")
		1:
			var b = (randi() % 5 + 2) * 2
			var a = b * b / 4
			return H.make_question_custom("При каком значении a уравнение x² + " + str(b) + "x + a = 0 имеет ровно один корень?", a, [b, b * b, b / 2], diff, "parameters")
		2:
			var t = randi() % 2
			match t:
				0:
					var a = randi() % 5 + 1
					var c = randi() % 5 + 1
					var b = a * c
					return H.make_question_custom("При каком значении a уравнение a·x = " + str(b) + " имеет корень x = " + str(c) + "?", a, [b, c, b * c], diff, "parameters")
				1:
					var k = randi() % 3 + 2
					var d = k * k
					return H.make_question_custom("При каком a уравнение (a − " + str(k) + ")x = " + str(d) + " не имеет решений?", k, [d, k + 1, k - 1], diff, "parameters")
				_:
					return {}
		_:
			return {}
