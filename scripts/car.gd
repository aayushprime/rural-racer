extends CharacterBody2D

@export var acceleration: float = 400.0
@export var max_speed: float = 600.0
@export var friction: float = 300.0
@export var turn_speed: float = 3.0  # radians/sec

# var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
    var input_forward =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    var input_turn = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

    # Forward/backward acceleration
    if input_forward != 0:
        velocity += transform.y * input_forward * acceleration * delta
    else:
        # Apply friction when not accelerating
        if velocity.length() > 0:
            var drop = friction * delta
            velocity = velocity.move_toward(Vector2.ZERO, drop)

    # Clamp to max speed
    if velocity.length() > max_speed:
        velocity = velocity.normalized() * max_speed

    # Turning (only if moving)
    if velocity.length() > 10:
        rotation += input_turn * turn_speed * delta
        velocity = velocity.rotated(input_turn * turn_speed * delta * 0.2)  # helps drift feel

    # Move
    move_and_slide()
    velocity = velocity  # keep updated for next frame
    move_and_slide()
