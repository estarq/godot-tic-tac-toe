extends Node2D

func _ready():
	$pvp.connect("pressed", self, "_on_pvp_pressed")
	$pvm.connect("pressed", self, "_on_pvm_pressed")
	$rank.connect("pressed", self, "_on_rank_pressed")
	$about.connect("pressed", self, "_on_about_pressed")
	$quit.connect("pressed", self, "_on_quit_pressed")
	
	g.back_btn.visible = false
	
	if not g.dark_theme:
		for child in get_children():
			g.set_label_or_btn_color_to_dark(child)

func _on_pvp_pressed():
	g.pvp = true
	get_tree().change_scene(g.SCENES["names_menu"])
	g.back_btn.visible = true

func _on_pvm_pressed():
	g.pvp = false
	get_tree().change_scene(g.SCENES["level_menu"])
	g.back_btn.visible = true

func _on_rank_pressed():
	get_tree().change_scene(g.SCENES["rank"])
	g.back_btn.visible = true

func _on_about_pressed():
	get_tree().change_scene(g.SCENES["about"])
	g.back_btn.visible = true

func _on_quit_pressed():
	get_tree().quit()
