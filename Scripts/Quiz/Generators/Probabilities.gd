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
					var sides = 6
					var favorable = randi() % 5 + 1
					var pct = favorable * 100 / sides
					return H.make_question_custom("Бросается шестигранный кубик. Какова вероятность (в %) выпадения числа ≤" + str(favorable) + "?", pct, [(sides - favorable) * 100 / sides, favorable * 100, (favorable + 1) * 100 / sides], diff, "probabilities")
				1:
					var red = randi() % 4 + 1
					var blue = randi() % 4 + 1
					var total = red + blue
					var pct = red * 100 / total
					return H.make_question_custom("В мешке " + str(red) + " красных и " + str(blue) + " синих шаров. Какова вероятность (в %) вытащить красный?", pct, [blue * 100 / total, red, (red + 1) * 100 / total], diff, "probabilities")
				_:
					return {}
		1:
			var t = randi() % 2
			match t:
				0:
					var total = randi() % 6 + 4
					var favorable = randi() % (total - 1) + 1
					var ans = (total - favorable) * 100 / total
					return H.make_question_custom("Случайное число от 1 до " + str(total) + ". Какова вероятность (в %), что оно больше " + str(favorable) + "?", ans, [favorable * 100 / total, (total - favorable) * 100, 100 - ans], diff, "probabilities")
				1:
					var red = randi() % 3 + 1
					var blue = randi() % 3 + 1
					var green = randi() % 2 + 1
					var total = red + blue + green
					var not_red = blue + green
					var ans = not_red * 100 / total
					return H.make_question_custom("В мешке " + str(red) + " красных, " + str(blue) + " синих и " + str(green) + " зелёных шаров. Какова вероятность (в %) вытащить не красный?", ans, [red * 100 / total, not_red, red], diff, "probabilities")
				_:
					return {}
		2:
			var t = randi() % 2
			match t:
				0:
					var total = 2
					var tosses = randi() % 3 + 2
					var ans = int(pow(total, tosses))
					return H.make_question_custom("Монету подбросили " + str(tosses) + " раз(а). Какова вероятность (1/?) выпадения всех орлов?", ans, [2 * tosses, tosses, int(pow(total, tosses + 1))], diff, "probabilities")
				1:
					var sides = [6, 8, 10, 12, 20][randi() % 5]
					var pc = _prime_count(sides)
					var ans = pc * 100 / sides
					return H.make_question_custom("Бросается d" + str(sides) + ". Какова вероятность (в %) выпадения простого числа? Подсказка: " + str(pc) + " простых из " + str(sides), ans, [(sides - pc) * 100 / sides, pc, (pc + 1) * 100 / sides], diff, "probabilities")
				_:
					return {}
		_:
			return {}

static func _prime_count(n: int) -> int:
	var primes = [2, 3, 5, 7, 11, 13, 17, 19]
	var count = 0
	for p in primes:
		if p <= n:
			count += 1
	return count
