using System;
using System.Diagnostics.CodeAnalysis;
using ConnectorLib.SimpleTCP;
using CrowdControl.Common;
using CrowdControl.Games.Packs.SkyrimMono;

namespace CrowdControl.Games.Packs.SkyrimMono;

internal abstract class SkyrimPackBase : SimpleTCPPack<SimpleTCPServerConnector>
{
    public override string Host => "127.0.0.1";

    public override ushort Port => 59420;

    public override SITimeSpan ResponseTimeout => 60f;

    [SuppressMessage("CrowdControl.PackMetadata", "CC1009:Message Format Property")]
    public override ISimpleTCPPack.MessageFormatType MessageFormat => ISimpleTCPPack.MessageFormatType.CrowdControlLegacy;

    protected override SITimeSpan GameStateCheckInterval { get; } = 0.5f;

    public override bool StopAllEffects() => true;

    public override EffectList Effects => SkyrimEffects.Create();

    protected SkyrimPackBase(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler)
        : base(player, responseHandler, statusUpdateHandler) { }
}
