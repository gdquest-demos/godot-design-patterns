using Godot;
using System.Collections.Generic;

public class State : Node
{
    /// <summary>
    /// # Reference to the state machine, to call its `transition_to()` method directly.
    /// That's one unorthodox detail of our state implementation, as it adds a dependency between the
    /// state and the state machine objects, but we found it to be most efficient for our needs.
    /// The state machine node will set it.
    /// </summary>
    public StateMachine _stateMachine = null;

    /// <summary>
    /// Virtual function. Receives events from the `_unhandled_input()` callback.
    /// </summary>
    /// <param name="inputEvent"></param>
    public virtual void HandleInputs(InputEvent inputEvent)
    {
        return;
    }

    /// <summary>
    /// Virtual function. Corresponds to the `_process()` callback.
    /// </summary>
    /// <param name="delta"></param>
    public virtual void Update(float delta)
    {
        return;
    }

    /// <summary>
    /// Virtual function. Corresponds to the `_physics_process()` callback.
    /// </summary>
    /// <param name="delta"></param>
    public virtual void PhysicsUpdate(float delta)
    {
        return;
    }

    /// <summary>
    /// Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
    /// is a dictionary with arbitrary data the state can use to initialize itself.
    /// </summary>
    /// <param name="message"></param>
    public virtual void Enter(Dictionary<string, bool> message = null)
    {
        return;
    }

    /// <summary>
    /// Virtual function. Called by the state machine before changing the active state. Use this function
    /// to clean up the state.
    /// </summary>
    public virtual void Exit()
    {
        return;
    }
}
