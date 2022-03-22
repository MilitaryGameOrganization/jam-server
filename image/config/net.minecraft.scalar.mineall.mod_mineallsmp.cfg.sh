#!/usr/bin/env bash

set -e

BLOCKS="gold_ore, iron_ore, coal_ore, lapis_ore, obsidian, diamond_ore, redstone_ore, lit_redstone_ore, glowstone, emerald_ore, quartz_ore"
# removed from original: stone variants
#BLOCKS="$BLOCKS, stone:granite, stone:smooth_granite, stone:diorite, stone:smooth_diorite, stone:andesite, stone:smooth_andesite"

ITEMS="iron_pickaxe, wooden_pickaxe, stone_pickaxe, diamond_pickaxe, golden_pickaxe"

add_block() {
    for var in "$@"
    do
        BLOCKS="$BLOCKS, $var"
    done
}

add_item() {
    for var in "$@"
    do
        ITEMS="$ITEMS, $var"
    done
}

add_block thermalfoundation:{ore,ore_fluid}

# MineAll bug: it uses toString() instead of getName()
#add_block galacticraftcore:basic_block_core:{ore_copper_gc,ore_tin_gc,ore_aluminum_gc,ore_silicon}
#add_block galacticraftcore:basic_block_moon:{ore_copper_moon,ore_tin_moon,ore_cheese_moon,ore_sapphire_moon}
#add_block galacticraftplanets:mars:{ore_copper_mars,ore_tin_mars,ore_desh_mars,ore_iron_mars}
#add_block galacticraftplanets:asteroids_block:{ore_aluminum_asteroids,ore_ilmenite_asteroids,ore_iron_asteroids}
#add_block galacticraftplanets:venus:{venus_ore_aluminum,venus_ore_copper,venus_ore_galena,venus_ore_quartz,venus_ore_silicon,venus_ore_tin,venus_ore_solar}

add_block galacticraftcore:basic_block_core:{ORE_COPPER,ORE_TIN,ORE_ALUMINUM,ORE_SILICON}
add_block galacticraftcore:basic_block_moon:{ORE_COPPER_MOON,ORE_TIN_MOON,ORE_CHEESE_MOON,ORE_SAPPHIRE}
add_block galacticraftplanets:mars:{ORE_COPPER,ORE_TIN,ORE_DESH,ORE_IRON}
add_block galacticraftplanets:asteroids_block:{ORE_ALUMINUM,ORE_ILMENITE,ORE_IRON}
add_block galacticraftplanets:venus:{ORE_ALUMINUM,ORE_COPPER,ORE_GALENA,ORE_QUARTZ,ORE_SILICON,ORE_TIN,ORE_SOLAR_DUST}

add_block appliedenergistics2:{charged_quartz_ore,quartz_ore}
add_block immersiveengineering:ore
add_block mekanism:oreblock

add_block projectred-exploration:ore:{ruby_ore,sapphire_ore,peridot_ore,copper_ore,tin_ore,silver_ore,electrotine_ore}
add_block ic2:resource

# items

add_item ic2:{bronze_pickaxe,drill,diamond_drill,iridium_drill}
add_item thermalfoundation:tool.pickaxe_{copper,tin,silver,lead,aluminum,nickel,platinum,steel,electrum,invar,bronze,constantan}
add_item immersiveengineering:pickaxe_steel
add_item projectred-exploration:{ruby,sapphire,peridot}_pickaxe
add_item appliedenergistics2:{certus,nether}_quartz_pickaxe
add_item botania:{glass,manasteel,elementium}pick
add_item galacticraftcore:steel_pickaxe
add_item galacticraftplanets:{titanium,volcanic}_pickaxe
add_item galacticraftplanets:{desh_pick,desh_pick_slime}
add_item railcraft:tool_pickaxe_steel

cat <<EOF > net.minecraft.scalar.mineall.mod_mineallsmp.cfg
# Configuration file

general {
    # Boolean: false
    B:AutoCollect=false

    # Boolean: true
    B:DestroyUnder=true

    # Boolean: false
    B:DropGather=false

    # Integer: 0
    # 0:not decrease durability 1,2:decrease durability(1=until whole blocks 2=until break an item)
    I:Durability=0

    # String: "KEY_M"
    S:Key=KEY_M

    # Integer: 0
    I:Limiter=0

    # Boolean: true
    B:StartMode=true

    # String: "gold_ore, iron_ore, coal_ore, lapis_ore, obsidian, diamond_ore, redstone_ore, lit_redstone_ore, glowstone, emerald_ore, quartz_ore, stone:granite, stone:smooth_granite, stone:diorite, stone:smooth_diorite, stone:andesite, stone:smooth_andesite"
    S:blockIds=$BLOCKS

    # String: "mod_MineAll"
    S:channelName=mod_MineAll

    # String: "iron_pickaxe, wooden_pickaxe, stone_pickaxe, diamond_pickaxe, golden_pickaxe"
    S:itemIds=$ITEMS
}
EOF
