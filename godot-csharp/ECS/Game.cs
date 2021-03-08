using Godot;
using System.Collections.Generic;

public class Game : Node
{
    private PowerSystem powerSystem = new PowerSystem();

    public override void _Ready()
    {
        var sources = GetTree().GetNodesInGroup("power_sources");
        var sourceList = ToList<Node2D>(sources);
        var receivers = GetTree().GetNodesInGroup("power_receivers");
        var receiverList = ToList<Node2D>(receivers);
        var tileMap = GetNode<TileMap>("TileMap");
        powerSystem.Setup(sourceList, receiverList, tileMap);
    }

    public override void _PhysicsProcess(float delta)
    {
        powerSystem.Update(delta);
    }

    private List<T> ToList<T>(Godot.Collections.Array array) where T : Node
    {
        var results = new List<T>();

        foreach (var element in array)
        {
            results.Add((T)element);
        }

        return results;
    }
}
