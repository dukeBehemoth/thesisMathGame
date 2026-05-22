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
			var t = randi() % 2
			match t:
				0:
					var base = randi() % 3 + 2
					var exp = randi() % 4 + 1
					var result = int(pow(base, exp))
					return H.make_question_custom("Вычислите степень: " + str(base) + H.sup(exp) + " = ?", result, [base * exp, base + exp, result - 1], diff, "logarithms")
				1:
					var base = randi() % 3 + 2
					var exp = randi() % 3 + 2
					var result = int(pow(base, exp))
					return H.make_question_custom("Вычислите логарифм: log" + H.sub(base) + "(" + str(result) + ") = ?", exp, [result, result / base, exp + 1], diff, "logarithms")
				_:
					return {}
		1:
			var t = randi() % 2
			match t:
				0:
					var base = randi() % 3 + 2
					var exp = randi() % 4 + 2
					var result = int(pow(base, exp))
					return H.make_question_custom("Решите показательное уравнение: " + str(base) + H.sup("x") + " = " + str(result) + ". Найдите x.", exp, [result, result / base, exp + 1], diff, "logarithms")
				1:
					var base = randi() % 3 + 2
					var exp1 = randi() % 3 + 1
					var exp2 = randi() % 3 + 1
					var v1 = int(pow(base, exp1))
					var v2 = int(pow(base, exp2))
					return H.make_question_custom("Упростите: log" + H.sub(base) + "(" + str(v1) + ") + log" + H.sub(base) + "(" + str(v2) + ") = log" + H.sub(base) + "(?)", v1 * v2, [v1 + v2, v1 * v2 + 1, v1 * v2 / v1], diff, "logarithms")
				_:
					return {}
		2:
			var t = randi() % 2
			match t:
				0:
					var base = randi() % 2 + 2
					var exp = randi() % 3 + 2
					var shift = randi() % 3 + 1
					var inner = exp - shift
					if inner <= 0:
						inner = 1
						shift = exp - 1
					var result = int(pow(base, exp))
					return H.make_question_custom("Решите показательное уравнение: " + str(base) + H.sup("x+" + str(shift)) + " = " + str(result) + ". Найдите x.", inner, [exp, shift, result], diff, "logarithms")
				1:
					var base = randi() % 3 + 2
					var val = int(pow(base, randi() % 3 + 2))
					var coeff = randi() % 3 + 2
					return H.make_question_custom("Упростите: " + str(coeff) + " × log" + H.sub(base) + "(" + str(val) + ") = log" + H.sub(base) + "(?)", int(pow(val, coeff)), [val + coeff, val * coeff, coeff * val / coeff], diff, "logarithms")
				_:
					return {}
		_:
			return {}
