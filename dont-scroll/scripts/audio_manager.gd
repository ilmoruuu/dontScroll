extends Node

@onready var main_music = $MainMusic
@onready var bench_music = $BenchMusic
@onready var death_effect = $DeathEffect
@onready var door_opening = $DoorOpening

func _ready():
	main_music.play()

func enter_bench():

	main_music.stop()

	bench_music.play()

func exit_bench():

	bench_music.stop()

	main_music.play()

func play_death_effect():
	death_effect.play(2.0)
	main_music.stop()

func enter_door():
	var tween = create_tween()

	tween.tween_property(main_music, "volume_db", -40.0, 0.5)

	await tween.finished

	door_opening.play(2.0)
	var tween2 = create_tween()
	tween2.tween_property(main_music, "volume_db", 0.0, 1.5)

func update_exposition(value):

	main_music.pitch_scale = 1.0 + value * 0.01
