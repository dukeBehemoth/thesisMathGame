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
			var a = randi() % 5 + 1
			var b = randi() % 10 + 1
			var x = randi() % 8 + 1
			var lhs = a * x + b
			return H.make_question_custom("Решите уравнение: " + str(a) + "x + " + str(b) + " = " + str(lhs) + ". Найдите x.", x, [x - 1, x + 1, -x], diff, "algebra")
		1:
			var a = randi() % 8 + 1
			var b = randi() % 15 + 1
			var c = randi() % 10 + 1
			var x = randi() % 10 + 1
			var lhs = a * x + b
			return H.make_question_custom("Решите уравнение: " + str(a) + "x + " + str(b) + " = " + str(lhs) + ". Найдите x.", x, [x - 1, x + 1, -x], diff, "algebra")
		2:
			if randi() % 2 == 0:
				var a = randi() % 8 + 1
				var b = randi() % 10 + 1
				var c = randi() % 10 + 1
				var x = randi() % 10 + 1
				var lhs = a * x + b
				var rhs = c * x + (lhs - c * x)
				return H.make_question_custom("Решите уравнение: " + str(a) + "x + " + str(b) + " = " + str(c) + "x + " + str(lhs - c * x) + ". Найдите x.", x, [x - 1, x + 1, -x], diff, "algebra")
			else:
				var x = randi() % 7 + 2
				var n = x * x
				return H.make_question_custom("Решите уравнение: x² = " + str(n) + ". Найдите x (x > 0).", x, [x - 1, x + 1, -x], diff, "algebra")
		_:
			return {}
