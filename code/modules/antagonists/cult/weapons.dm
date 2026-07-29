/obj/item/cult_dagger
	name = "Ornate Dagger"
	icon = 'icons/obj/items/weapons.dmi'
	icon_state = "cult_dagger"
	flags = TABLEPASS | CONDUCT
	c_flags = ONBELT
	object_flags = NO_GHOSTCRITTER
	tool_flags = TOOL_CUTTING
	event_handler_flags = USE_GRAB_CHOKE | USE_FLUID_ENTER
	special_grab = /obj/item/grab
	hit_type = DAMAGE_CUT
	hitsound = 'sound/impact_sounds/Flesh_Cut_1.ogg'
	force = 8
	throwforce = 15
	w_class = W_CLASS_SMALL
	desc = "A fancy and ominous dagger, it cuts through flesh like butter."

	New()
		..()
		src.AddComponent(/datum/component/bloodflick)
		src.setItemSpecial(/datum/item_special/jab)

	attack(mob/target, mob/user, def_zone, is_special = FALSE, params = null)
		if(user?.bioHolder.HasEffect("clumsy") && prob(50))
			user.visible_message(SPAN_ALERT("<b>[user]</b> fumbles [src] and cuts [himself_or_herself(user)]."))
			random_brute_damage(user, 20)
			JOB_XP(user, "Clown", 1)
		if(is_special || !scalpel_surgery(target, user))
			return ..()

	custom_suicide = TRUE
	suicide(var/mob/user as mob)
		if(!src.user_can_suicide(user))
			return 0
		user.visible_message(SPAN_ALERT("<b>[user] slashes [his_or_her(user)] own throat with [src]!</b>"))
		blood_slash(user, 25)
		user.TakeDamage("head", 150, 0)
		return 1
