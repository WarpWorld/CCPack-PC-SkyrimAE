using System;
using System.Collections.Generic;
using System.Reflection;
using CrowdControl.Common;
using JetBrains.Annotations;

//ccpragma { "include" : [ "..\\Windows10\\Windows10.cs" ] }
namespace CrowdControl.Games.Packs
{
    [UsedImplicitly]
    public class SkyrimAE : SimpleTCPPack
    {
        private readonly Windows10 _win10;
        private readonly MethodInfo _win10_start_effect = typeof(Windows10).GetMethod("StartEffect", BindingFlags.NonPublic | BindingFlags.Instance, null, new[] { typeof(EffectRequest) }, null);
        private readonly MethodInfo _win10_stop_effect = typeof(Windows10).GetMethod("StopEffect", BindingFlags.NonPublic | BindingFlags.Instance, null, new[] { typeof(EffectRequest) }, null);
        private readonly HashSet<string> _win10_includes = new(new[] { "invdisplay", "invmouse", "sendleftclick", "sendrightclick", "randmouse", "mousebuttonswap" }, StringComparer.InvariantCultureIgnoreCase);

        public override string Host => "127.0.0.1";

        public override ushort Port => 59420;

        public SkyrimAE(Player player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler)
        {
            _win10 = new Windows10(player, _ => true, _ => { });
            Effects.AddRange(_win10.Effects.Where(e => _win10_includes.Contains(e.Code)).Select(e =>
            {
                e.Parent = "miscellaneous";
                return e;
            }));
        }

        public override Game Game { get; } = new(123, "The Elder Scrolls V: Skyrim Special Edition", "SkyrimAE", "PC", ConnectorType.SimpleTCPConnector);

