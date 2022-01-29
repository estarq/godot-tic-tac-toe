extends Node2D

var clicking_suspended
var x_turn
var fields_with_x
var fields_with_o
var free_fields
var POINTS = {
	"easy": 2,
	"medium": 3,
	"hard": 4
}
var WINNING_COMBINATIONS = [
	[1, 2, 3], [4, 5, 6], [7, 8, 9],
	[1, 4, 7], [2, 5, 8], [3, 6, 9],
	[1, 5, 9], [3, 5, 7]
]

func _ready():
	for field in get_tree().get_nodes_in_group("fields"):
		field.connect("pressed", self, "_on_field_pressed", [field])
	
	$x_name.set_text(g.x_name)
	$o_name.set_text(g.o_name)
	
	if not g.dark_theme:
		for child in get_children():
			if child is Line2D:
				child.default_color = g.COLORS["darker"]
			elif child is Label:
				child.add_color_override("font_color", g.COLORS["darker"])

	start_new_game()

func start_new_game():
	clicking_suspended = false
	x_turn = true
	fields_with_x = []
	fields_with_o = []
	free_fields = range(1, 10)
	get_tree().call_group("fields", "set_default_mark")

func _on_field_pressed(field):
	if clicking_suspended or field.marked:
		return

	field.marked = true
	field.text = "x" if x_turn else "o"
	(fields_with_x if x_turn else fields_with_o).append(int(field.name))
	free_fields.erase(int(field.name))
	
	if three_in_a_row():
		clicking_suspended = true
		# Increment the winner's score
		var winner_score_node = $x_score if x_turn else $o_score
		var winner_score = int(winner_score_node.get_text())
		winner_score_node.set_text(str(winner_score + 1))
		
		# Highlight the winning combination
		var arr = fields_with_x if x_turn else fields_with_o
		for fields in WINNING_COMBINATIONS:
			if fields[0] in arr and fields[1] in arr and fields[2] in arr:
				for field in fields:
					get_node(str(field)).highlight_mark()
					yield(get_tree().create_timer(0.2), "timeout")
		
		# Update the rank
		var winner = g.x_name if x_turn else g.o_name
		if x_turn or g.o_name != "comp":
			g.rank[winner] += POINTS["hard"] if g.pvp else POINTS[g.level]
		
		var f = File.new()
		f.open(g.RANK_PATH, File.WRITE)
		f.store_line(to_json(g.rank))
		f.close()
	elif not free_fields:
		clicking_suspended = true
		$tie_num.set_text(str(int($tie_num.get_text()) + 1))

		
	if clicking_suspended:
		yield(get_tree().create_timer(1), "timeout")
		start_new_game()
		return

	x_turn = !x_turn
	if g.pvp or x_turn:
		return

	clicking_suspended = true
	yield(get_tree().create_timer(0.5), "timeout")
	
	# Make o's first move
	if not fields_with_o:
		var field_no
		if g.level != "hard":
			field_no = free_fields[randi() % free_fields.size()]
		else:
			var starting_fields = [1, 3, 5, 7, 9]
			while true:
				field_no = starting_fields[randi() % starting_fields.size()]
				if field_no in free_fields:
					break
		clicking_suspended = false
		_on_field_pressed(get_node(str(field_no)))
		return

        # Put a 3rd mark in a row
        for fields in WINNING_COMBINATIONS:
                var with_x = []
                var with_o = []
                var free = []
                for field in fields:
                        if field in fields_with_x:
                                with_x.append(field)
                        elif field in fields_with_o:
                                with_o.append(field)
                        else:
                                free.append(field)
                if len(with_o) == 2 and not with_x:
                        clicking_suspended = false
                        _on_field_pressed(get_node(str(free[0])))
                        return

	if g.level == "hard":
		# Block if the opponent has two in a row
		for fields in WINNING_COMBINATIONS:
			var with_x = []
			var with_o = []
			var free = []
			for field in fields:
				if field in fields_with_x:
					with_x.append(field)
				elif field in fields_with_o:
					with_o.append(field)
				else:
					free.append(field)
			if len(with_x) == 2 and not with_o:
				clicking_suspended = false
				_on_field_pressed(get_node(str(free[0])))
				return
	
	# Put a 2nd mark in a row
	for fields in WINNING_COMBINATIONS:
		var with_x = []
		var with_o = []
		var free = []
		for field in fields:
			if field in fields_with_x:
				with_x.append(field)
			elif field in fields_with_o:
				with_o.append(field)
			else:
				free.append(field)
		if len(with_o) == 1 and not with_x:
			clicking_suspended = false
			_on_field_pressed(get_node(str(free[randi() % free.size()])))
			return

	var free_field = free_fields[randi() % free_fields.size()]
	clicking_suspended = false
	_on_field_pressed(get_node(str(free_field)))

func three_in_a_row():
	var arr = fields_with_x if x_turn else fields_with_o
	for fields in WINNING_COMBINATIONS:
		if fields[0] in arr and fields[1] in arr and fields[2] in arr:
			return true
	return false
