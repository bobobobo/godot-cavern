extends StateMachine.State


func _on_enter(_previous):
    target.velocity = Vector2.ZERO
    target.sprite.play("idle")

func _process(delta):
    var move = (Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'))
    var jump = Input.is_action_just_pressed('ui_up')
    var blow = Input.is_action_just_pressed("ui_select")
    if blow:
        state_machine.transition("blow")  
    elif jump and target.is_on_floor():
        state_machine.transition("jump")
    elif move != 0:
        state_machine.transition("run")
    
    
func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()
