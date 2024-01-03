using System;
using System.Collections.Generic;
using CrowdControl.Common;
using JetBrains.Annotations;

namespace CrowdControl.Games.Packs.SkyrimAE;

[UsedImplicitly]
public class SkyrimAE : SimpleTCPPack
{
    public override string Host => "127.0.0.1";

    public override ushort Port => 59420;

    public override ISimpleTCPPack.MessageFormat MessageFormat => ISimpleTCPPack.MessageFormat.CrowdControlLegacy;

    public SkyrimAE(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler)
    {
        /*_win10 = new Windows10(player, _ => true, _ => { });
        Effects.AddRange(_win10.Effects.Where(e => _win10_includes.Contains(e.ID)).Select(e =>
        {
            e.Category = "Miscellaneous";
            return e;
        }));*/
    }

    public override Game Game { get; } = new("The Elder Scrolls V: Skyrim Special Edition", "SkyrimAE", "PC", ConnectorType.SimpleTCPConnector);

    public override EffectList Effects
    {
        get
        {
            List<Effect> effects = new List<Effect>
            {
                #region Give Item (folder)

                new("Give Apples (5)", "give_apple") { Category = "Give Items" },
                //new Effect("Spawn Cheese Wheel", "spawn_applecheese_wheel") { Category = "Give Items" },
                new("Give Health Potion", "give_health_potion") { Category = "Give Items" },
                new("Give Magika Potion", "give_magika_potion") { Category = "Give Items" },
                new("Give Lockpicks (5)", "give_lockpicks") { Category = "Give Items" },
                new("Give Arrows (5)", "give_arrows") { Category = "Give Items" },
                new("Give Baked Potatoes", "give_bpotatos") { Category = "Give Items" },
                new("Give Dragon Bone Weapon", "give_dragonweap") { Category = "Give Items" },
                new("Give Dragon Bone", "give_dragonbone") { Category = "Give Items" },
                new("Give Dragon Scales", "give_dragonscale") { Category = "Give Items" },
                new("Give Diamond", "give_diamond") { Category = "Give Items" },
                new("Give Iron Ingot", "give_iron") { Category = "Give Items" },
                new("Give Gold Ingot", "give_gold") { Category = "Give Items" },
                new("Give Potatoes (5)", "give_potatos") { Category = "Give Items" },
                new("Give Silver Ingot", "give_silver") { Category = "Give Items" },
                new("Give Steel Ingot", "give_steel") { Category = "Give Items" },
                new("Give Gold (10)", "give_gold_10") { Category = "Give Items" },
                new("Give Gold (100)", "give_gold_100") { Category = "Give Items" },
                new("Give Gold (1000)", "give_gold_1000") { Category = "Give Items" },
                new("Give Soul Gem (Petty)", "gem_petty") { Category = "Give Items" },
                new("Give Soul Gem (Lesser)", "gem_lesser") { Category = "Give Items" },
                new("Give Soul Gem (Common)", "gem_common") { Category = "Give Items" },
                new("Give Soul Gem (Greater)", "gem_greater") { Category = "Give Items" },
                new("Give Soul Gem (Grand)", "gem_grand") { Category = "Give Items" },
                new("Give Exploding Spider Scroll", "give_spider") { Category = "Give Items" },
                new("Give Dwemer's Curse", "dwemercurse") { Category = "Give Items" },
                new("Give Cheese-splosion", "cheeserain") { Category = "Give Items" },

                new("One Handed Up", "onehanded_up") { Category = "Skills" },
                new("One Handed Down", "onehanded_down") { Category = "Skills" },
                new("Two Handed Up", "twohanded_up") { Category = "Skills" },
                new("Two Handed Down", "twohanded_down") { Category = "Skills" },
                new("Archery Up", "marksman_up") { Category = "Skills" },
                new("Archery Down", "marksman_down") { Category = "Skills" },
                new("Block Up", "block_up") { Category = "Skills" },
                new("Block Down", "block_down") { Category = "Skills" },
                new("Smithing Up", "smithing_up") { Category = "Skills" },
                new("Smithing Down", "smithing_down") { Category = "Skills" },
                new("Heavy Armor Up", "heavyarmor_up") { Category = "Skills" },
                new("Heavy Armor Down", "heavyarmor_down") { Category = "Skills" },
                new("Light Armor Up", "lightarmor_up") { Category = "Skills" },
                new("Light Armor Down", "lightarmor_down") { Category = "Skills" },
                new("Pickpocket Up", "pickpocket_up") { Category = "Skills" },
                new("Pickpocket Down", "pickpocket_down") { Category = "Skills" },
                new("Lock Picking Up", "lockpicking_up") { Category = "Skills" },
                new("Lock Picking Down", "lockpicking_down") { Category = "Skills" },
                new("Sneak Up", "sneak_up") { Category = "Skills" },
                new("Sneak Down", "sneak_down") { Category = "Skills" },
                new("Alchemy Up", "alchemy_up") { Category = "Skills" },
                new("Alchemy Down", "alchemy_down") { Category = "Skills" },
                new("Speech Up", "speechcraft_up") { Category = "Skills" },
                new("Speech Down", "speechcraft_down") { Category = "Skills" },
                new("Alteration Up", "alteration_up") { Category = "Skills" },
                new("Alteration Down", "alteration_down") { Category = "Skills" },
                new("Conjuration Up", "conjuration_up") { Category = "Skills" },
                new("Conjuration Down", "conjuration_down") { Category = "Skills" },
                new("Destruction Up", "destruction_up") { Category = "Skills" },
                new("Destruction Down", "destruction_down") { Category = "Skills" },
                new("Illusion Up", "illusion_up") { Category = "Skills" },
                new("Illusion Down", "illusion_down") { Category = "Skills" },
                new("Restoration Up", "restoration_up") { Category = "Skills" },
                new("Restoration Down", "restoration_down") { Category = "Skills" },
                new("Enchanting Up", "enchanting_up") { Category = "Skills" },
                new("Enchanting Down", "enchanting_down") { Category = "Skills" },


                #endregion

                #region Take Away Item

                //new Effect("Health Potion", "take_health_potion") { Category = "Take Items" },
                //new Effect("Magika Potion", "take_magika_potion") { Category = "Take Items" },
                new("Take Lockpick", "take_lockpick") { Category = "Take Items" },
                new("Take Arrows", "take_arrows") { Category = "Take Items" },
                new("Take Gold (10)", "take_gold_10") { Category = "Take Items" },
                new("Take Gold (100)", "take_gold_100") { Category = "Take Items" },
                new("Take Gold (1000)", "take_gold_1000") { Category = "Take Items" },

                #endregion

                #region Spawn Enemy (folder)

                //new Effect("Spawn Angry Chicken", "spawn_angry_chicken") { Category = "Enemies" },

                new("Dragon", "spawn_dragon") { Category = "Enemies" },
                new("Spawn Witch", "spawn_witch") { Category = "Enemies" },
                new("Spawn Draugr", "spawn_draugr") { Category = "Enemies" },
                new("Spawn Draugr Overlord", "spawnb_draugr_over") { Category = "Enemies" },
                new("Spawn Bandit", "spawn_bandit") { Category = "Enemies" },
                new("Spawn Bandit Party", "spawn_bandits") { Category = "Enemies" },
                new("Spawn Skeleton", "spawn_skeleton") { Category = "Enemies" },
                new("Spawn Flame Atronach", "spawnb_flameatronach") { Category = "Enemies" },
                new("Spawn Frost Atronach", "spawnb_frostatronach") { Category = "Enemies" },
                new("Spawn Storm Atronach", "spawnb_stormatronach") { Category = "Enemies" },
                new("Spawn Mammoth", "spawnb_mammoth") { Category = "Enemies" },
                new("Spawn Giant Spider", "spawnb_giantspider") { Category = "Enemies" },
                new("Spawn Spriggan", "spawnb_spriggan") { Category = "Enemies" },
                new("Spawn Mudcrabs", "spawnb_mudcrab") { Category = "Enemies" },
                new("Spawn Hargraven", "spawnb_hagraven") { Category = "Enemies" },
                new("Spawn Dwarven Centurion", "spawnb_dwarvencenturion") { Category = "Enemies" },
                new("Spawn Ice Wraith", "spawnb_ice_wraith") { Category = "Enemies" },
                new("Spawn Frost Troll", "spawnb_frost_troll") { Category = "Enemies" },


                new("Spawn Bear", "spawnb_bear") { Category = "Animals" },
                new("Spawn Chicken", "spawnb_chicken") { Category = "Animals" },
                new("Spawn Cow", "spawnb_cow") { Category = "Animals" },
                new("Spawn Deer", "spawnb_deer") { Category = "Animals" },
                new("Spawn Dog", "spawnb_dog") { Category = "Animals" },
                new("Spawn Goat", "spawnb_goat") { Category = "Animals" },
                new("Spawn Wolf", "spawnb_wolf") { Category = "Animals" },
                new("Spawn Horse", "spawn_horse") { Category = "Animals" },
                #endregion

                new("Clear Bound State", "unbound"),

                new("Spawn Balgruuf the Greater", "spawnb_balgruuf") { Category = "NPCs" },
                new("Spawn Sheogorath", "spawnb_sheo") { Category = "NPCs" },
                new("Spawn Cicero", "spawnb_cicero") { Category = "NPCs" },
                new("Spawn Aela the Huntress", "spawnb_aela") { Category = "NPCs" },
                new("Spawn Jarl Ulfric Stormcloak", "spawnb_ulfric") { Category = "NPCs" },
                new("Spawn Serana", "spawnb_serana") { Category = "NPCs" },
                new("Spawn Mjoll the Lioness", "spawnb_mjoll") { Category = "NPCs" },
                new("Spawn M'aiq the Liar", "spawnb_maiq") { Category = "NPCs" },
                new("Spawn Legate Rikke", "spawnb_rikke") { Category = "NPCs" },

                new("Set Time to Midnight", "time_midnight") { Category = "Time" },
                new("Set Time to Morning", "time_morning") { Category = "Time" },
                new("Set Time to Noon", "time_noon") { Category = "Time" },
                new("Set Time to Evening", "time_evening") { Category = "Time" },

                new("Set Weather to Clear", "weather_clear") { Category = "Weather" },
                new("Set Weather to Rain", "weather_storm") { Category = "Weather" },
                new("Set Weather to Snow", "weather_snow") { Category = "Weather" },
                new("Set Weather to Red", "weather_red") { Category = "Weather" },
                new("Set Weather to Green", "weather_green") { Category = "Weather" },
                new("Set Weather to Blue", "weather_blue") { Category = "Weather" },

                new("Change Race to Argonian", "race_argonian") { Category = "Race" },
                new("Change Race to Breton", "race_breton") { Category = "Race" },
                new("Change Race to Dark Elf", "race_darkelf") { Category = "Race" },
                new("Change Race to High Elf", "race_highelf") { Category = "Race" },
                new("Change Race to Imperial", "race_imperial") { Category = "Race" },
                new("Change Race to Khajiit", "race_khajiit") { Category = "Race" },
                new("Change Race to Nord", "race_nord") { Category = "Race" },
                new("Change Race to Orc", "race_orc") { Category = "Race" },
                new("Change Race to Redguard", "race_redguard") { Category = "Race" },
                new("Change Race to Wood Elf", "race_woodelf") { Category = "Race" },

                new("Heal Player", "heal") { Category = "Health and Stamina" },
                new("Full Heal", "full_heal") { Category = "Health and Stamina" },
                new("Kill Player", "kill_player") { Category = "Health and Stamina" },
                new("Damage Player", "damage") { Category = "Health and Stamina" },
                new("10% Health", "to_ten_health") { Category = "Health and Stamina" },
                new("Infinite Stamina", "infinite_stamina") { Category = "Health and Stamina", Duration = 30 },
                new("Deplete Stamina", "deplete_stamina") { Category = "Health and Stamina" },

                new("Good Random Spell", "good_spell") { Category = "Buffs and Debuffs" },
                new("Bad Random Spell", "bad_spell") { Category = "Buffs and Debuffs" },
                new("Increase Speed", "increase_speed") { Category = "Buffs and Debuffs", Duration = 30 },
                //new Effect("Increase Jump", "increase_jump") { Category = "Buffs and Debuffs", Duration = 30  },
                new("Increased Damage", "increase_damage") { Category = "Buffs and Debuffs", Duration = 30  },
                new("Disable Crouch", "disable_crouch") { Category = "Buffs and Debuffs", Duration = 60 },
                new("Destroy/Unlearn Left Hand", "destroy_left") { Category = "Buffs and Debuffs" },
                new("Destroy/Unlearn Right Hand", "destroy_right") { Category = "Buffs and Debuffs" },
                new("Decrease Speed", "decrease_speed") { Category = "Buffs and Debuffs", Duration = 30  },
                //new Effect("Decrease Jump", "decrease_jump") { Category = "Buffs and Debuffs", Duration = 30  },
                new("Decrease Damage", "decrease_damage") { Category = "Buffs and Debuffs", Duration = 30  },
                new("Disable Fast Travel", "disable_fast_travel") { Category = "Buffs and Debuffs", Duration = 30 },
                new("Freeze Player", "freeze") { Category = "Buffs and Debuffs" },
                //new Effect("Lightning Strike", "lightning") { Category = "Buffs and Debuffs" },

                new("Use Scroll - Mayhem", "scroll_mayhem") { Category = "Scrolls" },
                new("Use Scroll - Hysteria", "scroll_hysteria") { Category = "Scrolls" },
                new("Use Scroll - Harmony", "scroll_harmony") { Category = "Scrolls" },
                new("Use Scroll - Water Breathing", "scroll_water") { Category = "Scrolls" },
                new("Use Scroll - Conjure Flame Atronach", "scroll_cflame") { Category = "Scrolls" },
                new("Use Scroll - Conjure Frost Atronach", "scroll_cfrost") { Category = "Scrolls" },
                new("Use Scroll - Conjure Storm Atronach", "scroll_cstorm") { Category = "Scrolls" },
                new("Use Scroll - Flame Thrall", "scroll_tflame") { Category = "Scrolls" },
                new("Use Scroll - Frost Thrall", "scroll_tfrost") { Category = "Scrolls" },
                new("Use Scroll - Storm Thrall", "scroll_tstorm") { Category = "Scrolls" },
                new("Use Scroll - Blizzard", "scroll_blizzard") { Category = "Scrolls" },
                new("Use Scroll - Invisibility", "scroll_invis") { Category = "Scrolls" },

                #region Fast Travel

                new("Random Fast Travel", "random_fast_travel") { Category = "Fast Travel" },
                new("Fast Travel to Whiterun", "fast_travel_whiterun") { Category = "Fast Travel" },
                new("Fast Travel to Riverwood", "fast_travel_riverwood") { Category = "Fast Travel" },
                new("Fast Travel to Solitude", "fast_travel_solitude") { Category = "Fast Travel" },
                new("Fast Travel to Windhelm", "fast_travel_windhelm") { Category = "Fast Travel" },
                new("Fast Travel to Markarth", "fast_travel_markarth") { Category = "Fast Travel" },


                new("Launch Player", "launch_player"),
                new("Switch to First Person", "firstperson"),
                new("Switch to Third Person", "thirdperson"),
                new("Blood Splatter", "blood"),
                new("Vibrate Controller", "vibrate"),
                new("Reset Crime and Agression", "resetfactions"),
                new("Send Player to Jail", "jail"),


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
}