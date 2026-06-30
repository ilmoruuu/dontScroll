extends Node

# ── BEM (Barra de Exposição Mental) ──────────────────
var bem: float = 0.0
var bem_max: float = 100.0
var bem_rate: float = 3.0
var player_on_bench: bool = false

# ── Estado do jogador ─────────────────────────────────
var is_crashed: bool = false
var crash_timer: float = 0.0
var crash_limit: float = 5.0

# ── Progresso do jogo ─────────────────────────────────
var current_phase: int = 1
var checkpoint_scene: String = "res://scenes/levels/fase1.tscn"
var inventory: Array = []

# ── Estados de BEM ────────────────────────────────────
enum BEMState { CALM, MEDIUM, ANXIOUS, OVERLOAD }

func _process(delta: float) -> void:
	if not player_on_bench:
		bem = clamp(bem + bem_rate * delta, 0.0, bem_max)
	_check_crash(delta)

func get_bem_state() -> int:
	if bem < 25.0: return BEMState.CALM
	elif bem < 50.0: return BEMState.MEDIUM
	elif bem < 75.0: return BEMState.ANXIOUS
	else: return BEMState.OVERLOAD

func get_player_speed_mult() -> float:
	match get_bem_state():
		BEMState.CALM: return 1.0
		BEMState.MEDIUM: return 0.97
		BEMState.ANXIOUS: return 0.88
		BEMState.OVERLOAD: return 0.78
	return 1.0

func _check_crash(delta: float) -> void:
	if bem >= bem_max and not is_crashed:
		is_crashed = true
		crash_timer = 0.0
	if is_crashed:
		crash_timer += delta
		if crash_timer >= crash_limit:
			game_over()
		if bem < bem_max - 10.0:
			is_crashed = false
			crash_timer = 0.0

func bem_add(amount: float) -> void:
	bem = clamp(bem + amount, 0.0, bem_max)

func bem_reduce(amount: float) -> void:
	bem = clamp(bem - amount, 0.0, bem_max)
	if is_crashed and bem < bem_max - 20.0:
		is_crashed = false
		crash_timer = 0.0

func respawn() -> void:
	bem = 0.0
	is_crashed = false
	call_deferred("_do_respawn")

func _do_respawn() -> void:
	AudioManager.play_death_effect()
	get_tree().change_scene_to_file(checkpoint_scene)
	
func _ready() -> void:
	pause_bem()

func pause_bem() -> void:
	set_process(false)

func resume_bem() -> void:
	set_process(true)

func game_over() -> void:
	bem = 60.0
	AudioManager.play_death_effect()
	
	is_crashed = false
	inventory.clear()
	get_tree().change_scene_to_file(checkpoint_scene)
