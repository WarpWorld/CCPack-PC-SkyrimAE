using CrowdControl.Common;
using CrowdControl.Games.Packs.SkyrimMono;
using JetBrains.Annotations;

namespace CrowdControl.Games.Packs.SkyrimAEGOG;

[UsedImplicitly]
public class SkyrimAEGOG : SkyrimPackBase
{
    public SkyrimAEGOG(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler)
        : base(player, responseHandler, statusUpdateHandler) { }

    public override Game Game { get; } = new("The Elder Scrolls V: Skyrim Special Edition", "SkyrimAEGOG", "PC", ConnectorType.SimpleTCPServerConnector);
}
