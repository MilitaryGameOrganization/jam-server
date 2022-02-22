#!/usr/bin/env bash

set -e

BLOCKS="log, brown_mushroom_block, red_mushroom_block, log2"

ITEMS="iron_axe, wooden_axe, stone_axe, diamond_axe, golden_axe"

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

add_block ic2:rubber_wood

# items

add_item ic2:{bronze_axe,chainsaw}
add_item thermalfoundation:tool.axe_{copper,tin,silver,lead,aluminum,nickel,platinum,steel,electrum,invar,bronze,constantan}
add_item immersiveengineering:axe_steel
add_item projectred-exploration:{ruby,sapphire,peridot}_axe
add_item appliedenergistics2:{certus,nether}_quartz_axe
add_item botania:{manasteel,elementium}axe
add_item galacticraftcore:steel_axe
add_item galacticraftplanets:{titanium,desh}_axe
add_item railcraft:tool_axe_steel

cat <<EOF > net.minecraft.scalar.cutall.mod_cutallsmp.cfg
# Configuration file

general {
    # Boolean: false
    B:DestroyUnder=false

    # Boolean: true
    B:DropGather=true

    # Integer: 0
    # 0:not decrease durability 1,2:decrease durability(1=until whole blocks 2=until break an item)
    I:Durability=0

    # String: "KEY_C"
    S:Key=KEY_C

    # Integer: 0
    I:Limiter=0

    # Boolean: true
    B:StartMode=true

    # String: "log, brown_mushroom_block, red_mushroom_block, log2"
    S:blockIds=$BLOCKS

    # String: "mod_CutAll"
    S:channelName=mod_CutAll

    # String: "iron_axe, wooden_axe, stone_axe, diamond_axe, golden_axe"
    S:itemIds=$ITEMS

    # String: ""
    S:leavesIds=

    # Integer: 3
    I:leavesRange=3

    # String: ""
    S:nondestructiveItemIDs=
}
EOF
