extends CanvasLayer

@onready var post_process = $PostProcess
@onready var notification_particles = $NotificationParticles

const GLITCH_START := 0.60
const NOTIFICATION_START := 0.60

var glitch_timer: float = 0.0
var glitch_interval: float = 5.0
var is_glitching: bool = false
var glitch_duration: float = 0.0

func _process(delta: float) -> void:
	var bem_percent = GameManager.bem / GameManager.bem_max
	var glitch_gate = clamp((bem_percent - GLITCH_START) / (1.0 - GLITCH_START), 0.0, 1.0)
	
	post_process.material.set_shader_parameter("gray_intensity", 1.0 - bem_percent)
	post_process.material.set_shader_parameter("glitch_intensity", lerp(0.0, 0.45, glitch_gate))
	
	if bem_percent >= GLITCH_START:
		_handle_glitch(delta, glitch_gate)
	else:
		post_process.material.set_shader_parameter("glitch_spike", 0.0)
	
	if bem_percent >= NOTIFICATION_START:
		notification_particles.emitting = true
		var notif_gate = clamp((bem_percent - NOTIFICATION_START) / (1.0 - NOTIFICATION_START), 0.0, 1.0)
		notification_particles.amount = int(lerp(5.0, 20.0, notif_gate))
	else:
		notification_particles.emitting = false
		notification_particles.amount = 1

func _handle_glitch(delta: float, glitch_gate: float) -> void:
	glitch_timer += delta
	glitch_interval = lerp(8.0, 1.5, glitch_gate)
	if !is_glitching and glitch_timer >= glitch_interval:
		glitch_timer = 0.0
		_trigger_glitch(glitch_gate)
	if is_glitching:
		glitch_duration -= delta
		if glitch_duration <= 0.0:
			is_glitching = false
			post_process.material.set_shader_parameter("glitch_spike", 0.0)

func _trigger_glitch(glitch_gate: float) -> void:
	is_glitching = true
	glitch_duration = randf_range(0.08, 0.25)
	post_process.material.set_shader_parameter("glitch_spike", lerp(0.0, 1.0, glitch_gate))
