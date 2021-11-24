extends Node2D

func _ready():
	$play.connect("pressed", self, "_on_play_pressed")
	
	if not g.dark_theme:
		for child in get_children():
			g.set_label_or_btn_color_to_dark(child)

func _on_play_pressed():
	g.x_name = $x.text if $x.text else "x"
	if not g.x_name in g.rank:
		g.rank[g.x_name] = 0
	g.o_name = "comp"
	get_tree().change_scene(g.SCENES["board"])

func _on_x_text_changed(input):
	var alnum = ""
	for chr in input:
		if chr.to_lower() in 'qwertyuiopasdfghjklzxcvbnm1234567890':
			alnum += chr.to_lower()
	$x.text = alnum
	$x.set_cursor_position(len(alnum))
