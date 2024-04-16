using Godot;
using System;
using System.Collections.Generic;
public class PowerSystem : Reference
{
    private Dictionary<Vector2, PowerSource> sources = new Dictionary<Vector2, PowerSource>();
    private Dictionary<Vector2, PowerReceiver> receivers = new Dictionary<Vector2, PowerReceiver>();

    private List<List<Vector2>> paths = new List<List<Vector2>>();

    private Dictionary<Vector2, float> receiverAlreadyProvided = new Dictionary<Vector2, float>();

    public void Setup(List<Node2D> powerSources,
                      List<Node2D> powerReceivers,
                      TileMap tileMap)
    {
        foreach (var source in powerSources)
        {
            var location = tileMap.WorldToMap(source.GlobalPosition);
            sources.Add(location, FindChildOfType<PowerSource>(source));
            paths.Add(new List<Vector2> { location });
        }

        foreach (var receiver in powerReceivers)
        {
            var location = tileMap.WorldToMap(receiver.GlobalPosition);
            receivers.Add(location, FindChildOfType<PowerReceiver>(receiver));
        }

        foreach (var path in paths)
        {
            foreach (var receiver in receivers)
            {
                if (receiver.Key.x == path[0].x + 1)
                {
                    path.Add(receiver.Key);
                }
            }
        }
    }

    public void Update(float delta)
    {
        receiverAlreadyProvided.Clear();

        foreach (var path in paths)
        {
            var source = sources[path[0]];

            var avilablePower = source.PowerAmount * source.Efficiency;

            var powerDraw = 0.0f;

            foreach (var cell in path.GetRange(1, path.Count - 1))
            {
                if (!receivers.ContainsKey(cell))
                {
                    continue;
                }

                var receiver = receivers[cell];
                var powerRequired = receiver.PowerRequired * receiver.Efficiency;

                if (receiverAlreadyProvided.ContainsKey(cell))
                {
                    var receiverTotal = receiverAlreadyProvided[cell];
                    if (receiverTotal >= powerRequired)
                    {
                        continue;
                    }
                    else
                    {
                        powerRequired -= receiverTotal;
                    }
                }

                receiver.EmitSignal("PowerReceived", Math.Min(avilablePower, powerRequired), delta);
                powerDraw += powerRequired;

                if (!receiverAlreadyProvided.ContainsKey(cell))
                {
                    receiverAlreadyProvided[cell] = Math.Min(avilablePower, powerRequired);
                }
                else
                {
                    receiverAlreadyProvided[cell] += Math.Min(avilablePower, powerRequired);
                }

                avilablePower -= powerRequired;
            }

            source.EmitSignal("PowerDrawn", powerDraw, delta);
        }
    }

    private T FindChildOfType<T>(Node parent) where T : Node
    {
        foreach (var child in parent.GetChildren())
        {
            if (child is T specifiedType)
            {
                return specifiedType;
            }
        }

        return null;
    }
}
