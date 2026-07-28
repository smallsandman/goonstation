ABSTRACT_TYPE(/obj/item/cultweapons)
ABSTRACT_TYPE(/obj/item/cultweapons/melee)
ABSTRACT_TYPE(/obj/item/cultweapons/melee/sharp)
ABSTRACT_TYPE(/obj/item/cultweapons/melee/blunt)
ABSTRACT_TYPE(/obj/item/cultweapons/ranged) //are we doing cult guns?

/obj/item/cultweapons
	name = "basescultweapon"
	desc = "If you can see this, call 1-800-CODER!"
	icon = 'icons/obj/items/weapons.dmi'
	object_flags = NO_GHOSTCRITTER // blanket ban on all cult items for ghost critters
	special_grab = /obj/item/grab
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	can_arcplate = FALSE

// Sharp melee weapons

/obj/item/cultweapons/melee/sharp
	name = "basecultknife"
	flags = TABLEPASS | CONDUCT
	c_flags = ONBELT
	tool_flags = TOOL_CUTTING
	event_handler_flags = USE_GRAB_CHOKE | USE_FLUID_ENTER
	hit_type = DAMAGE_CUT
	hitsound = 'sound/impact_sounds/Flesh_Cut_1.ogg'

	throw_impact(atom/A, datum/thrown_thing/thr)
		if(iscarbon(A))
			take_bleeding_damage(A, null, 5, DAMAGE_CUT)
			playsound(src, 'sound/impact_sounds/Flesh_Stab_3.ogg', 40, TRUE)

	New()
		..()
		src.AddComponent(/datum/component/bloodflick)

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

/obj/item/cultweapons/melee/sharp/cult_dagger
	name = "ornate dagger"
	desc = "A fancy and ominous dagger, it cuts through flesh like butter."
	icon_state = "cult_dagger"
	force = 8
	w_class = W_CLASS_SMALL

	New()
		..()
		src.setItemSpecial(/datum/item_special/jab)

/obj/item/cultweapons/melee/sharp/cult_sickle
	name = "fancy sickle"
	desc = "A scary-looking sickle, perfect for hooking into the flesh of potential sacrifices."
	icon_state = "fragile_sword" //placeholder
	force = 12
	special_grab = /obj/item/grab/garrote_grab //This isn't working for some reason
	w_class = W_CLASS_SMALL

// Blunt melee weapons

/obj/item/cultweapons/melee/blunt
	name = "basecultbat"
	hit_type = DAMAGE_BLUNT
	hitsound = 'sound/impact_sounds/Metal_Hit_1.ogg'
	force = 12
	throwforce = 7
	stamina_damage = 20
	w_class = W_CLASS_NORMAL

/obj/item/cultweapons/melee/blunt/cult_pole
	name = "decorated pole"
	desc = "A pole for holding up a flag. The flag is gone."
	icon = 'icons/obj/items/scrapweapons.dmi' //placeholder
	icon_state = "pole"
