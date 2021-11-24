extends Node

var x_name
var o_name
var level
var pvp
var rank
var back_btn
var dark_theme = true
var RANK_PATH = "user://rank.json"
var COLORS = {
	"light": Color(0.8, 0.8, 0.8, 1),
	"lighter": Color(1, 1, 1, 1),
	"dark": Color(0.3, 0.3, 0.3, 1),
	"darker": Color(0, 0, 0, 1)
}
var FONTS = {
	"normal": "res://_fonts/goc.tres",
	"bigger": "res://_fonts/goc_bigger.tres"
}
var SCENES = {
	"about": "res://about/about.tscn",
	"board": "res://board/board.tscn",
	"field": "res://field/field.tscn",
	"level_menu": "res://level_menu/level_menu.tscn",
	"main_menu": "res://main_menu/main_menu.tscn",
	"name_menu": "res://name_menu/name_menu.tscn",
	"names_menu": "res://names_menu/names_menu.tscn",
	"rank": "res://rank/rank.tscn"
}

func _ready():
	if OS.get_name() in ["X11", "OSX"]:
		var aspect_ratio = 900.0 / 950
		var new_height = OS.get_screen_size()[1] / 2
		var new_width = aspect_ratio * new_height
		OS.set_window_size(Vector2(new_width, new_height))
	elif OS.get_name() == "Windows":
		OS.window_fullscreen = true

		
	var f = File.new()
	if not f.file_exists(RANK_PATH):
		rank = {}
		f.open(RANK_PATH, File.WRITE)
		f.store_line(to_json(rank))
	else:
		f.open(RANK_PATH, File.READ)
		rank = parse_json(f.get_line())
	f.close()
	
	var title = Label.new()
	title.text = "TIC TAC TOE"
	title.rect_position = Vector2(248, 100)
	title.add_font_override("font", load(FONTS["normal"]))
	add_child(title)
	
	back_btn = Button.new()
	back_btn.text = "A"
	back_btn.flat = true
	back_btn.focus_mode = Control.FOCUS_NONE
	back_btn.rect_rotation = 150
	back_btn.rect_position = Vector2(100, 70)
	back_btn.add_font_override("font", load(FONTS["normal"]))
	back_btn.connect("pressed", self, "_on_back_btn_pressed")
	add_child(back_btn)
	
	if OS.get_name() == "OSX":
		var output = []
		OS.execute("defaults", ["read", "-g", "AppleInterfaceStyle"], true, output)
		dark_theme = true if "Dark\n" in output else false
	if not dark_theme:
		VisualServer.set_default_clear_color(COLORS["light"])
		title.add_color_override("font_color", COLORS["darker"])
		set_label_or_btn_color_to_dark(back_btn)

	randomize()

func _on_back_btn_pressed():
	var scene_name = get_tree().get_current_scene().get_name()
	if scene_name == "name_menu":
		get_tree().change_scene(SCENES["level_menu"])
	elif scene_name == "board":
		if pvp:
			get_tree().change_scene(SCENES["names_menu"])
		else:
			get_tree().change_scene(SCENES["name_menu"])
	else:
		get_tree().change_scene(SCENES["main_menu"])

func set_label_or_btn_color_to_dark(node):
		if node is Label:
			node.add_color_override("font_color", COLORS["darker"])
		elif node is Button or node is LinkButton:
			node.add_color_override("font_color", COLORS["dark"])
			node.add_color_override("font_color_pressed", COLORS["darker"])
			node.add_color_override("font_color_hover", COLORS["darker"])
