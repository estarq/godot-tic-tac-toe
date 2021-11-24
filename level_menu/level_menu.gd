extends Node2D

func _ready():
	$easy.connect("pressed", self, "_on_easy_pressed")
	$medium.connect("pressed", self, "_on_medium_pressed")
	$hard.connect("pressed", self, "_on_hard_pressed")

	if not g.dark_theme:
		for child in get_children():
			g.set_label_or_btn_color_to_dark(child)
	
func _on_easy_pressed():
	g.level = "easy"
	get_tree().change_scene(g.SCENES["name_menu"])

func _on_medium_pressed():
	g.level = "medium"
	get_tree().change_scene(g.SCENES["name_menu"])

func _on_hard_pressed():
	g.level = "hard"
	get_tree().change_scene(g.SCENES["name_menu"])
