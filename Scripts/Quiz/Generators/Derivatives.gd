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
			var x0 = 1
			var f_prime = 2 * a * x0 + b
			return H.make_question_custom("Найдите значение производной функции f(x) = " + str(a) + "x² + " + str(b) + "x в точке x₀ = 1.", f_prime, [a + b, 2 * a, f_prime + 1], diff, "derivatives")
		1:
			var t = randi() % 2
			match t:
				0:
					var b = randi() % 10 + 2
					if b % 2 != 0:
						b += 1
					var x_max = b / 2
					return H.make_question_custom("Найдите точку максимума функции f(x) = -x² + " + str(b) + "x.", x_max, [b, b - 1, 0], diff, "derivatives")
				1:
					var a = randi() % 5 + 1
					var b = randi() % 10 + 1
					var x0 = randi() % 5 + 1
					var f_prime = 3 * a * x0 * x0 + b
					return H.make_question_custom("Найдите значение производной функции f(x) = " + str(a) + "x³ + " + str(b) + "x в точке x₀ = " + str(x0) + ".", f_prime, [2 * a * x0, 3 * a * x0, f_prime + 1], diff, "derivatives")
				_:
					return {}
		2:
			var t = randi() % 2
			match t:
				0:
					return H.make_question_custom("Найдите точку минимума функции f(x) = x³ − 3x.", 1, [0, -1, 3], diff, "derivatives")
				1:
					var a = randi() % 3 + 1
					var b = randi() % 5 + 1
					var x_min = b
					return H.make_question_custom("Найдите точку минимума функции f(x) = " + str(a) + "x² − " + str(2 * a * x_min) + "x + " + str(randi() % 10 + 1) + ".", x_min, [x_min * 2, x_min + 1, 0], diff, "derivatives")
				_:
					return {}
		_:
			return {}
