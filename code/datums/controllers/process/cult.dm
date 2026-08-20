/datum/controller/process/check_sacrifices
	setup()
		name = "Cult_Circle_Sacrifice_Check"
		schedule_interval = CULT_SACRIFICE_CHECK_FREQUENCY

	doWork()
		for_by_tcl(cult, /datum/cult)
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
