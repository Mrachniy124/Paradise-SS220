/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/items.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	parent_stack = TRUE
	var/heal_brute = 0
	var/heal_burn = 0
	var/self_delay = 20
	var/unique_handling = FALSE //some things give a special prompt, do we want to bypass some checks in parent?
	var/stop_bleeding = 0
	var/healverb = "bandage"

/obj/item/stack/medical/proc/apply(mob/living/M, mob/user)
	if(get_amount() <= 0)
		if(is_cyborg)
			to_chat(user, "<span class='warning'>You don't have enough energy to dispense more [singular_name]\s!</span>")
		return TRUE

	if(!iscarbon(M) && !isanimal(M))
		to_chat(user, "<span class='danger'>[src] cannot be applied to [M]!</span>")
		return TRUE

	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='danger'>You don't have the dexterity to do this!</span>")
		return TRUE


	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_selected)

		if(!H.can_inject(user, TRUE))
			return TRUE

		if(!affecting)
			to_chat(user, "<span class='danger'>That limb is missing!</span>")
			return TRUE

		if(affecting.is_robotic())
			to_chat(user, "<span class='danger'>This can't be used on a robotic limb.</span>")
			return TRUE

		if(M == user && !unique_handling)
			user.visible_message("<span class='notice'>[user] starts to apply [src] on [H]...</span>")
			if(!do_mob(user, H, self_delay))
				return TRUE
		return

	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if(!(critter.healable))
			to_chat(user, "<span class='notice'>You cannot use [src] on [critter]!</span>")
			return
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[critter] is at full health.</span>")
			return
		else if(heal_brute < 1)
			to_chat(user, "<span class='notice'>[src] won't help [critter] at all.</span>")
			return

		critter.heal_organ_damage(heal_brute, heal_burn)
		user.visible_message("<span class='green'>[user] applies [src] on [critter].</span>", \
							"<span class='green'>You apply [src] on [critter].</span>")

		use(1)

	else
		M.heal_organ_damage(heal_brute, heal_burn)
		user.visible_message("<span class='green'>[user] applies [src] on [M].</span>", \
							"<span class='green'>You apply [src] on [M].</span>")
		use(1)

/obj/item/stack/medical/attack(mob/living/M, mob/user)
	return apply(M, user)

/obj/item/stack/medical/attack_self(mob/user)
	return apply(user, user)

/obj/item/stack/medical/proc/heal(mob/living/M, mob/user)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/affecting = H.get_organ(user.zone_selected)
	user.visible_message("<span class='green'>[user] [healverb]s the wounds on [H]'s [affecting.name].</span>", \
						"<span class='green'>You [healverb] the wounds on [H]'s [affecting.name].</span>" )

	var/rembrute = max(0, heal_brute - affecting.brute_dam) // Maxed with 0 since heal_damage let you pass in a negative value
	var/remburn = max(0, heal_burn - affecting.burn_dam) // And deduct it from their health (aka deal damage)
	var/nrembrute = rembrute
	var/nremburn = remburn
	affecting.heal_damage(heal_brute, heal_burn)
	var/list/achildlist
	if(!isnull(affecting.children))
		achildlist = affecting.children.Copy()
	var/parenthealed = FALSE
	while(rembrute + remburn > 0) // Don't bother if there's not enough leftover heal
		var/obj/item/organ/external/E
		if(LAZYLEN(achildlist))
			E = pick_n_take(achildlist) // Pick a random children and then remove it from the list
		else if(affecting.parent && !parenthealed) // If there's a parent and no healing attempt was made on it
			E = affecting.parent
			parenthealed = TRUE
		else
			break // If the organ have no child left and no parent / parent healed, break
		if(E.status & ORGAN_ROBOT || E.open) // Ignore robotic or open limb
			continue
		else if(!E.brute_dam && !E.burn_dam) // Ignore undamaged limb
			continue
		nrembrute = max(0, rembrute - E.brute_dam) // Deduct the healed damage from the remain
		nremburn = max(0, remburn - E.burn_dam)
		E.heal_damage(rembrute, remburn)
		rembrute = nrembrute
		remburn = nremburn
		user.visible_message("<span class='green'>[user] [healverb]s the wounds on [H]'s [E.name] with the remaining medication.</span>", \
							"<span class='green'>You [healverb] the wounds on [H]'s [E.name] with the remaining medication.</span>" )
	return affecting