        public override EffectList Effects { get; } = new Effect[]
            {
                #region Give Item (folder)

                new Effect("Give Items", "items", ItemKind.Folder),
                new Effect("Apples (5)", "give_apple", "items"),
                //new Effect("Spawn Cheese Wheel", "spawn_applecheese_wheel", "items"),
                new Effect("Health Potion", "give_health_potion", "items"),
                new Effect("Magika Potion", "give_magika_potion", "items"),
                new Effect("Lockpicks (5)", "give_lockpicks", "items"),
                new Effect("Arrows (5)", "give_arrows", "items"),
                new Effect("Baked Potatoes", "give_bpotatos", "items"),
                new Effect("Dragon Bone Weapon", "give_dragonweap", "items"),
                new Effect("Dragon Bone", "give_dragonbone", "items"),
                new Effect("Dragon Scales", "give_dragonscale", "items"),
                new Effect("Diamond", "give_diamond", "items"),
                new Effect("Iron Ingot", "give_iron", "items"),
                new Effect("Gold Ingot", "give_gold", "items"),
                new Effect("Potatoes (5)", "give_potatos", "items"),
                new Effect("Silver Ingot", "give_silver", "items"),
                new Effect("Steel Ingot", "give_steel", "items"),
                new Effect("Gold (10)", "give_gold_10", "items"),
                new Effect("Gold (100)", "give_gold_100", "items"),
                new Effect("Gold (1000)", "give_gold_1000", "items"),
                new Effect("Soul Gem (Petty)", "gem_petty", "items"),
                new Effect("Soul Gem (Lesser)", "gem_lesser", "items"),
                new Effect("Soul Gem (Common)", "gem_common", "items"),
                new Effect("Soul Gem (Greater)", "gem_greater", "items"),
                new Effect("Soul Gem (Grand)", "gem_grand", "items"),
                new Effect("Exploding Spider Scroll", "give_spider", "items"),
                new Effect("Dwemer's Curse", "dwemercurse", "items"),
                new Effect("Cheese-splosion", "cheeserain", "items"),

                new Effect("Skills", "skills", ItemKind.Folder),
                new Effect("One Handed Up", "onehanded_up", "skills"),
                new Effect("One Handed Down", "onehanded_down", "skills"),
                new Effect("Two Handed Up", "twohanded_up", "skills"),
                new Effect("Two Handed Down", "twohanded_down", "skills"),
                new Effect("Archery Up", "marksman_up", "skills"),
                new Effect("Archery Down", "marksman_down", "skills"),
                new Effect("Block Up", "block_up", "skills"),
                new Effect("Block Down", "block_down", "skills"),
                new Effect("Smithing Up", "smithing_up", "skills"),
                new Effect("Smithing Down", "smithing_down", "skills"),
                new Effect("Heavy Armor Up", "heavyarmor_up", "skills"),
                new Effect("Heavy Armor Down", "heavyarmor_down", "skills"),
                new Effect("Light Armor Up", "lightarmor_up", "skills"),
                new Effect("Light Armor Down", "lightarmor_down", "skills"),
                new Effect("Pickpocket Up", "pickpocket_up", "skills"),
                new Effect("Pickpocket Down", "pickpocket_down", "skills"),
                new Effect("Lock Picking Up", "lockpicking_up", "skills"),
                new Effect("Lock Picking Down", "lockpicking_down", "skills"),
                new Effect("Sneak Up", "sneak_up", "skills"),
                new Effect("Sneak Down", "sneak_down", "skills"),
                new Effect("Alchemy Up", "alchemy_up", "skills"),
                new Effect("Alchemy Down", "alchemy_down", "skills"),
                new Effect("Speech Up", "speechcraft_up", "skills"),
                new Effect("Speech Down", "speechcraft_down", "skills"),
                new Effect("Alteration Up", "alteration_up", "skills"),
                new Effect("Alteration Down", "alteration_down", "skills"),
                new Effect("Conjuration Up", "conjuration_up", "skills"),
                new Effect("Conjuration Down", "conjuration_down", "skills"),
                new Effect("Destruction Up", "destruction_up", "skills"),
                new Effect("Destruction Down", "destruction_down", "skills"),
                new Effect("Illusion Up", "illusion_up", "skills"),
                new Effect("Illusion Down", "illusion_down", "skills"),
                new Effect("Restoration Up", "restoration_up", "skills"),
                new Effect("Restoration Down", "restoration_down", "skills"),
                new Effect("Enchanting Up", "enchanting_up", "skills"),
                new Effect("Enchanting Down", "enchanting_down", "skills"),
                

                #endregion

                #region Take Away Item

                new Effect("Take Away Items", "take_items", ItemKind.Folder),
                //new Effect("Health Potion", "take_health_potion", "take_items"),
                //new Effect("Magika Potion", "take_magika_potion", "take_items"),
                new Effect("Take Lockpick", "take_lockpick", "take_items"),
                new Effect("Take Arrows", "take_arrows", "take_items"),
                new Effect("Take Gold (10)", "take_gold_10", "take_items"),
                new Effect("Take Gold (100)", "take_gold_100", "take_items"),
                new Effect("Take Gold (1000)", "take_gold_1000", "take_items"),

                #endregion

                #region Spawn Enemy (folder)

                //new Effect("Spawn Angry Chicken", "spawn_angry_chicken", "enemies"),

                new Effect("Spawn Enemy", "enemies", ItemKind.Folder),
                new Effect("Dragon", "spawn_dragon", "enemies"),
                //new Effect("Tiny Dragon", "spawn_tinydragon", "enemies"),
                new Effect("Witch", "spawn_witch", "enemies"),
                new Effect("Draugr", "spawn_draugr", "enemies"),
                new Effect("Draugr Overlord", "spawnb_draugr_over", "enemies"),
                new Effect("Bandit", "spawn_bandit", "enemies"),
                new Effect("Bandit Party", "spawn_bandits", "enemies"),
                new Effect("Skeleton", "spawn_skeleton", "enemies"),
                new Effect("Flame Atronach", "spawnb_flameatronach", "enemies"),
                new Effect("Frost Atronach", "spawnb_frostatronach", "enemies"),
                new Effect("Storm Atronach", "spawnb_stormatronach", "enemies"),
                new Effect("Mammoth", "spawnb_mammoth", "enemies"),
                new Effect("Giant Spider", "spawnb_giantspider", "enemies"),
                new Effect("Spriggan", "spawnb_spriggan", "enemies"),
                new Effect("Mudcrabs", "spawnb_mudcrab", "enemies"),
                new Effect("Hargraven", "spawnb_hagraven", "enemies"),
                new Effect("Dwarven Centurion", "spawnb_dwarvencenturion", "enemies"),
                new Effect("Ice Wraith", "spawnb_ice_wraith", "enemies"),
                new Effect("Frost Troll", "spawnb_frost_troll", "enemies"),


                new Effect("Spawn Animal", "animals", ItemKind.Folder),
                new Effect("Bear", "spawnb_bear", "animals"),
                new Effect("Chicken", "spawnb_chicken", "animals"),
                new Effect("Cow", "spawnb_cow", "animals"),
                new Effect("Deer", "spawnb_deer", "animals"),
                new Effect("Dog", "spawnb_dog", "animals"),
                new Effect("Goat", "spawnb_goat", "animals"),
                new Effect("Wolf", "spawnb_wolf", "animals"),
                new Effect("Horse", "spawn_horse", "animals"),
                #endregion

                new Effect("Clear Bound State", "unbound"),

                new Effect("Spawn NPC", "npcs", ItemKind.Folder),
                new Effect("Balgruuf the Greater", "spawnb_balgruuf", "npcs"),
                new Effect("Sheogorath", "spawnb_sheo", "npcs"),
                new Effect("Cicero", "spawnb_cicero", "npcs"),
                new Effect("Aela the Huntress", "spawnb_aela", "npcs"),
                new Effect("Jarl Ulfric Stormcloak", "spawnb_ulfric", "npcs"),
                new Effect("Serana", "spawnb_serana", "npcs"),
                new Effect("Mjoll the Lioness", "spawnb_mjoll", "npcs"),
                new Effect("M'aiq the Liar", "spawnb_maiq", "npcs"),
                new Effect("Legate Rikke", "spawnb_rikke", "npcs"),

                new Effect("Change Time", "time", ItemKind.Folder),
                new Effect("Midnight", "time_midnight", "time"),
                new Effect("Morning", "time_morning", "time"),
                new Effect("Noon", "time_noon", "time"),
                new Effect("Evening", "time_evening", "time"),



                new Effect("Change Weather", "weather", ItemKind.Folder),
                new Effect("Clear", "weather_clear", "weather"),
                new Effect("Rain", "weather_storm", "weather"),
                new Effect("Snow", "weather_snow", "weather"),
                new Effect("Red", "weather_red", "weather"),
                new Effect("Green", "weather_green", "weather"),
                new Effect("Blue", "weather_blue", "weather"),

                new Effect("Change Race", "race", ItemKind.Folder),
                new Effect("Argonian", "race_argonian", "race"),
                new Effect("Breton", "race_breton", "race"),
                new Effect("Dark Elf", "race_darkelf", "race"),
                new Effect("High Elf", "race_highelf", "race"),
                new Effect("Imperial", "race_imperial", "race"),
                new Effect("Khajiit", "race_khajiit", "race"),
                new Effect("Nord", "race_nord", "race"),
                new Effect("Orc", "race_orc", "race"),
                new Effect("Redguard", "race_redguard", "race"),
                new Effect("Wood Elf", "race_woodelf", "race"),


                new Effect("Health and Stamina", "health", ItemKind.Folder),
                new Effect("Heal Player", "heal", "health"),
                new Effect("Full Heal", "full_heal", "health"),
                new Effect("Kill Player", "kill_player", "health"),
                new Effect("Damage Player", "damage", "health"),
                new Effect("10% Health", "to_ten_health", "health"),
                new Effect("Infinite Stamina", "infinite_stamina", "health") { Duration = TimeSpan.FromSeconds(30) },
                new Effect("Deplete Stamina", "deplete_stamina", "health"),

                new Effect("Buffs and Debuffs", "buffs", ItemKind.Folder),
                new Effect("Good Random Spell", "good_spell", "buffs"),
                new Effect("Bad Random Spell", "bad_spell", "buffs"),
                new Effect("Increase Speed (30 seconds)", "increase_speed", "buffs"),
                //new Effect("Increase Jump (30 seconds)", "increase_jump", "buffs"),
                new Effect("Increased Damage (30 seconds)", "increase_damage", "buffs"),
                new Effect("Disable Crouch", "disable_crouch", "buffs") { Duration = TimeSpan.FromSeconds(60) },
                new Effect("Destroy/Unlearn Left Hand", "destroy_left", "buffs"),
                new Effect("Destroy/Unlearn Right Hand", "destroy_right", "buffs"),
                new Effect("Decrease Speed (30 seconds)", "decrease_speed", "buffs"),
                //new Effect("Decrease Jump (30 seconds)", "decrease_jump", "buffs"),
                new Effect("Decrease Damage (30 seconds)", "decrease_damage", "buffs"),
                new Effect("Disable Fast Travel", "disable_fast_travel", "buffs") { Duration = TimeSpan.FromSeconds(30) },
                new Effect("Freeze Player", "freeze", "buffs"),
                //new Effect("Lightning Strike", "lightning", "buffs"),
                



                new Effect("Use Scroll", "scrolls", ItemKind.Folder),
                new Effect("Mayhem", "scroll_mayhem", "scrolls"),
                new Effect("Hysteria", "scroll_hysteria", "scrolls"),
                new Effect("Harmony", "scroll_harmony", "scrolls"),
                new Effect("Water Breathing", "scroll_water", "scrolls"),
                new Effect("Conjure Flame Atronach", "scroll_cflame", "scrolls"),
                new Effect("Conjure Frost Atronach", "scroll_cfrost", "scrolls"),
                new Effect("Conjure Storm Atronach", "scroll_cstorm", "scrolls"),
                new Effect("Flame Thrall", "scroll_tflame", "scrolls"),
                new Effect("Frost Thrall", "scroll_tfrost", "scrolls"),
                new Effect("Storm Thrall", "scroll_tstorm", "scrolls"),
                new Effect("Blizzard", "scroll_blizzard", "scrolls"),
                new Effect("Invisibility", "scroll_invis", "scrolls"),

                #region Fast Travel

                new Effect("Fast Travel", "fast_travel", ItemKind.Folder),
                new Effect("Random Fast Travel", "random_fast_travel", "fast_travel"),
                new Effect("Fast Travel to Whiterun", "fast_travel_whiterun", "fast_travel"),
                new Effect("Fast Travel to Riverwood", "fast_travel_riverwood", "fast_travel"),
                new Effect("Fast Travel to Solitude", "fast_travel_solitude", "fast_travel"),
                new Effect("Fast Travel to Windhelm", "fast_travel_windhelm", "fast_travel"),
                new Effect("Fast Travel to Markarth", "fast_travel_markarth", "fast_travel"),


                new Effect("Launch Player", "launch_player"),
                new Effect("Switch to First Person", "firstperson"),
                new Effect("Switch to Third Person", "thirdperson"),
                new Effect("Blood Splatter", "blood"),
                new Effect("Vibrate Controller", "vibrate"),
                new Effect("Reset Crime and Agression", "resetfactions"),
                new Effect("Send Player to Jail", "jail"),
                

                // Implemented but not working properly
                //new Effect("Fast Travel to Dawnstar", "fast_travel_dawnstar", "fast_travel"),
                //new Effect("Fast Travel to Winterhold", "fast_travel_winterhold", "fast_travel"),
                //new Effect("Fast Travel to Riften", "fast_travel_riften", "fast_travel"),
                //new Effect("Fast Travel to Falkreath", "fast_travel_falkreath", "fast_travel"),
                //new Effect("Fast Travel to High Hrothgar", "fast_travel_high_hrothgar", "fast_travel")

                #endregion
            };

        /*public override List<(string, Action)> MenuActions
        {
            get
            {
                List<(string, Action)> result = new List<(string, Action)>
                {
                    ("Clear Bound State", () =>
                    {
                        //EffectRequest request = new EffectRequest()
                    })
                };
                return result;
            }
        }*/

        protected override void StartEffect(EffectRequest request)
        {
            if (_win10.Effects.Any(e => string.Equals(e.Code, request.EffectID, StringComparison.InvariantCultureIgnoreCase)))
            {
                _win10_start_effect.Invoke(_win10, new object[] { request });
            }
            else { base.StartEffect(request); }
        }

        protected override bool StopEffect(EffectRequest request)
        {
            if (_win10.Effects.Any(e => string.Equals(e.Code, request.EffectID, StringComparison.InvariantCultureIgnoreCase)))
            {
                return (bool)_win10_stop_effect.Invoke(_win10, new object[] { request });
            }
            return base.StopEffect(request);
        }
    }
}
