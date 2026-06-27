extends AnimatableBody2D

@export var amplitude := 50.0
@export var speed := 1.2

var base_x: float
var t: float = 0.0
var current_amp: float = 0.0
var current_spd: float = 0.0

func _ready():
	base_x = global_position.x
	t = randf_range(0.0, TAU)

func _physics_process(delta):
	var target_amp: float
	var target_spd: float
	
	match GameManager.get_bem_state():
		GameManager.BEMState.CALM:
			target_amp = amplitude * 0.3
			target_spd = speed * 0.4
		GameManager.BEMState.MEDIUM:
			target_amp = amplitude * 0.6
			target_spd = speed * 0.7
		GameManager.BEMState.ANXIOUS:
			target_amp = amplitude * 1.0
			target_spd = speed * 1.2
		GameManager.BEMState.OVERLOAD:
			target_amp = amplitude * 1.5
			target_spd = speed * 2.0
		_:
			target_amp = amplitude
			target_spd = speed

	current_amp = lerp(current_amp, target_amp, delta * 2.0)
	current_spd = lerp(current_spd, target_spd, delta * 2.0)
	
	t += delta * current_spd
	global_position.x = base_x + sin(t) * current_amp
