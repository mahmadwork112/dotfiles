class_name Player extends CharacterBody2D

const move_speed : float = 100.0

var direction := Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	State.player = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var direction : Vector2 = Vector2.ZERO
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	#
	#velocity = direction * move_speed
	pass

func _physics_process(delta: float) -> void:
	update_direction()
	move_and_slide()
	pass

func update_direction() -> void:
	direction = Input.get_vector( "left" , "right" , "up" , "down" )
