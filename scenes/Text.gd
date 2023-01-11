extends Label

signal finished

onready var sound_open = load("res://sounds/fx/text_open.wav")
onready var sound_close = load("res://sounds/fx/text_close.wav")
onready var sound_text = load("res://sounds/fx/text.wav")

var finished = false

func _ready():
	visible = false

func _process(delta):
	if finished and Input.is_action_just_pressed("ui_accept"):
		finished = false
		Game.get_player().enabled = true
		visible = false

func scroll(message, delay = 0.06, finish = 2.0):
	finished = false
	if text == message or message == "":
		visible = false
		Game.get_player().enable()
		text = ""
		$AudioStreamPlayer.stream = sound_close
		$AudioStreamPlayer.bus = "Interface R"
		$AudioStreamPlayer.play()
		emit_signal("finished")
		finished = true
	else:
		text = message
		visible = true
		visible_characters = 0
		
		$AudioStreamPlayer.stream = sound_open
		$AudioStreamPlayer.bus = "Interface R"
		$AudioStreamPlayer.play()
		
		Game.get_player().enabled = false
		
		for i in range(len(message)):
			var d = delay if not Input.is_action_pressed("ui_accept") else delay / 4.0
			yield(get_tree().create_timer(d), "timeout")
			if not visible: break
			$AudioStreamPlayer.bus = "Interface"
			$AudioStreamPlayer.stream = sound_text
			visible_characters += 1
			$AudioStreamPlayer.play()
		finished = true
