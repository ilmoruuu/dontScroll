extends StaticBody2D

@export var visible_time := 2
@export var hidden_time := 2

var collision: CollisionShape2D

func _ready():
	collision = $CollisionShape2D
	_start_visible()

func _get_times() -> Array:
	var b = GameManager.bem
	if b < 25.0:
		return [visible_time * 3.5, hidden_time * 0.5]
	elif b < 50.0:
		return [visible_time, hidden_time]
	elif b < 75.0:
		return [visible_time * 2, hidden_time * 0.5]
	else:
		return [visible_time * 0.5, hidden_time * 0.5]

func _start_visible():
	visible = true
	collision.disabled = false
	var times = _get_times()
	await get_tree().create_timer(times[0]).timeout
	_start_hidden()

func _start_hidden():
	visible = false
	collision.disabled = true
	var times = _get_times()
	await get_tree().create_timer(times[1]).timeout
	_start_visible()
