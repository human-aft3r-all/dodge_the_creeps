extends RigidBody2D

@export
var synced_position := Vector2()

@export
var velocity := Vector2()

@export
var direction := float()

@export
var mob_type := int()

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[mob_type % mob_types.size()])
	
	rotation = direction


func _process(delta):
	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		# The server updates the position that will be notified to the clients.
		move_and_collide(velocity.rotated(direction) * delta)
		synced_position = position
	else:
		# The client simply updates the position to the last known one.
		position = synced_position
		
	
		

func _on_visible_on_screen_notifier_2d_screen_exited():
	if is_multiplayer_authority():
		queue_free()
