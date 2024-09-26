extends AudioStreamPlayer


## A dictionary containing the game's music tracks and the desired volume. (some are very loud)
const SONG_LIST := {
	preload("res://music/battle_song.mp3") : -15,
	preload("res://music/bonus_level.mp3") : -15,
	preload("res://music/outro_song.mp3") : -20,
	preload("res://music/8_bit_lofi_abandoned_metropolis.mp3") : -20,
	preload("res://music/battle_in_aries_peak.mp3") : -18,
	preload("res://music/flower.wav") : -17,
	preload("res://music/heroic_loop.wav") : -22,
	preload("res://music/idunnowhattocallthissongitssocool.wav") : -17,
	preload("res://music/remnants_of_the_festival.mp3") : -20,
}
## Keeps track of which song you are playing.
var track_index :int = 0

func _ready() -> void :
	randomize()
	track_index = randi() % SONG_LIST.size() # Randomize the first song the game plays.
	stream = SONG_LIST.keys()[track_index] # Set the song to the track index	
	volume_db = SONG_LIST.values()[track_index] # Set the song's volume
	play()
	finished.connect(_play_next_track) # Play the next track when the current one ends


func _play_next_track() -> void :
	var timer = Timer.new() # Wait time between songs.
	timer.wait_time = 1.0
	add_child(timer)
	timer.start()
	timer.timeout.connect(timer.queue_free)
	await timer.timeout
	# change the track_index and set the stream and volume levels. play
	track_index = wrapi(track_index + 1, 0, SONG_LIST.size())
	volume_db = SONG_LIST.values()[track_index]
	stream = SONG_LIST.keys()[track_index]
	play()
