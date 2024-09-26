extends Control

var buttons :Array[TextureButton] 
@onready var buttons_container: Control = %ButtonsContainer
@onready var rules_container: Control = %RulesContainer
var audio_stream_player :AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	buttons = [%PlayButton, %RulesButton, %QuitButton, %ReturnButton]
	audio_stream_player = $AudioStreamPlayer
	for button in buttons:
		button.mouse_entered.connect(audio_stream_player.play)
		button.pressed.connect(audio_stream_player.play)
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%RulesButton.pressed.connect(_show_rules)
	%ReturnButton.pressed.connect(_show_main_menu)
	%QuitButton.pressed.connect(get_tree().quit)
	_show_main_menu()
	get_tree().get_first_node_in_group("level").visible = false
	get_tree().get_first_node_in_group("player").visible = false


	
func _on_play_button_pressed() -> void :
	_hide_menu_entries()
	hide()
	$CanvasLayer.visible = false
	get_tree().get_first_node_in_group("level").visible = true
	get_tree().get_first_node_in_group("player").visible = true	
	get_tree().paused = false
	

func _show_rules() -> void :
	_hide_menu_entries()
	rules_container.show()
	%ReturnButton.disabled = false
	%QuitButton.disabled = false


func _show_main_menu() -> void :
	show()
	$CanvasLayer.visible = true
	_hide_menu_entries()
	buttons_container.show()
	%PlayButton.disabled = false
	%RulesButton.disabled = false
	%QuitButton.disabled = false
	

func _disable_buttons() -> void :
	for button in buttons:
		button.disabled = true


func _hide_menu_entries() -> void :
	_disable_buttons()
	buttons_container.hide()
	rules_container.hide()

















