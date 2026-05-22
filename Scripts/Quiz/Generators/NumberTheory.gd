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
			var n = randi() % 90 + 10
			var sum_digits = 0
			var tmp = n
			while tmp > 0:
				sum_digits += tmp % 10
				tmp = tmp / 10
				sum_digits = int(sum_digits)
			var prod = 1
			var t2 = n
			while t2 > 0:
				prod *= t2 % 10
				t2 = t2 / 10
				prod = int(prod)
			return H.make_question_custom("Найдите сумму цифр числа " + str(n) + ".", sum_digits, [n, prod, sum_digits + 1], diff, "number_theory")
		1:
			var t = randi() % 2
			match t:
				0:
					var n = [12, 16, 18, 20, 24, 30, 36, 40, 42, 48][randi() % 10]
					var count = 0
					for d in range(1, n + 1):
						if n % d == 0:
							count += 1
					return H.make_question_custom("Сколько натуральных делителей у числа " + str(n) + "?", count, [n / 2, n, count + 1], diff, "number_theory")
				1:
					var exp = randi() % 5 + 1
					var last_digit = [2, 4, 8, 6, 2, 4, 8, 6][(exp - 1) % 4]
					var next_in_cycle = [4, 8, 6, 2, 4, 8, 6, 2][(exp - 1) % 4]
					return H.make_question_custom("Какая цифра в разряде единиц числа 2" + H.sup(exp) + "?", last_digit, [next_in_cycle, exp, 2], diff, "number_theory")
				_:
					return {}
		2:
			var t = randi() % 2
			match t:
				0:
					var a = randi() % 10 + 5
					var b = randi() % 10 + 5
					var gcd = _gcd(a, b)
					return H.make_question_custom("Найдите НОД(" + str(a) + ", " + str(b) + ").", gcd, [1, a, b], diff, "number_theory")
				1:
					var a = randi() % 8 + 2
					var b = randi() % 8 + 2
					var lcm = a * b / _gcd(a, b)
					return H.make_question_custom("Найдите НОК(" + str(a) + ", " + str(b) + ").", lcm, [a * b, max(a, b), lcm / 2], diff, "number_theory")
				_:
					return {}
		_:
			return {}

static func _gcd(a: int, b: int) -> int:
	var x = a
	var y = b
	while y != 0:
		var t = y
		y = x % y
		x = t
	return x
