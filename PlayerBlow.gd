extends StateMachine.State

var last_blow_timer = null

func _on_enter(previous):
    if last_blow_timer != null && last_blow_timer.time_left > 0:
        state_machine.transition(previous)
        return
        
    target.velocity.x = 0
    if target.last_movement.x<0:
        target.sprite.play("blow_left")
    else:
        target.sprite.play("blow_right")
    target.blow()
    yield(target.get_tree().create_timer(0.2), "timeout")
    last_blow_timer = target.get_tree().create_timer(0.2)
    state_machine.transition(previous)
    


func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()

            
