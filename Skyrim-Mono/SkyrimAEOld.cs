using CrowdControl.Common;
using CrowdControl.Games.Packs.SkyrimMono;
using JetBrains.Annotations;

namespace CrowdControl.Games.Packs.SkyrimAEOld;

[UsedImplicitly]
public class SkyrimAEOld : SkyrimPackBase
{
    public SkyrimAEOld(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler)
        : base(player, responseHandler, statusUpdateHandler) { }

    public override Game Game { get; } = new("The Elder Scrolls V: Skyrim Special Edition", "SkyrimAEOld", "PC", ConnectorType.SimpleTCPServerConnector);
}
