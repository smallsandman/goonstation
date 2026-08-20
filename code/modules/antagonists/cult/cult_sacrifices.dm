/datum/potential_sacrifice_info
	var/mob/living/carbon/human/human
	var/human_name = "Somebody" // incase human becomes null, remember the name
	var/base_points = 500
	var/ever_living = FALSE
	var/ever_awake = FALSE
	proc/calc_points()
		. = base_points
		if (!ever_living)
			. -= 300
		else if (!ever_awake)
			. -= 100
		return .

/datum/cult_sacrifice_zone
	var/list/datum/potential_sacrifice_info/tracking_sacrifices
	var/obj/sacrificial_obj
	var/obj/decal/cultcircle/rune
	var/turf/centre_turf
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

	proc/sacrifice_human(datum/potential_sacrifice_info/sacrifice)
		if (!can_sacrifice_human(sacrifice.human))
			return
		var/points_awarded = sacrifice.calc_points()
		owner.award_points(points_awarded, TRUE, "[sacrifice.human_name] has been sacrificed for [points_awarded] points!")
		tracking_sacrifices.Remove(sacrifice)
		sacrificial_obj.visible_message(SPAN_ALERT("[sacrificial_obj] pulses and groans erratically, glowing with an evil aura!"))
		qdel(sacrifice)
		if (!sacrifice.human)
			return
		sacrifice.human.bioHolder.AddEffect("husk")
		sacrifice.human.bioHolder.mobAppearance.flavor_text = "A dessicated husk."
		sacrifice.human.disfigured = TRUE
		sacrifice.human.UpdateName()

	proc/can_sacrifice_human(mob/living/carbon/human/human, do_check_list)
		if (!human)
			return FALSE
		if (!ishuman(human)) // They've gotta be a human
			return FALSE
		if (human.get_ability_holder(/datum/abilityHolder/cult) != null) // Can't sacrifice your cultist friends
			return FALSE
		if (human.bioHolder.HasEffect("husk")) // They've already been juiced!
			return FALSE
		if (do_check_list == TRUE) // Check if they haven't already had info made on them (if you want to)
			for (var/datum/potential_sacrifice_info/sacrifice as anything in tracking_sacrifices)
				if (sacrifice.human == human)
					return FALSE
		return TRUE

	proc/check_human(datum/potential_sacrifice_info/sacrifice)
		// Check if they have died
		if (!sacrifice.human) // They no longer exist (counts as a death)
			sacrifice_human(sacrifice)
			return

		if (isdead(sacrifice.human)) // They have died, sacrifice
			sacrifice_human(sacrifice)
			return
		else
			sacrifice.ever_living = TRUE

		if (get_dist(centre_turf, get_turf(sacrifice.human)) > 2) // They left the circle
			tracking_sacrifices.Remove(sacrifice)
			qdel(sacrifice)
			return

		if (sacrifice.human.sleeping == FALSE && sacrifice.human.incrit == FALSE)
			sacrifice.ever_awake = TRUE



	proc/process()
		sacrificial_obj.desc = "I looped through this"
		centre_turf = get_step(get_turf(sacrificial_obj), NORTHEAST) // Object size will mean this might have to change (configured for circles)
		var/list/within_circle = range(2, centre_turf)
		// Find new humans that might turn up as cult meat soon
		for (var/mob/living/carbon/human/human in within_circle) // lack of as intentional
			if (src.can_sacrifice_human(human) == TRUE)
				var/datum/potential_sacrifice_info/new_sac = new()
				new_sac.human = human
				new_sac.human_name = human.name
				src.tracking_sacrifices.Add(new_sac) // Add this potential sacrifice

		// Run through all potential sacs
		for (var/datum/potential_sacrifice_info/potential_sac as anything in src.tracking_sacrifices)
			src.check_human(potential_sac)

	New()
		. = ..()
		tracking_sacrifices = list()
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
