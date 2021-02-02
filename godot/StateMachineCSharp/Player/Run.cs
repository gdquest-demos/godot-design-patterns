using Godot;
using System.Collections.Generic;

public class Run : PlayerState
{
    public override void PhysicsUpdate(float delta)
    {
        // Notice how we have some code duplication between states.That's inherent to the pattern,
        // although in production, your states will tend to be more complex and duplicate code
        // much more rare.
        if (!_player.IsOnFloor())
        {
            _stateMachine.TransitionTo("Air");
        }

        // We move the run-specific input code to the state.
        // A good alternative would be to define a `get_input_direction()` function on the `Player.gd`
        // script to avoid duplicating these lines in every script.
        var inputDirectionX = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");

        _player.Velocity.x = _player.Speed * inputDirectionX;
        _player.Velocity.y += _player.Gravity * delta;
        _player.Velocity = _player.MoveAndSlide(_player.Velocity, Vector2.Up);

        if (Input.IsActionJustPressed("move_up"))
        {
            var message = new Dictionary<string, bool>()
            {
                { "doJump", true}
            };
            _stateMachine.TransitionTo("Air", message);
        }
        else if (Godot.Mathf.IsEqualApprox(inputDirectionX, 0.0f))
        {
            _stateMachine.TransitionTo("Idle");
        }
    }
}
