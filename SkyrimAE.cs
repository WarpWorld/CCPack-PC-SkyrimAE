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

        public SkyrimAE(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler)
        {
            _win10 = new Windows10(player, _ => true, _ => { });
            Effects.AddRange(_win10.Effects.Where(e => _win10_includes.Contains(e.Code)).Select(e =>
            {
                e.Parent = "miscellaneous";
                return e;
            }));
        }

        public override Game Game { get; } = new(123, "The Elder Scrolls V: Skyrim Special Edition", "SkyrimAE", "PC", ConnectorType.SimpleTCPConnector);

        public override EffectList Effects
        {
            get
            {
                List<Effect> effects = new List<Effect>
                {
                    #region Give Item (folder)

                    new Effect("Give Apples (5)", "give_apple") { Category = "Give Items" },
                    //new Effect("Spawn Cheese Wheel", "spawn_applecheese_wheel") { Category = "Give Items" },
                    new Effect("Give Health Potion", "give_health_potion") { Category = "Give Items" },
                    new Effect("Give Magika Potion", "give_magika_potion") { Category = "Give Items" },
                    new Effect("Give Lockpicks (5)", "give_lockpicks") { Category = "Give Items" },
                    new Effect("Give Arrows (5)", "give_arrows") { Category = "Give Items" },
                    new Effect("Give Baked Potatoes", "give_bpotatos") { Category = "Give Items" },
                    new Effect("Give Dragon Bone Weapon", "give_dragonweap") { Category = "Give Items" },
                    new Effect("Give Dragon Bone", "give_dragonbone") { Category = "Give Items" },
                    new Effect("Give Dragon Scales", "give_dragonscale") { Category = "Give Items" },
                    new Effect("Give Diamond", "give_diamond") { Category = "Give Items" },
                    new Effect("Give Iron Ingot", "give_iron") { Category = "Give Items" },
                    new Effect("Give Gold Ingot", "give_gold") { Category = "Give Items" },
                    new Effect("Give Potatoes (5)", "give_potatos") { Category = "Give Items" },
                    new Effect("Give Silver Ingot", "give_silver") { Category = "Give Items" },
                    new Effect("Give Steel Ingot", "give_steel") { Category = "Give Items" },
                    new Effect("Give Gold (10)", "give_gold_10") { Category = "Give Items" },
                    new Effect("Give Gold (100)", "give_gold_100") { Category = "Give Items" },
                    new Effect("Give Gold (1000)", "give_gold_1000") { Category = "Give Items" },
                    new Effect("Give Soul Gem (Petty)", "gem_petty") { Category = "Give Items" },
                    new Effect("Give Soul Gem (Lesser)", "gem_lesser") { Category = "Give Items" },
                    new Effect("Give Soul Gem (Common)", "gem_common") { Category = "Give Items" },
                    new Effect("Give Soul Gem (Greater)", "gem_greater") { Category = "Give Items" },
                    new Effect("Give Soul Gem (Grand)", "gem_grand") { Category = "Give Items" },
                    new Effect("Give Exploding Spider Scroll", "give_spider") { Category = "Give Items" },
                    new Effect("Give Dwemer's Curse", "dwemercurse") { Category = "Give Items" },
                    new Effect("Give Cheese-splosion", "cheeserain") { Category = "Give Items" },


                    new Effect("One Handed Up", "onehanded_up") { Category = "Skills" },
                    new Effect("One Handed Down", "onehanded_down") { Category = "Skills" },
                    new Effect("Two Handed Up", "twohanded_up") { Category = "Skills" },
                    new Effect("Two Handed Down", "twohanded_down") { Category = "Skills" },
                    new Effect("Archery Up", "marksman_up") { Category = "Skills" },
                    new Effect("Archery Down", "marksman_down") { Category = "Skills" },
                    new Effect("Block Up", "block_up") { Category = "Skills" },
                    new Effect("Block Down", "block_down") { Category = "Skills" },
                    new Effect("Smithing Up", "smithing_up") { Category = "Skills" },
                    new Effect("Smithing Down", "smithing_down") { Category = "Skills" },
                    new Effect("Heavy Armor Up", "heavyarmor_up") { Category = "Skills" },
                    new Effect("Heavy Armor Down", "heavyarmor_down") { Category = "Skills" },
                    new Effect("Light Armor Up", "lightarmor_up") { Category = "Skills" },
                    new Effect("Light Armor Down", "lightarmor_down") { Category = "Skills" },
                    new Effect("Pickpocket Up", "pickpocket_up") { Category = "Skills" },
                    new Effect("Pickpocket Down", "pickpocket_down") { Category = "Skills" },
                    new Effect("Lock Picking Up", "lockpicking_up") { Category = "Skills" },
                    new Effect("Lock Picking Down", "lockpicking_down") { Category = "Skills" },
                    new Effect("Sneak Up", "sneak_up") { Category = "Skills" },
                    new Effect("Sneak Down", "sneak_down") { Category = "Skills" },
                    new Effect("Alchemy Up", "alchemy_up") { Category = "Skills" },
                    new Effect("Alchemy Down", "alchemy_down") { Category = "Skills" },
                    new Effect("Speech Up", "speechcraft_up") { Category = "Skills" },
                    new Effect("Speech Down", "speechcraft_down") { Category = "Skills" },
                    new Effect("Alteration Up", "alteration_up") { Category = "Skills" },
                    new Effect("Alteration Down", "alteration_down") { Category = "Skills" },
                    new Effect("Conjuration Up", "conjuration_up") { Category = "Skills" },
                    new Effect("Conjuration Down", "conjuration_down") { Category = "Skills" },
                    new Effect("Destruction Up", "destruction_up") { Category = "Skills" },
                    new Effect("Destruction Down", "destruction_down") { Category = "Skills" },
                    new Effect("Illusion Up", "illusion_up") { Category = "Skills" },
                    new Effect("Illusion Down", "illusion_down") { Category = "Skills" },
                    new Effect("Restoration Up", "restoration_up") { Category = "Skills" },
                    new Effect("Restoration Down", "restoration_down") { Category = "Skills" },
                    new Effect("Enchanting Up", "enchanting_up") { Category = "Skills" },
                    new Effect("Enchanting Down", "enchanting_down") { Category = "Skills" },


                    #endregion

                    #region Take Away Item

                    //new Effect("Health Potion", "take_health_potion") { Category = "Take Items" },
                    //new Effect("Magika Potion", "take_magika_potion") { Category = "Take Items" },
                    new Effect("Take Lockpick", "take_lockpick") { Category = "Take Items" },
                    new Effect("Take Arrows", "take_arrows") { Category = "Take Items" },
                    new Effect("Take Gold (10)", "take_gold_10") { Category = "Take Items" },
                    new Effect("Take Gold (100)", "take_gold_100") { Category = "Take Items" },
                    new Effect("Take Gold (1000)", "take_gold_1000") { Category = "Take Items" },

                    #endregion

                    #region Spawn Enemy (folder)

                    //new Effect("Spawn Angry Chicken", "spawn_angry_chicken") { Category = "Enemies" },

                    new Effect("Dragon", "spawn_dragon") { Category = "Enemies" },
                    new Effect("Spawn Witch", "spawn_witch") { Category = "Enemies" },
                    new Effect("Spawn Draugr", "spawn_draugr") { Category = "Enemies" },
                    new Effect("Spawn Draugr Overlord", "spawnb_draugr_over") { Category = "Enemies" },
                    new Effect("Spawn Bandit", "spawn_bandit") { Category = "Enemies" },
                    new Effect("Spawn Bandit Party", "spawn_bandits") { Category = "Enemies" },
                    new Effect("Spawn Skeleton", "spawn_skeleton") { Category = "Enemies" },
                    new Effect("Spawn Flame Atronach", "spawnb_flameatronach") { Category = "Enemies" },
                    new Effect("Spawn Frost Atronach", "spawnb_frostatronach") { Category = "Enemies" },
                    new Effect("Spawn Storm Atronach", "spawnb_stormatronach") { Category = "Enemies" },
                    new Effect("Spawn Mammoth", "spawnb_mammoth") { Category = "Enemies" },
                    new Effect("Spawn Giant Spider", "spawnb_giantspider") { Category = "Enemies" },
                    new Effect("Spawn Spriggan", "spawnb_spriggan") { Category = "Enemies" },
                    new Effect("Spawn Mudcrabs", "spawnb_mudcrab") { Category = "Enemies" },
                    new Effect("Spawn Hargraven", "spawnb_hagraven") { Category = "Enemies" },
                    new Effect("Spawn Dwarven Centurion", "spawnb_dwarvencenturion") { Category = "Enemies" },
                    new Effect("Spawn Ice Wraith", "spawnb_ice_wraith") { Category = "Enemies" },
                    new Effect("Spawn Frost Troll", "spawnb_frost_troll") { Category = "Enemies" },


                    new Effect("Spawn Bear", "spawnb_bear") { Category = "Animals" },
                    new Effect("Spawn Chicken", "spawnb_chicken") { Category = "Animals" },
                    new Effect("Spawn Cow", "spawnb_cow") { Category = "Animals" },
                    new Effect("Spawn Deer", "spawnb_deer") { Category = "Animals" },
                    new Effect("Spawn Dog", "spawnb_dog") { Category = "Animals" },
                    new Effect("Spawn Goat", "spawnb_goat") { Category = "Animals" },
                    new Effect("Spawn Wolf", "spawnb_wolf") { Category = "Animals" },
                    new Effect("Spawn Horse", "spawn_horse") { Category = "Animals" },
                    #endregion

                    new Effect("Clear Bound State", "unbound"),

                    new Effect("Spawn Balgruuf the Greater", "spawnb_balgruuf") { Category = "NPCs" },
                    new Effect("Spawn Sheogorath", "spawnb_sheo") { Category = "NPCs" },
                    new Effect("Spawn Cicero", "spawnb_cicero") { Category = "NPCs" },
                    new Effect("Spawn Aela the Huntress", "spawnb_aela") { Category = "NPCs" },
                    new Effect("Spawn Jarl Ulfric Stormcloak", "spawnb_ulfric") { Category = "NPCs" },
                    new Effect("Spawn Serana", "spawnb_serana") { Category = "NPCs" },
                    new Effect("Spawn Mjoll the Lioness", "spawnb_mjoll") { Category = "NPCs" },
                    new Effect("Spawn M'aiq the Liar", "spawnb_maiq") { Category = "NPCs" },
                    new Effect("Spawn Legate Rikke", "spawnb_rikke") { Category = "NPCs" },


                    new Effect("Set Time to Midnight", "time_midnight") { Category = "Time" },
                    new Effect("Set Time to Morning", "time_morning") { Category = "Time" },
                    new Effect("Set Time to Noon", "time_noon") { Category = "Time" },
                    new Effect("Set Time to Evening", "time_evening") { Category = "Time" },


                    new Effect("Set Weather to Clear", "weather_clear") { Category = "Weather" },
                    new Effect("Set Weather to Rain", "weather_storm") { Category = "Weather" },
                    new Effect("Set Weather to Snow", "weather_snow") { Category = "Weather" },
                    new Effect("Set Weather to Red", "weather_red") { Category = "Weather" },
                    new Effect("Set Weather to Green", "weather_green") { Category = "Weather" },
                    new Effect("Set Weather to Blue", "weather_blue") { Category = "Weather" },

                    new Effect("Change Race to Argonian", "race_argonian") { Category = "Race" },
                    new Effect("Change Race to Breton", "race_breton") { Category = "Race" },
                    new Effect("Change Race to Dark Elf", "race_darkelf") { Category = "Race" },
                    new Effect("Change Race to High Elf", "race_highelf") { Category = "Race" },
                    new Effect("Change Race to Imperial", "race_imperial") { Category = "Race" },
                    new Effect("Change Race to Khajiit", "race_khajiit") { Category = "Race" },
                    new Effect("Change Race to Nord", "race_nord") { Category = "Race" },
                    new Effect("Change Race to Orc", "race_orc") { Category = "Race" },
                    new Effect("Change Race to Redguard", "race_redguard") { Category = "Race" },
                    new Effect("Change Race to Wood Elf", "race_woodelf") { Category = "Race" },


                    new Effect("Heal Player", "heal") { Category = "Health and Stamina" },
                    new Effect("Full Heal", "full_heal") { Category = "Health and Stamina" },
                    new Effect("Kill Player", "kill_player") { Category = "Health and Stamina" },
                    new Effect("Damage Player", "damage") { Category = "Health and Stamina" },
                    new Effect("10% Health", "to_ten_health") { Category = "Health and Stamina" },
                    new Effect("Infinite Stamina", "infinite_stamina") { Category = "Health and Stamina", Duration = TimeSpan.FromSeconds(30) },
                    new Effect("Deplete Stamina", "deplete_stamina") { Category = "Health and Stamina" },

                    new Effect("Good Random Spell", "good_spell") { Category = "Buffs and Debuffs" },
                    new Effect("Bad Random Spell", "bad_spell") { Category = "Buffs and Debuffs" },
                    new Effect("Increase Speed (30 seconds)", "increase_speed") { Category = "Buffs and Debuffs" },
                    //new Effect("Increase Jump (30 seconds)", "increase_jump") { Category = "Buffs and Debuffs" },
                    new Effect("Increased Damage (30 seconds)", "increase_damage") { Category = "Buffs and Debuffs" },
                    new Effect("Disable Crouch", "disable_crouch") { Category = "Buffs and Debuffs", Duration = TimeSpan.FromSeconds(60) },
                    new Effect("Destroy/Unlearn Left Hand", "destroy_left") { Category = "Buffs and Debuffs" },
                    new Effect("Destroy/Unlearn Right Hand", "destroy_right") { Category = "Buffs and Debuffs" },
                    new Effect("Decrease Speed (30 seconds)", "decrease_speed") { Category = "Buffs and Debuffs" },
                    //new Effect("Decrease Jump (30 seconds)", "decrease_jump") { Category = "Buffs and Debuffs" },
                    new Effect("Decrease Damage (30 seconds)", "decrease_damage") { Category = "Buffs and Debuffs" },
                    new Effect("Disable Fast Travel", "disable_fast_travel") { Category = "Buffs and Debuffs", Duration = TimeSpan.FromSeconds(30) },
                    new Effect("Freeze Player", "freeze") { Category = "Buffs and Debuffs" },
                    //new Effect("Lightning Strike", "lightning") { Category = "Buffs and Debuffs" },



                    new Effect("Use Scroll - Mayhem", "scroll_mayhem") { Category = "Scrolls" },
                    new Effect("Use Scroll - Hysteria", "scroll_hysteria") { Category = "Scrolls" },
                    new Effect("Use Scroll - Harmony", "scroll_harmony") { Category = "Scrolls" },
                    new Effect("Use Scroll - Water Breathing", "scroll_water") { Category = "Scrolls" },
                    new Effect("Use Scroll - Conjure Flame Atronach", "scroll_cflame") { Category = "Scrolls" },
                    new Effect("Use Scroll - Conjure Frost Atronach", "scroll_cfrost") { Category = "Scrolls" },
                    new Effect("Use Scroll - Conjure Storm Atronach", "scroll_cstorm") { Category = "Scrolls" },
                    new Effect("Use Scroll - Flame Thrall", "scroll_tflame") { Category = "Scrolls" },
                    new Effect("Use Scroll - Frost Thrall", "scroll_tfrost") { Category = "Scrolls" },
                    new Effect("Use Scroll - Storm Thrall", "scroll_tstorm") { Category = "Scrolls" },
                    new Effect("Use Scroll - Blizzard", "scroll_blizzard") { Category = "Scrolls" },
                    new Effect("Use Scroll - Invisibility", "scroll_invis") { Category = "Scrolls" },

                    #region Fast Travel

                    new Effect("Random Fast Travel", "random_fast_travel") { Category = "Fast Travel" },
                    new Effect("Fast Travel to Whiterun", "fast_travel_whiterun") { Category = "Fast Travel" },
                    new Effect("Fast Travel to Riverwood", "fast_travel_riverwood") { Category = "Fast Travel" },
                    new Effect("Fast Travel to Solitude", "fast_travel_solitude") { Category = "Fast Travel" },
                    new Effect("Fast Travel to Windhelm", "fast_travel_windhelm") { Category = "Fast Travel" },
                    new Effect("Fast Travel to Markarth", "fast_travel_markarth") { Category = "Fast Travel" },


                    new Effect("Launch Player", "launch_player"),
                    new Effect("Switch to First Person", "firstperson"),
                    new Effect("Switch to Third Person", "thirdperson"),
                    new Effect("Blood Splatter", "blood"),
                    new Effect("Vibrate Controller", "vibrate"),
                    new Effect("Reset Crime and Agression", "resetfactions"),
                    new Effect("Send Player to Jail", "jail"),


                    // Implemented but not working properly
                    //new Effect("Fast Travel to Dawnstar", "fast_travel_dawnstar") { Category = "Fast Travel" },
                    //new Effect("Fast Travel to Winterhold", "fast_travel_winterhold") { Category = "Fast Travel" },
                    //new Effect("Fast Travel to Riften", "fast_travel_riften") { Category = "Fast Travel" },
                    //new Effect("Fast Travel to Falkreath", "fast_travel_falkreath") { Category = "Fast Travel" },
                    //new Effect("Fast Travel to High Hrothgar", "fast_travel_high_hrothgar", "fast_travel")

                };
                #endregion
                return effects;
            }
        }

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
