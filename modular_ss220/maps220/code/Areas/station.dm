/* Station */
/area/station/security/checkpoint/south
	name = "\improper Escape Security Checkpoint"

/area/station/bridge/checkpoint
	name = "\improper Command Checkpoint"

/area/station/bridge/checkpoint/north
	name = "\improper North Command Checkpoint"

/area/station/bridge/checkpoint/south
	name = "\improper South Command Checkpoint"

/area/station/engineering/aitransit
	name = "\improper AI Satellite Transfer Point"
	icon_state = "engi"

/area/station/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engine_hallway"

/area/station/engineering/dronefabricator
	name = "\improper Engineering Drone Fabricator Room"
	icon_state = "engi"

/area/station/engineering/emergency
	name = "\improper Engineering Emergency Supplies"
	icon_state = "emergencystorage"

/area/station/engineering/supermatter_room
	name = "\improper Supermatter Room"
	icon_state = "engi"

/area/station/engineering/utility
	name = "\improper Engineering Utility Room"
	icon_state = "engimaint"

/area/station/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos"

/area/station/maintenance/dormitory_maintenance
	name = "\improper Dormitory Maintenance"
	icon_state = "smaint"

/area/station/maintenance/old_kitchen
	name = "\improper Old Kitchen"
	icon_state = "kitchen"

/area/station/maintenance/old_detective
	name = "\improper Old Detective Office"
	icon_state = "detective"

/area/station/maintenance/virology_maint
	name = "\improper Virology Maintenance Construction Area"
	icon_state = "smaint"

/area/station/hallway/secondary/exit/maintenance
	name = "\improper Abandoned Escape Shuttle Hallway"
	icon_state = "escape"

/* CentCom */
/area/centcom/ss220
	name = "\improper ЦК"
	icon_state = "centcom"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	nad_allowed = TRUE

/area/centcom/ss220/evac
	name = "\improper ЦК - Эвакуационный шаттл"
	icon_state = "centcom_evac"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom/ss220/park
	name = "\improper ЦК - Парк"
	icon_state ="centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom/ss220/bar
	name = "\improper ЦК - Бар"
	icon_state ="centcom"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/centcom/ss220/general
	name = "\improper ЦК - Зона персонала"
	icon_state ="centcom"

/area/centcom/ss220/supply
	name = "\improper ЦК - Доставка"
	icon_state ="centcom"

/area/centcom/ss220/admin1
	name = "\improper ЦК - Коридоры ЦК"
	icon_state ="centcom"

/area/centcom/ss220/admin2
	name = "\improper ЦК - Офисы"
	icon_state ="centcom"

/area/centcom/ss220/admin3
	name = "\improper ЦК - ОБР"
	icon_state ="centcom"

/area/centcom/ss220/jail
	name = "\improper ЦК - Тюрьма"
	icon_state ="centcom"

/* Syndicate Base - Mothership */
/area/syndicate_mothership
	name = "\improper Syndicate Forward Base"
	icon = 'modular_ss220/maps220/icons/areas.dmi'
	icon_state = "syndie-ship"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	nad_allowed = TRUE
	ambientsounds = HIGHSEC_SOUNDS

/area/syndicate_mothership/outside
	name = "\improper Syndicate Controlled Territory"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	icon_state = "syndie-outside"

/area/syndicate_mothership/control
	name = "\improper Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\improper Syndicate Elite Squad"
	icon_state = "syndie-elite"

/area/syndicate_mothership/infteam
	name = "\improper Syndicate Infiltrators"
	icon_state = "syndie-infiltrator"

/area/syndicate_mothership/jail
	name = "\improper Syndicate Jail"
	icon_state = "syndie-jail"

/area/syndicate_mothership/cargo
	name = "\improper Syndicate Cargo"
	icon_state = "syndie-cargo"
