using Godot;
using System;
using System.Threading.Tasks;

public class PlayerState : State
{
    /// <summary>
    ///  Typed reference to the player node.
    /// </summary>
    protected Player _player;

    public override void _Ready()
    {
        // The states are children of the `Player` node so their `_ready()` callback will execute first. That's why we wait for the `owner` to be ready first.
        Task.Run(async () => await ToSignal(Owner, "ready"));

        // The `as` keyword casts the `owner` variable to the `Player` type. If the `owner` is not a `Player`, we'll get `null`.
        _player = Owner as Player;

        // This check will tell us if we inadvertently assign a derived state script in a scene other than `Player.tscn`, which would be unintended. This can help prevent some bugs that are difficult to understand.
        if (_player == null)
        {
            throw new InvalidProgramException("Player is null in the PlayerState type check.");
        }
    }
}
