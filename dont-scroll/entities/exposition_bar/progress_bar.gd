extends ProgressBar

@export var target: CharacterBody2D

func _ready():
	target.exposition_changed.connect(exposition_update)
	exposition_update()

func exposition_update():
	value = target.expositon
	AudioManager.update_exposition(target.expositon / 2)
