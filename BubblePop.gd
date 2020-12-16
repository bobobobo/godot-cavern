extends StateMachine.State


func _on_enter(_previous):
    target.velocity = Vector2.ZERO
    target.sprite.play("pop")    
    yield(target.sprite,"animation_finished")
    target.emit_signal("popped", target)
    target.queue_free()
    

    
    
