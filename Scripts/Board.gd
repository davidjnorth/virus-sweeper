extends Control

onready var virus_spread_timer = get_parent().get_node("VirusSpreadTimer")

var game_mode = global.game_mode
var game_details = global.game_details()
var width = global.width
var height = global.height
var bombs = game_details["bombs"]
var added_bombs = 0
var game_over = false
var game_started = false
#var total_flags
var mask_selected = false

signal game_over
signal game_started
signal viruses_changed

func _ready():
	create_board()
	add_bombs()
	if game_mode != "classic":
		setup_virus_spread()

func _process(_delta):
	if game_started == false && !get_tree().get_nodes_in_group("opened").empty():
		game_started()
		
	if !get_tree().get_nodes_in_group("exploded").empty() && game_over == false:
		game_over(false)
		get_tree().call_group_flags(2, "bomb", "open_tile", false)
#		get_tree().call_group_flags(2, "misflagged", "open_tile", false)
		
	var closed_tiles=get_tree().get_nodes_in_group("closed")
	if closed_tiles.size()==bombs && game_over == false:
		game_over(true)
		
func game_over(win):
	game_over = true
	virus_spread_timer.stop()
	emit_signal("game_over", win)

func create_board():
	game_started = false
	game_over = false
	var scene=preload("res://Scenes/Tile.tscn")
	randomize()
	for i in range(0, height):
		for j in range(0, width):
			var tile=scene.instance()
			tile.row=i
			tile.col=j
			add_child(tile)
			tile.add_to_group("tiles")
			tile.add_to_group("closed")

func add_bombs():
	var tree=get_tree()
	while bombs-added_bombs:
		var rcol=randi()%width
		var rrow=randi()%height
		tree.call_group_flags(2, "tiles","add_bomb_at", rcol, rrow)

func clear_board():
	var children=get_children()
	for tile in children:
		remove_child(tile)
		tile.queue_free()
	
func game_started():
	game_started = true
	emit_signal("game_started")
	if game_mode != "classic":
		virus_spread_timer.start()
		
func setup_virus_spread():
	var incubation_period = game_details["incubation_period"]
	virus_spread_timer.set_wait_time(incubation_period)

func new_game():
	added_bombs = 0
	virus_spread_timer.stop()
	clear_board()
	create_board()
	add_bombs()

func _on_TopUI_new_game():
	new_game()

func _on_VirusSpread_timeout():
	if game_mode == "classic":
		return
	elif game_mode == "covid-19":
		covid_spread()
	elif game_mode == "flu":
		flu_spread()
	add_bombs()
	get_tree().call_group_flags(2, "opened", "update_sprites")
	
func covid_spread():
	var infection_rate = game_details["infection_rate"]
	var closed_tiles = get_tree().get_nodes_in_group("closed").size()
	var infection_increase = (1 - (bombs / float(closed_tiles))) * infection_rate
	var new_viruses = floor(bombs * infection_increase) / 2
	bombs += new_viruses
	emit_signal("viruses_changed", bombs, new_viruses, 0)
	
func flu_spread():
	var virus_increase = game_details["virus_increase"]
	var virus_decrease = game_details["virus_decrease"]
	var bomb_tiles = get_tree().get_nodes_in_group("bomb")
	for n in range(virus_decrease):
		var index=randi()%bomb_tiles.size()
		bomb_tiles[index].remove_bomb()
		bombs -= 1
	bombs += virus_increase
	emit_signal("viruses_changed", bombs, virus_increase, virus_decrease)

func _on_Mask_pressed():
	if mask_selected:
		unselect_mask()
	else:
		select_mask()
		
func unselect_mask():
	mask_selected = false
	get_parent().get_node("TopUI/Mask/BlackSprite").hide()
	get_parent().get_node("TopUI/Mask/WhiteSprite").show()
	
func select_mask():
	mask_selected = true
	get_parent().get_node("TopUI/Mask/BlackSprite").show()
	get_parent().get_node("TopUI/Mask/WhiteSprite").hide()
