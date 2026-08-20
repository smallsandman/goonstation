/datum/cult_sacrifice_zone
	var/list/mob/living/carbon/human/tracking_sacrifices
	var/obj/sacrificial_obj
	var/obj/decal/cultcircle/rune
	var/datum/cult/owner
	var/is_rune

	proc/try_connect(obj/new_object, datum/cult/new_cult)
		if (new_object == null || new_cult == null)
			return 0
		owner = new_cult
		sacrificial_obj = new_object
		is_rune = istype(new_object, /obj/decal/cultcircle)
		if (is_rune)
			rune = new_object
			rune.subscribe_to_cult(owner)

		return 1

	proc/process()
		sacrificial_obj.desc = "I looped through this"
		var/turf/centre_turf = get_step(get_turf(sacrificial_obj), NORTHEAST) // Object size will mean this might have to change (configured for circles)
		var/list/within_circle = range(2, centre_turf)
		for (var/mob/living/carbon/human/human in within_circle) // lack of as intentional
			if (prob(5))
				human.gib()
			else
				human.emote("scream")
				take_bleeding_damage(human, owner.leader, 3, D_SLASHING)

	New()
		. = ..()
		START_TRACKING // Tracked by processes

	disposing()
		..()
		STOP_TRACKING





/*
		for (var/obj/sacrifice_zone as anything in cult.sacrifice_zones)
				sacrifice_zone.desc = "I looped through this!"
				var/obj/decal/cultcircle/circle = null
				if (istype(sacrifice_zone, /obj/decal/cultcircle)) // Cult circles get extra pazazz
					circle = sacrifice_zone
					circle.icon_substate = "active"
					circle.update_circle_icon()

					var/list/within_circle = range(2, get_step(get_turf(circle), NORTHEAST))
					for (var/mob/living/carbon/human/human in within_circle)
						human.emote("scream")
						if (prob(5))
							human.gib()
*/
