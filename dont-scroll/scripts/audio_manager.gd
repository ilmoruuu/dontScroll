extends Node

@onready var main_music = $MainMusic
@onready var bench_music = $BenchMusic
@onready var death_effect = $DeathEffect

func _ready():
	main_music.play()

func enter_bench():

	main_music.stop()

	bench_music.play()

func exit_bench():

	bench_music.stop()

	main_music.play()

func play_death_effect():
	death_effect.play()

func update_exposition(value):

	main_music.pitch_scale = 1.0 + value * 0.01
