extends CharacterBody2D

@export var acceleration: float = 200
@export var max_speed: float = 300
@export var friction: float = 100
@export var turn_speed: float = 3.0  # radians/sec
@export var turbo_multiplier: float = 2.0
@export var turbo_action: String = "turbo_p1"
@export var input_prefix: String = "p1" # "p1" or "p2"


func _physics_process(delta: float) -> void:
    var forward = Input.get_action_strength(input_prefix + "_down") - Input.get_action_strength(input_prefix + "_up")
    var turn = Input.get_action_strength(input_prefix + "_right") - Input.get_action_strength(input_prefix + "_left")
    var is_turbo = Input.is_action_pressed(turbo_action)

    var effective_max_speed = max_speed
    if is_turbo:
        effective_max_speed *= turbo_multiplier

    # Forward/backward acceleration
    if forward != 0:
        velocity += transform.y * forward * acceleration * delta
    else:
        if velocity.length() > 0:
            var drop = friction * delta
            velocity = velocity.move_toward(Vector2.ZERO, drop)

    # Clamp to max/turbo speed
    if velocity.length() > effective_max_speed:
        velocity = velocity.normalized() * effective_max_speed

    # Turning
    if velocity.length() > 10:
        rotation += turn * turn_speed * delta
        velocity = velocity.rotated(turn * turn_speed * delta * 0.2)

    move_and_slide()

    # Detect bounce
    for i in get_slide_collision_count():
        var collision = get_slide_collision(i)
        var normal = collision.get_normal()
        velocity = velocity.bounce(normal) * 0.8  # 0.8 = restitution (less than 1.0 loses energy)