//Bruise Packs//

/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon = 'icons/obj/stacks/miscellaneous.dmi'
	icon_state = "gauze"
	origin_tech = "biotech=2"
	max_amount = 12
	heal_brute = 10
	stop_bleeding = 1800
	dynamic_icon_state = TRUE

/obj/item/stack/medical/bruise_pack/attackby(obj/item/I, mob/user, params)
	if(I.sharp)
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two gauzes to do this!</span>")
			return
		new /obj/item/stack/sheet/cloth(user.drop_location())
		user.visible_message("[user] cuts [src] into pieces of cloth with [I].", \
					"<span class='notice'>You cut [src] into pieces of cloth with [I].</span>", \
					"<span class='italics'>You hear cutting.</span>")
		use(2)
	else
		return ..()

/obj/item/stack/medical/bruise_pack/apply(mob/living/M, mob/user)
	if(..())
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_selected)

		if(affecting.open == ORGAN_CLOSED)
			affecting.germ_level = 0

			if(stop_bleeding)
				if(!H.bleedsuppress) //so you can't stack bleed suppression
					H.suppress_bloodloss(stop_bleeding)

			heal(H, user)

			H.UpdateDamageIcon()
			use(1)
		else
			to_chat(user, "<span class='warning'>[affecting] is cut open, you'll need more than a bandage!</span>")

/obj/item/stack/medical/bruise_pack/improvised
	name = "improvised gauze"
	singular_name = "improvised gauze"
	desc = "A roll of cloth roughly cut from something that can stop bleeding, but does not heal wounds."
	heal_brute = 0
	stop_bleeding = 900

/obj/item/stack/medical/bruise_pack/advanced
	name = "advanced trauma kit"
	icon = 'icons/obj/items.dmi'
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	belt_icon = "traumakit"
	max_amount = 6
	heal_brute = 25
	stop_bleeding = 0
	dynamic_icon_state = FALSE

/obj/item/stack/medical/bruise_pack/advanced/cyborg
	energy_type = /datum/robot_energy_storage/medical/adv_brute_kit
	is_cyborg = TRUE

/obj/item/stack/medical/bruise_pack/advanced/cyborg/syndicate
	energy_type = /datum/robot_energy_storage/medical/adv_brute_kit/syndicate

//Ointment//


/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	icon = 'icons/obj/stacks/miscellaneous.dmi'
	singular_name = "ointment"
	icon_state = "ointment"
	origin_tech = "biotech=2"
	healverb = "salve"
	heal_burn = 10
	dynamic_icon_state = TRUE

/obj/item/stack/medical/ointment/apply(mob/living/M, mob/user)
	if(..())
		return 1

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_selected)

		if(affecting.open == ORGAN_CLOSED)
			affecting.germ_level = 0

			heal(H, user)

			H.UpdateDamageIcon()
			use(1)
		else
			to_chat(user, "<span class='warning'>[affecting] is cut open, you'll need more than some ointment!</span>")

/obj/item/stack/medical/ointment/heal(mob/living/M, mob/user)
	var/obj/item/organ/external/affecting = ..()
	if((affecting.status & ORGAN_BURNT) && !(affecting.status & ORGAN_SALVED))
		affecting.status |= ORGAN_SALVED
		addtimer(CALLBACK(affecting, TYPE_PROC_REF(/obj/item/organ/external, remove_ointment), heal_burn), 3 MINUTES)

/obj/item/organ/external/proc/remove_ointment(heal_amount) //de-ointmenterized D:
	status &= ~ORGAN_SALVED
	perma_injury = max(perma_injury - heal_amount, 0)
	if(owner)
		owner.updatehealth("permanent injury removal")
	if(!perma_injury)
		fix_burn_wound(update_health = FALSE)

