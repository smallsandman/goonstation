/obj/decal/cultcircle
	name = "cult circle"
	desc = "Some kind of malevolent rune left by a Cultist."
	icon = 'icons/obj/large/cultcircles96x96.dmi'
	icon_state = "default_inactive"
	anchored = ANCHORED
	layer = DECAL_LAYER
	bounds = "96,96"
	var/datum/cult/owner = null
	var/style = "default"
	var/icon_substate = "inactive"

	proc/update_circle_icon()
		icon_state = style + "_" + icon_substate
		return

	/// Adds this object to the list of Cult Sacrifice Spots, allowing it to sacrifice nearby humans in a 3x3
	proc/subscribe_to_cult(datum/cult/new_owner)
		owner = new_owner
		owner.sacrifice_zones.Add(src)
		style = owner.style
		src.update_circle_icon()

	disposing()
		var/index = owner.sacrifice_zones.Find()
		if (index != 0)
			owner.sacrifice_zones.Remove(index)
		else if (src in owner.sacrifice_zones)
			owner.sacrifice_zones.Remove(index)
		..()
