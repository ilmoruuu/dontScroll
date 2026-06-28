extends ProgressBar

func _ready():
	max_value = GameManager.bem_max

func _process(_delta):
	value = GameManager.bem
	AudioManager.update_exposition(GameManager.bem / 2)
