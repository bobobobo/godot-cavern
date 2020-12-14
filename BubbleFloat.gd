extends StateMachine.State

var pop_timer = 3

func _on_enter(_previous):
    target.velocity = Vector2.ZERO
   

func _process(delta):
    if target.sprite.animation == "blow" && target.sprite.frame >= target.sprite.frames.get_frame_count("blow")-1:
        target.sprite.play("float")
    pop_timer -= delta
    if pop_timer <= 0:
        state_machine.transition("pop")
    
func _physics_process(delta):
    if target.position.y > 35:
        target.apply_gravity(delta)
        target.move(delta)

    if target.trigger_enemies.size() > 0:
        state_machine.transition("captured")
