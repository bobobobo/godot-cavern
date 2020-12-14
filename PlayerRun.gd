extends StateMachine.State

func _on_enter(_previous):
    set_animation()
    
func get_input():
    target.velocity.x = (Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')) * target.SPEED
    if target.velocity.x != 0:
        target.last_movement = Vector2(target.velocity.x, 0)
    var jump = Input.is_action_just_pressed('ui_up')
    var blow = Input.is_action_just_pressed("ui_select")
    if blow:
        state_machine.transition("blow")  
    elif jump and target.is_on_floor():
        state_machine.transition("jump")
    elif target.velocity.x == 0:
        state_machine.transition("idle")

func set_animation():
    if target.velocity.x<0:
        target.sprite.play("run_left")
    elif target.velocity.x>0:
        target.sprite.play("run_right")

func _process(_delta):
    get_input()
    set_animation()
    
func _physics_process(delta):
    target.move(delta)
    target.handle_fall_in_hole()
