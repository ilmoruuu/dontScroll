extends CanvasLayer

@onready var events = $EventsDatabase.events
@onready var label = $Control/ColorRect/RichTextLabel
@onready var options_container = $VBoxContainer

var current_text := ""
var char_index := 0
var typing := false
var selected_option := -1
var waiting_for_option := false
var current_bench = null
var is_text_fully_displayed := false 
var current_raw_text := ""

func _ready():
	visible = false
	$Control.visible = false

func start_random_event(bench_reference):
	current_bench = bench_reference
	visible = true
	$Control.visible = true
	options_container.visible = false

	var event = events.pick_random()
	await play_event(event)
	
	stop_dialogue()
	
func play_event(event):
	for text in event.texts:
		current_raw_text = text
		is_text_fully_displayed = false
		
		show_text(text)
		await wait_for_confirm()

	await show_question(event)
	
func show_text(text):
	label.text = ""
	for chara in text:
		if is_text_fully_displayed: 
			return 
			
		label.text += chara
		await get_tree().create_timer(0.03).timeout
	
	is_text_fully_displayed = true
		
func wait_for_confirm():
	await get_tree().create_timer(0.1).timeout
	while true:
		await get_tree().process_frame

		if Input.is_action_just_pressed("ui_accept"):
			get_tree().root.set_input_as_handled()
			
			if not is_text_fully_displayed:
				
				is_text_fully_displayed = true
				label.text = current_raw_text
				await get_tree().process_frame 
			else:
			
				return

func show_question(event):
	label.text = event.question
	options_container.visible = true

	for child in options_container.get_children():
		child.queue_free()

	selected_option = -1
	create_option_buttons(event)
	waiting_for_option = true

	while waiting_for_option:
		await get_tree().process_frame

	options_container.visible = false
	
func create_option_buttons(event):
	for i in range(event.options.size()):
		var button = Button.new()
		button.text = event.options[i]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		button.custom_minimum_size = Vector2(0, 24)
		button.pressed.connect(
			func():
				selected_option = i
				waiting_for_option = false
		)
		options_container.add_child(button)

func stop_dialogue():
	visible = false
	$Control.visible = false
	
	if current_bench:
		current_bench.finish_bench_dialog()
		current_bench = null
