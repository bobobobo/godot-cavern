extends StateMachine.State


var recoil_timer 
var previous_state
func _on_enter(previous):

    if target.hit_direction < 0:
        target.sprite.play("recoil_left")
    else:
        target.sprite.play("recoil_right")
    target.velocity.x = -sign(target.hit_direction) * target.SPEED * 1.5
    recoil_timer = target.get_tree().create_timer(0.2)

    previous_state = previous
    
func _on_exit(_new_state):
    recoil_timer = null

func _physics_process(delta):
    if recoil_timer != null && recoil_timer.time_left <= 0:
        state_machine.transition(previous_state)
    else:
        target.move(delta)
        target.handle_fall_in_hole()

            
