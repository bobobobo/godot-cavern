extends StateMachine.State

var pop_timer

func _on_enter(_previous):
    if target.trigger_enemies.size() == 0:
        state_machine.transition("float")
    pop_timer = 3
    if target.velocity.y == 0:
        target.velocity = Vector2.ZERO
    target.sprite.play("trap1")
    target.captured_enemy = target.trigger_enemies.pop_front()
    target.captured_enemy.queue_free()
    
    
func _process(delta):
    pop_timer -= delta
    if pop_timer <= 0:
        state_machine.transition("pop")
    
    
func _physics_process(delta):
    if target.position.y > 35:
        target.apply_gravity(delta)
        target.move(delta)

