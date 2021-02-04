using Godot;
using System;
using System.Collections.Generic;

public class Idle : PlayerState
{
    /// <summary>
    /// Upon entering the state, we set the Player node's velocity to zero.
    /// </summary>
    /// <param name="message"></param>
    public override void Enter(Dictionary<string, bool> message = null)
    {
        // We must declare all the properties we access through `owner` in the `Player.cs` script.
        _player.Velocity = Vector2.Zero;
    }

    public override void PhysicsUpdate(float delta)
    {
        // If you have platforms that break when standing on them, you need that check for the character to fall.
        if (!_player.IsOnFloor())
        {
            _stateMachine.TransitionTo("Air");
            return;
        }

        if (Input.IsActionJustPressed("move_up"))
        {
            // As we'll only have one air state for both jump and fall, we use the `msg` dictionary 
            // to tell the next state that we want to jump.
            var message = new Dictionary<string, bool>()
            {
                { "doJump", true }
            };
            _stateMachine.TransitionTo("Air", message);
        }
        else if (Input.IsActionPressed("move_left") || Input.IsActionPressed("move_right"))
        {
            _stateMachine.TransitionTo("Run");
        }
    }
}
