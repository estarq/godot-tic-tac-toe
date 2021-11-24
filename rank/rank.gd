extends Node2D

func _ready():
	var font_color = g.COLORS["lighter"] if g.dark_theme else g.COLORS["darker"]
	$subtitle.add_color_override("font_color", font_color)
	
	var rank_copy = g.rank.duplicate()
	while rank_copy.size():
		var max_num = rank_copy.values().max()
		for name in rank_copy:
			if g.rank[name] == max_num:
				if g.rank[name]  > 0:
					var control = Control.new()
					var name_label = Label.new()
					var score_label = Label.new()
					name_label.text = name
					score_label.text = str(g.rank[name])
					score_label.rect_size.x = 170
					score_label.rect_position.x = 315
					score_label.align = Label.ALIGN_RIGHT
					name_label.add_font_override("font", load(g.FONTS["normal"]))
					score_label.add_font_override("font", load(g.FONTS["normal"]))
					name_label.add_color_override("font_color", font_color)
					score_label.add_color_override("font_color", font_color)
					control.add_child(name_label)	
					control.add_child(score_label)
					$ScrollContainer/VBoxContainer.add_child(control)
				rank_copy.erase(name)
				break
