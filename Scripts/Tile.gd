extends Control

var flagged_around=0
var bombs_around=0
var bomb=false
var row=0
var col=0
## closed sprites
var sprite_closed=true
var sprite_flagged=false
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

## Adds only one time a bomb at c, r.
## Increase the number of added bombs +1
## call tiles to increase the number of bombs around
func add_bomb_at(var c, var r):
	if c==col && r==row:
		if bomb || sprite_opened:
			return
		bomb = true
		add_to_group("bomb")
		remove_from_group("tiles")
		if(board):
			board.added_bombs+=1
			get_tree().call_group_flags(2, "tiles", "added_bomb_at", c, r)

## If the tile is nearby where a bomb was added, 
## increase bombs around member
func added_bomb_at(var c, var r):
	if c==col && r==row:
		return
	else:
		if abs(col-c) <=1 && abs(row-r) <=1:
			bombs_around+=1

func remove_bomb():
	if !bomb || sprite_opened:
		return
	bomb = false
	remove_from_group("bomb")
	add_to_group("tiles")
	if(board):
		board.added_bombs -= 1
		get_tree().call_group_flags(2, "tiles", "removed_bomb_at", col, row)
	update_tile_number()
		

func removed_bomb_at(var c, var r):
	if c==col && r==row:
		return
	elif abs(col-c) <=1 && abs(row-r) <=1:
			bombs_around -= 1
						
func empty_tile_opened_at(var c, var r):
	# it is me who opened the tile
	if row==r && col ==c:
		remove_from_group("closed")
		add_to_group("opened")
		return
	# is someone else around who opened the tile
	if abs(row-r)<=1 && abs(col-c)<=1:
		if sprite_closed && !sprite_flagged && !bomb:
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
		if sprite_flagged:
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
		if bombs_around && sprite_number:
			get_node(str("Opened/",bombs_around)).show()
	
func hide_numbers():
	for i in range(1, 9):
		get_node(str("Opened/",i)).hide()
		
func update_tile_number():
	var bomb_tiles = get_tree().get_nodes_in_group("bomb")
	for bomb in bomb_tiles:
		if abs(row-bomb.row)<=1 && abs(col-bomb.col)<=1:
			bombs_around += 1
		
func on_left_click():
	if sprite_closed:
		if board.mask_selected:
			sprite_flagged = true
			get_node("Closed/Mask").show()
			board.unselect_mask()
		elif sprite_flagged:
			sprite_flagged = false
			get_node("Closed/Mask").hide()
		else:
			open_tile()
			if !sprite_number && !sprite_exploded_bomb:
				get_tree().call_group_flags(2, "closed", "empty_tile_opened_at", col, row)

#func on_right_click():
#	if sprite_closed:
#		if !sprite_flagged && !sprite_question:
#			sprite_flagged=true
#			sprite_question=false
#			get_tree().call_group("tiles", "flagged_added_at", col, row)
#			if bomb:
#				add_to_group("correctly_flagged")
#			else:
#				add_to_group("misflagged")
#			return
#		if sprite_flagged:
#			sprite_flagged=false
#			sprite_question=true
#			get_tree().call_group("tiles", "flagged_removed_at", col, row)
#			if bomb:
#				remove_from_group("correctly_flagged")
#			else:
#				remove_from_group("misflagged")
#			return
#		if sprite_question:
#			sprite_flagged=false
#			sprite_question=false
#			return


func open_tile(var explode=true):
	if sprite_opened:
		return
	remove_from_group("closed")
	add_to_group("opened")
	sprite_closed=false
	sprite_opened=true
	sprite_bomb=bomb
	sprite_exploded_bomb=bomb && explode
	if sprite_exploded_bomb:
		add_to_group("exploded")
	if !bomb && sprite_flagged:
		sprite_misflagged_bomb=true
		sprite_bomb=true
	sprite_number=!sprite_misflagged_bomb && !bomb && bombs_around>0
	update_sprites()

func _on_Button_pressed():
	if !board.game_over:
		on_left_click()
