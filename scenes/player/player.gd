extends Area2D

signal hit

@export
var synced_position := Vector2()

@export
var speed = 400 ## How fast the player will move (pixels/sec).

var screen_size # Size of the game window.

@onready
var inputs = $Inputs

func start():
	show()
	$CollisionShape2D.disabled = false
	
func die():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	if str(name).is_valid_int():
		get_node("Inputs/InputsSync").set_multiplayer_authority(str(name).to_int())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.multiplayer_peer == null or str(multiplayer.get_unique_id()) == str(name):
		# The client which this player represent will update the controls state, and notify it to everyone.
		inputs.update()

	if multiplayer.multiplayer_peer == null or is_multiplayer_authority():
		# The server updates the position that will be notified to the clients.
		position += inputs.motion * speed * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		synced_position = position
	else:
		# The client simply updates the position to the last known one.
		position = synced_position

	if inputs.motion.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if inputs.motion.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = inputs.motion.x < 0
	elif inputs.motion.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = inputs.motion.y > 0
		
		
func _on_body_entered(body):
	die()
	hit.emit()
	
	
func set_player_name(value):
	$Name.text = value
