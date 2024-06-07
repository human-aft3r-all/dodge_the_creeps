extends MultiplayerSpawner

func _init():
	spawn_function = _spawn_mob

func _spawn_mob(data):
		# Create a new instance of the Mob scene.
	var mob = preload("res://scenes/mob/mob.tscn").instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	mob.direction = (mob_spawn_location.rotation + PI / 2) + randf_range(-PI / 4, PI / 4)
	mob.velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.mob_type = randi()
	
	return mob
