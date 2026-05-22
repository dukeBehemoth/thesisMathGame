extends Node

static func make_question_custom(text: String, correct, distractors: Array, difficulty: int, section: String) -> Dictionary:
	var s_correct = str(correct)
	var answers = [s_correct]
	for d in distractors:
		var s = str(d)
		if s != s_correct and not s in answers:
			answers.append(s)
	while answers.size() < 4:
		answers.append(str(correct + answers.size()))
	answers.shuffle()
	var correct_idx = answers.find(s_correct)
	return {
		"question_text": text,
		"answers": answers,
		"correct_index": correct_idx,
		"difficulty": difficulty,
		"section": section
	}

static func make_question(text: String, correct, difficulty: int, section: String) -> Dictionary:
	var wrong = _generate_wrong(correct, difficulty)
	var answers = [str(correct)]
	answers.append_array(wrong)
	answers.shuffle()
	var correct_idx = answers.find(str(correct))
	return {
		"question_text": text,
		"answers": answers,
		"correct_index": correct_idx,
		"difficulty": difficulty,
		"section": section
	}

static func _generate_wrong(correct, diff: int) -> Array:
	var c = correct if correct is int else int(correct)
	var wrong = []
	var offsets
	match diff:
		0: offsets = [-1, 1, 2, -2]
		1: offsets = [-2, -1, 1, 2, 3, -5, 5]
		_: offsets = [-5, -3, 3, 5, -10, 10, -2, 2, -15, 15]
	for off in offsets:
		var w = c + off
		if w != c and w >= 0 and not wrong.has(str(w)):
			wrong.append(str(w))
		if wrong.size() >= 3:
			break
	var fallback = 0
	while wrong.size() < 3:
		var w = randi() % (c + 20) + 1
		if w != c and not wrong.has(str(w)):
			wrong.append(str(w))
		fallback += 1
		if fallback > 50:
			wrong.append(str(c + wrong.size() + 1))
	return wrong

static func sup(n) -> String:
	var s = str(n)
	var r = ""
	for c in s:
		match c:
			"0": r += "⁰"
			"1": r += "¹"
			"2": r += "²"
			"3": r += "³"
			"4": r += "⁴"
			"5": r += "⁵"
			"6": r += "⁶"
			"7": r += "⁷"
			"8": r += "⁸"
			"9": r += "⁹"
			"+": r += "⁺"
			"x": r += "ˣ"
			_: r += c
	return r

static func sub(n) -> String:
	var s = str(n)
	var r = ""
	for c in s:
		match c:
			"0": r += "₀"
			"1": r += "₁"
			"2": r += "₂"
			"3": r += "₃"
			"4": r += "₄"
			"5": r += "₅"
			"6": r += "₆"
			"7": r += "₇"
			"8": r += "₈"
			"9": r += "₉"
			_: r += c
	return r
