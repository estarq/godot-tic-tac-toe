extends Button

var marked

func _ready():
	add_to_group("fields")
	set_default_mark()

func set_default_mark():
	text = ""
	marked = false
	var color = g.COLORS["light"] if g.dark_theme else g.COLORS["dark"]
	add_color_override("font_color", color)
	add_color_override("font_color_hover", color)
	add_color_override("font_color_pressed", color)

func highlight_mark():
	var color = g.COLORS["lighter"] if g.dark_theme else g.COLORS["darker"]
	add_color_override("font_color", color)
	add_color_override("font_color_hover", color)
	add_color_override("font_color_pressed", color)
