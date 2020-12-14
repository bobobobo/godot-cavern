extends StateMachine.State

var direction_change_timer
var level_fire_probability 

func _on_enter(_previous):
    level_fire_probability = 0.001 + (0.0001 * min(100, target.level))
    reset_direction_change_timer()
    target.velocity.x = target.direction * target.SPEED
    set_animation()

func set_animation():
    if target.velocity.x<0:
        target.sprite.play("left_1")
    elif target.velocity.x>0:
        target.sprite.play("right_1")

func reset_direction_change_timer():
    direction_change_timer = 2 + randf() * 4

func _process(delta):
    direction_change_timer -= delta
    if direction_change_timer <= 0:
        var directions = [-1,1]
        if target.player != null:
            directions.append(sign(target.player.position.x - target.position.x))
        target.direction  = directions[randi() % directions.size()]
        target.velocity.x = target.direction * target.SPEED
        set_animation()
        reset_direction_change_timer()
        
    var fire_probability = level_fire_probability
    if target.player != null && (target.position.y - 15 < target.player.position.y + 15 && target.position.y +  15 > target.player.position.y - 15):
        fire_probability *= 10
        
    if randf() < fire_probability:
        state_machine.transition("fire")
    
    
func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()
    if target.is_on_wall():
        target.direction = -target.direction;
        target.velocity.x = target.direction * target.SPEED
        set_animation()

