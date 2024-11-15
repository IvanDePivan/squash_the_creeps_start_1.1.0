extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	spawn_mob()
	
	
func spawn_mob() -> void:
	if $Player != null:
		var mob = mob_scene.instantiate()

		# Get a random location on the spwanpath
		var mob_spawn_location:PathFollow3D = get_node("SpawnPath/SpawnLocation")
		# add random offset
		mob_spawn_location.progress_ratio = randf()
	
		var player_position = $Player.position
		mob.initialize(mob_spawn_location.position, player_position)
		mob.squashed.connect($UserInterface/ScoreLabel.on_mob_squashed.bind())
		# Actually spawn the mob
		add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
