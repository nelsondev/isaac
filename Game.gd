extends Node

var health = 1
var health_max = 3
var levels = [
	"res://levels/Entrance.tscn",
	"res://levels/F1R1.tscn",
	"res://levels/F1R2.tscn",
	"res://levels/F1R3.tscn",
]
var loading = false

func get_player(): return $"/root/Node2D/Player"
func get_camera(): return get_player().get_node("Camera2D") as PlayerCamera
func get_level(): return $"/root/Node2D"
func get_level_node(path): return $"/root/Node2D".get_node(path)
func get_map(): return $"/root/Node2D/Map"
func get_ui(): return $"/root/Node2D/CanvasLayer"
func get_ui_node(node: NodePath): return get_ui().get_node(node)
func get_text(): return get_ui_node("Text")

func set_player_enabled(value): get_player().enabled = value
func set_level(index):
	if loading: return
	
	loading = true
	get_player().enabled = false
	var animation = get_ui_node("AnimationPlayer_Level") as AnimationPlayer
	
	animation.play_backwards("default")
	yield(animation, "animation_finished")
	
	get_map().remove_child(get_map().get_child(0))
	
	var LEVEL = load(levels[index])
	var level = LEVEL.instance()
	get_map().add_child(level)
	get_player().set_global_position(level.get_node("Spawn").get_global_position())
	animation.play("default")
	yield(animation, "animation_finished")
	loading = false
	get_player().enabled = true
