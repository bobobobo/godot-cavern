extends StateMachine.State

var direction_change_timer
var level_fire_probability 

func _on_enter(_previous):
    level_fire_probability = 0.001 + (0.0001 * min(100, target.level))
    reset_direction_change_timer()
    target.velocity.x = target.direction * target.speed
    set_animation()

func set_animation():
    if target.velocity.x<0 && target.sprite.animation != "left":
        target.sprite.play("left")
    elif target.velocity.x>0 && target.sprite.animation != "right":
        target.sprite.play("right")

func reset_direction_change_timer():
    direction_change_timer = 2 + randf() * 4

func _process(delta):
    direction_change_timer -= delta
    if direction_change_timer <= 0:
        var directions = [-1,1]
        if target.player != null:
            directions.append(sign(target.player.position.x - target.position.x))
        target.direction  = directions[randi() % directions.size()]
        target.velocity.x = target.direction * target.speed
        set_animation()
        reset_direction_change_timer()

    fire()
    
func is_on_same_y_level(obj):
    return obj != null && (target.position.y - 15 < obj.position.y + 15 && target.position.y +  15 > obj.position.y - 15)


func fire():
    var fire_probability = level_fire_probability
    if is_on_same_y_level(target.player):
        fire_probability *= 10
        
    if randf() < fire_probability:
        state_machine.transition("fire")

func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()
    if target.is_on_wall():
        target.direction = -target.direction;
        target.velocity.x = target.direction * target.speed
    set_animation()

