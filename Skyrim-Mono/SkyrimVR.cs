using CrowdControl.Common;
using CrowdControl.Games.Packs.SkyrimMono;
using JetBrains.Annotations;

namespace CrowdControl.Games.Packs.SkyrimVR;

[UsedImplicitly]
public class SkyrimVR : SkyrimPackBase
{
    public SkyrimVR(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler)
        : base(player, responseHandler, statusUpdateHandler) { }

    public override Game Game { get; } = new("The Elder Scrolls V: Skyrim VR", "SkyrimVR", "PC", ConnectorType.SimpleTCPServerConnector);
}
