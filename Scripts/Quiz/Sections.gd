extends Node

class SectionInfo:
	var id: String
	var name: String
	var description: String
	var icon: String

	func _init(p_id: String, p_name: String, p_desc: String, p_icon: String):
		id = p_id
		name = p_name
		description = p_desc
		icon = p_icon

const ALL_SECTIONS: Array = [
	"algebra", "geometry", "percentages", "probabilities", "logarithms",
	"trigonometry", "derivatives", "parameters", "economics", "number_theory"
]

static func get_all() -> Array:
	var sections = []
	sections.append(SectionInfo.new("algebra", "Алгебра", "Уравнения и неравенства, системы", "x²"))
	sections.append(SectionInfo.new("geometry", "Геометрия", "Планиметрия, стереометрия, объёмы", "△"))
	sections.append(SectionInfo.new("percentages", "Проценты и отношения", "Проценты, пропорции, соотношения", "%"))
	sections.append(SectionInfo.new("probabilities", "Вероятность", "Классическая и условная вероятность", "P"))
	sections.append(SectionInfo.new("logarithms", "Логарифмы и степени", "Показательные и логарифмические уравнения", "log"))
	sections.append(SectionInfo.new("trigonometry", "Тригонометрия", "Преобразования, тригонометрические уравнения", "sin"))
	sections.append(SectionInfo.new("derivatives", "Производная", "Производная, исследование функций, касательные", "f'"))
	sections.append(SectionInfo.new("parameters", "Параметры", "Уравнения и неравенства с параметром", "a"))
	sections.append(SectionInfo.new("economics", "Экономические задачи", "Кредиты, вклады, оптимизация", "₽"))
	sections.append(SectionInfo.new("number_theory", "Теория чисел", "Делимость, остатки, цифровая запись", "ℕ"))
	return sections

static func get_section(id: String) -> SectionInfo:
	for s in get_all():
		if s.id == id:
			return s
	return null

static func get_icon(id: String) -> String:
	var s = get_section(id)
	return s.icon if s else "?"
