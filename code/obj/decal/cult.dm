/obj/decal/cultcircle
	name = "cult circle"
	desc = "Some kind of malevolent rune left by a Cultist."
	icon = 'icons/obj/large/cultcircles96x96.dmi'
	icon_state = "default_inactive"
	anchored = ANCHORED
	layer = DECAL_LAYER
	//bounds = "-32,-32 to 32,32"
	bound_width = 96
	bound_height = 96
	pixel_x = -32
	pixel_y = -32
	bound_x = -32
	bound_y = -32

	var/datum/cult/owner = null
	var/style = "default"
	var/icon_substate = "inactive"

	/// Make the circle glow!
	proc/activate()
		icon_substate = "active"
		update_circle_icon()

	/// Stop the circle from glowing!
	proc/deactivate()
		icon_substate = "inactive"
		update_circle_icon()

	proc/update_circle_icon()
		icon_state = style + "_" + icon_substate
		return

	/// Sets this circle's style to the Cult's style
	proc/subscribe_to_cult(datum/cult/new_owner)
		owner = new_owner
		style = owner.style
		src.update_circle_icon()
