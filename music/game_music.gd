extends AudioStreamPlayer

const SONG_LIST := {
	preload("res://music/battle_song.mp3") : -15,
	preload("res://music/bonus_level.mp3") : -15,
	preload("res://music/outro_song.mp3") : -20,
}

var track_index :int = 0

func _ready() -> void :
	randomize()
	track_index = randi() % SONG_LIST.size()
	volume_db = SONG_LIST.values()[track_index]
	stream = SONG_LIST.keys()[track_index]
	play()
	finished.connect(_play_next_track)


func _play_next_track() -> void :
	var timer = Timer.new()
	timer.wait_time = 2.0
	add_child(timer)
	timer.start()
	timer.timeout.connect(timer.queue_free)
	await timer.timeout
	track_index = wrapi(track_index + 1, 0, SONG_LIST.size())
	volume_db = SONG_LIST.values()[track_index]
	stream = SONG_LIST.keys()[track_index]
	play()