/obj/item/stack/medical/ointment/advanced
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon = 'icons/obj/items.dmi'
	icon_state = "burnkit"
	belt_icon = "burnkit"
	heal_burn = 25
	dynamic_icon_state = FALSE

/obj/item/stack/medical/ointment/advanced/cyborg
	energy_type = /datum/robot_energy_storage/medical/adv_burn_kit
	is_cyborg = TRUE

/obj/item/stack/medical/ointment/advanced/cyborg/syndicate
	energy_type = /datum/robot_energy_storage/medical/adv_burn_kit/syndicate

//Medical Herbs//
/obj/item/stack/medical/bruise_pack/comfrey
	name = "\improper Comfrey leaf"
	singular_name = "Comfrey leaf"
	desc = "A soft leaf that is rubbed on bruises."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "tea_aspera_leaves"
	color = "#378C61"
	max_amount = 6
	stop_bleeding = 0
	heal_brute = 12
	drop_sound = 'sound/misc/moist_impact.ogg'
	mob_throw_hit_sound = 'sound/misc/moist_impact.ogg'
	hitsound = 'sound/misc/moist_impact.ogg'
	dynamic_icon_state = FALSE

/obj/item/stack/medical/bruise_pack/comfrey/heal(mob/living/M, mob/user)
	playsound(src, 'sound/misc/soggy.ogg', 30, TRUE)
	return ..()

/obj/item/stack/medical/ointment/aloe
	name = "\improper Aloe Vera leaf"
	singular_name = "Aloe Vera leaf"
	desc = "A cold leaf that is rubbed on burns."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "ambrosiavulgaris"
	color = "#4CC5C7"
	heal_burn = 12
	dynamic_icon_state = FALSE

// Splints
/obj/item/stack/medical/splint
	name = "medical splints"
	singular_name = "medical splint"
	icon_state = "splint"
	unique_handling = TRUE
	self_delay = 100
	var/other_delay = 0

/obj/item/stack/medical/splint/apply(mob/living/M, mob/user)
	if(..())
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_selected)
		var/limb = affecting.name

		if(!(affecting.limb_name in list("l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")))
			to_chat(user, "<span class='danger'>You can't apply a splint there!</span>")
			return TRUE

		if(affecting.status & ORGAN_SPLINTED)
			to_chat(user, "<span class='danger'>[H]'s [limb] is already splinted!</span>")
			if(alert(user, "Would you like to remove the splint from [H]'s [limb]?", "Splint removal.", "Yes", "No") == "Yes")
				affecting.status &= ~ORGAN_SPLINTED
				H.handle_splints()
				to_chat(user, "<span class='notice'>You remove the splint from [H]'s [limb].</span>")
			return TRUE

		if((M == user && self_delay > 0) || (M != user && other_delay > 0))
			user.visible_message("<span class='notice'>[user] starts to apply [src] to [H]'s [limb].</span>", \
									"<span class='notice'>You start to apply [src] to [H]'s [limb].</span>", \
									"<span class='notice'>You hear something being wrapped.</span>")

		if(M == user && !do_mob(user, H, self_delay))
			return TRUE
		else if(!do_mob(user, H, other_delay))
			return TRUE

		user.visible_message("<span class='notice'>[user] applies [src] to [H]'s [limb].</span>", \
								"<span class='notice'>You apply [src] to [H]'s [limb].</span>")

		affecting.status |= ORGAN_SPLINTED
		affecting.splinted_count = H.step_count
		H.handle_splints()
		use(1)

/obj/item/stack/medical/splint/cyborg
	energy_type = /datum/robot_energy_storage/medical/splint
	is_cyborg = TRUE

/obj/item/stack/medical/splint/cyborg/syndicate
	energy_type = /datum/robot_energy_storage/medical/splint/syndicate

/obj/item/stack/medical/splint/tribal
	name = "tribal splints"
	icon_state = "tribal_splint"
	other_delay = 50
