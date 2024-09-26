extends Control

var buttons :Array[TextureButton] 
## The main menu buttons container
@onready var buttons_container: Control = %ButtonsContainer
## The rules page container
@onready var rules_container: Control = %RulesContainer
## The button audio player
var audio_stream_player :AudioStreamPlayer
## the game finished message container
@onready var game_finished_container: Control = %GameFinishedContainer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Always process this node
	get_tree().paused = true # Start the game paused
	buttons = [%PlayButton, %RulesButton, %QuitButton, %ReturnButton, %RestartButton]
	audio_stream_player = $AudioStreamPlayer
	for button in buttons: # connect the button sounds
		button.mouse_entered.connect(audio_stream_player.play)
		button.pressed.connect(audio_stream_player.play)
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%RulesButton.pressed.connect(_show_rules)
	%ReturnButton.pressed.connect(_show_main_menu)
	%QuitButton.pressed.connect(get_tree().quit) # Quit the game whenever quit is pressed
	%RestartButton.pressed.connect(get_tree().reload_current_scene) # Reload the game when replay is pressed
	_show_main_menu()
	get_tree().get_first_node_in_group("level").visible = false # hide the level
	get_tree().get_first_node_in_group("player").visible = false # hide the player
	get_tree().get_root().get_node("Main").game_finished.connect(_on_game_finished)


## Pause the game, show only the game finished container and activate the buttons on that page
func _on_game_finished() -> void :
	get_tree().paused = true
	_hide_menu_entries()
	show()
	$CanvasLayer.visible = true
	game_finished_container.show()
	%QuitButton.disabled = false
	%RestartButton.disabled = false


## Unpause the game, show the level and player and hide the menu
func _on_play_button_pressed() -> void :
	_hide_menu_entries()
	hide()
	$CanvasLayer.visible = false
	get_tree().get_first_node_in_group("level").visible = true
	get_tree().get_first_node_in_group("player").visible = true	
	get_tree().paused = false
	

## show only the rules container and activate the buttons
func _show_rules() -> void :
	_hide_menu_entries()
	rules_container.show()
	%ReturnButton.disabled = false
	%QuitButton.disabled = false


## show only the main menu and activate the main menu buttons
func _show_main_menu() -> void :
	show()
	$CanvasLayer.visible = true
	_hide_menu_entries()
	buttons_container.show()
	%PlayButton.disabled = false
	%RulesButton.disabled = false
	%QuitButton.disabled = false
	

## disables all the menu buttons
func _disable_buttons() -> void :
	for button in buttons:
		button.disabled = true


## hide all the menu entry containers
func _hide_menu_entries() -> void :
	_disable_buttons()
	buttons_container.hide()
	rules_container.hide()
	game_finished_container.hide()
	

















