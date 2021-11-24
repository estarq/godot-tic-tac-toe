extends Node2D

func _ready():
	$game_btn.connect("pressed", self, "_on_game_btn_pressed")
	$mit_btn.connect("pressed", self, "_on_mit_btn_pressed")
	$font_btn.connect("pressed", self, "_on_font_btn_pressed")
	$cloutierfontes_btn.connect("pressed", self, "_on_cloutierfontes_btn_pressed")
	$godot_btn.connect("pressed", self, "_on_godot_btn_pressed")
	$dev_btn.connect("pressed", self, "_on_dev_btn_pressed")
	
	for child in get_children():
		child.focus_mode = Control.FOCUS_NONE
		if not g.dark_theme:
			g.set_label_or_btn_color_to_dark(child)

func _on_game_btn_pressed():
	OS.shell_open("https://github.com/estarq/godot-tic-tac-toe")

func _on_mit_btn_pressed():
	OS.shell_open("https://github.com/estarq/godot-tic-tac-toe/blob/main/LICENSE")

func _on_font_btn_pressed():
	OS.shell_open("https://cloutierfontes.ca/game-of-chaos.html")

func _on_cloutierfontes_btn_pressed():
	OS.shell_open("https://cloutierfontes.ca/")

func _on_godot_btn_pressed():
	OS.shell_open("https://godotengine.org/")

func _on_dev_btn_pressed():
	OS.shell_open("https://github.com/estarq")
