extends Control

var flagged_around=0
var viruses_around=0
var virus=false
var row=0
var col=0
var recovered = false
## closed sprites
var sprite_closed=true
var masked=false
## opened sprites
var sprite_opened=false
var sprite_bomb=false
var sprite_misflagged_bomb=false
var sprite_exploded_bomb=false
var sprite_number=false
onready var board = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_position()
	update_sprites()

#func _input(event):
#	var parent=get_parent()
#	if parent.game_over || parent.game_win:
#		return
#	if event is InputEventMouseButton && event.pressed:
#		on_left_click()
#	elif (ev.button_index==BUTTON_RIGHT):
#		on_right_click()
#		update_sprites()

## Adds only one time a virus at c, r.
## Increase the number of added viruses +1
## call tiles to increase the number of viruses around
func add_virus_at(var c, var r):
	if c==col && r==row:
		if virus || sprite_opened:
			return
		virus = true
		add_to_group("virus")
		remove_from_group("tiles")
		if masked:
			remove_from_group("incorrectly_masked")
			add_to_group("correctly_masked")
		if(board):
			board.added_viruses+=1
			get_tree().call_group_flags(2, "tiles", "added_bomb_at", c, r)

## If the tile is nearby where a virus was added, 
## increase viruses around member
func added_bomb_at(var c, var r):
	if c==col && r==row:
		return
	else:
		if abs(col-c) <=1 && abs(row-r) <=1:
			viruses_around+=1

func remove_bomb():
	if !virus || sprite_opened:
		return
	virus = false
	recovered = true
	remove_from_group("virus")
	add_to_group("tiles")
	if masked:
		masked = false
		board.used_masks -= 1
		remove_from_group("correctly_masked")
		add_to_group("incorrectly_masked")
	board.added_viruses -= 1
	board.recovered += 1
	get_tree().call_group_flags(2, "tiles", "removed_bomb_at", col, row)
	update_tile_number()
	open_tile()
	if !sprite_number:
		get_tree().call_group_flags(2, "closed", "empty_tile_opened_at", col, row)
		

func removed_bomb_at(var c, var r):
	if c==col && r==row:
		return
	elif abs(col-c) <=1 && abs(row-r) <=1:
			viruses_around -= 1
						
func empty_tile_opened_at(var c, var r):
	# it is me who opened the tile
	if row==r && col ==c:
		remove_from_group("closed")
		add_to_group("opened")
		return
	# is someone else around who opened the tile
	if abs(row-r)<=1 && abs(col-c)<=1:
		if sprite_closed && !masked && !virus:
			open_tile()
			if !sprite_number:
				get_tree().call_group_flags(2, "closed", "empty_tile_opened_at", col, row)
			
func update_position():
	var size=get_size()
	var scale=get_scale()
	set_position(Vector2(col*size.x*scale.x, row*size.y*scale.y))
	
func update_sprites():
	var closed_path="Closed"
	var opened_path="Opened"
	if sprite_closed:
		get_node(closed_path).show()
		get_node(opened_path).hide()
		get_node("Closed/Mask").hide()
		if masked:
			get_node("Closed/Mask").show()
	if sprite_opened:
		get_node(closed_path).hide()
		get_node(opened_path).show()
		hide_numbers()
		get_node("Opened/Exploded").hide()
		get_node("Opened/Bomb").hide()
		get_node("Opened/Misflagged").hide()
		if sprite_exploded_bomb:
			get_node("Opened/Exploded").show()
		if sprite_bomb:
			get_node("Opened/Bomb").show() 
		if sprite_misflagged_bomb:
			get_node("Opened/Misflagged").show()
		if viruses_around && sprite_number:
			get_node(str("Opened/",viruses_around)).show()
	
func hide_numbers():
	for i in range(1, 9):
		get_node(str("Opened/",i)).hide()
		
func update_tile_number():
	viruses_around = 0
	var bomb_tiles = get_tree().get_nodes_in_group("virus")
	for virus in bomb_tiles:
		if abs(row-virus.row)<=1 && abs(col-virus.col)<=1:
			viruses_around += 1
		
func on_left_click():
	if sprite_closed:
		if board.mask_selected:
			mask_tile()
		elif masked:
			unmask_tile()
		else:
			open_tile()
			if !sprite_number && !sprite_exploded_bomb:
				get_tree().call_group_flags(2, "closed", "empty_tile_opened_at", col, row)

func mask_tile():
	masked = true
	board.used_masks += 1
	get_node("Closed/Mask").show()
	board.unselect_mask()
	if virus:
		add_to_group("correctly_masked")
	else:
		add_to_group("incorrectly_masked")
	
func unmask_tile():
	masked = false
	board.used_masks -= 1
	get_node("Closed/Mask").hide()
	if virus:
		remove_from_group("correctly_masked")
	else:
		remove_from_group("incorrectly_masked")
	
#func on_right_click():
#	if sprite_closed:
#		if !masked && !sprite_question:
#			masked=true
#			sprite_question=false
#			get_tree().call_group("tiles", "flagged_added_at", col, row)
#			if virus:
#				add_to_group("correctly_flagged")
#			else:
#				add_to_group("misflagged")
#			return
#		if masked:
#			masked=false
#			sprite_question=true
#			get_tree().call_group("tiles", "flagged_removed_at", col, row)
#			if virus:
#				remove_from_group("correctly_flagged")
#			else:
#				remove_from_group("misflagged")
#			return
#		if sprite_question:
#			masked=false
#			sprite_question=false
#			return


func open_tile(var explode=true):
	if sprite_opened:
		return
	remove_from_group("closed")
	add_to_group("opened")
	sprite_closed=false
	sprite_opened=true
	sprite_bomb=virus
	sprite_exploded_bomb=virus && explode
	if sprite_exploded_bomb:
		add_to_group("exploded")
#	if !virus && masked:
#		sprite_misflagged_bomb=true
#		sprite_bomb=true
	sprite_number=!sprite_misflagged_bomb && !virus && viruses_around>0
	update_sprites()

func _on_Button_pressed():
	if !board.game_over:
		on_left_click()
