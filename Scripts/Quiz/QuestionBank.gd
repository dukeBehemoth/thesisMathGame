extends Node

const Algebra = preload("res://Scripts/Quiz/Generators/Algebra.gd")
const Geometry = preload("res://Scripts/Quiz/Generators/Geometry.gd")
const Percentages = preload("res://Scripts/Quiz/Generators/Percentages.gd")
const Probabilities = preload("res://Scripts/Quiz/Generators/Probabilities.gd")
const Logarithms = preload("res://Scripts/Quiz/Generators/Logarithms.gd")
const Trigonometry = preload("res://Scripts/Quiz/Generators/Trigonometry.gd")
const Derivatives = preload("res://Scripts/Quiz/Generators/Derivatives.gd")
const Parameters = preload("res://Scripts/Quiz/Generators/Parameters.gd")
const Economics = preload("res://Scripts/Quiz/Generators/Economics.gd")
const NumberTheory = preload("res://Scripts/Quiz/Generators/NumberTheory.gd")

static func get_questions(difficulty: int, count: int, enabled_sections: Array) -> Array:
	if enabled_sections.is_empty():
		return []

	var all = []
	var per_section = max(1, int(ceil(float(count * 2) / float(enabled_sections.size()))))

	for sec_id in enabled_sections:
		var generated = _generate_section(sec_id, difficulty, per_section)
		all.append_array(generated)

	all.shuffle()
	return all.slice(0, count)

static func _generate_section(section_id: String, difficulty: int, count: int) -> Array:
	match section_id:
		"algebra":
			return Algebra.generate(difficulty, count)
		"geometry":
			return Geometry.generate(difficulty, count)
		"percentages":
			return Percentages.generate(difficulty, count)
		"probabilities":
			return Probabilities.generate(difficulty, count)
		"logarithms":
			return Logarithms.generate(difficulty, count)
		"trigonometry":
			return Trigonometry.generate(difficulty, count)
		"derivatives":
			return Derivatives.generate(difficulty, count)
		"parameters":
			return Parameters.generate(difficulty, count)
		"economics":
			return Economics.generate(difficulty, count)
		"number_theory":
			return NumberTheory.generate(difficulty, count)
		_:
			return []

static func append_to_pool(items: Array):
	pass

static func clear_pool():
	pass
