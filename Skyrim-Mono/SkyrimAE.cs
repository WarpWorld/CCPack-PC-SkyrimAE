using CrowdControl.Common;
using CrowdControl.Games.Packs.SkyrimMono;
using JetBrains.Annotations;

namespace CrowdControl.Games.Packs.SkyrimAE;

[UsedImplicitly]
public class SkyrimAE : SkyrimPackBase
{
    public SkyrimAE(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler)
        : base(player, responseHandler, statusUpdateHandler) { }

    public override Game Game { get; } = new("The Elder Scrolls V: Skyrim Special Edition", "SkyrimAE", "PC", ConnectorType.SimpleTCPServerConnector);
}
