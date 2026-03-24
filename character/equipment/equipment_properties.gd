extends RefCounted
class_name EquipmentProperties

# Using a collated enum for now since idk how to keep categories but let me
#  add these to gear in editor
enum ALL {
	ONE_HANDED,
	TWO_HANDED,
	THROWN,
	WEIGHTED,
	SHORT,
	STANDARD,
	LONG,
	FLEXIBLE,
	FIST,
	TENSION,
	GUNPOWDER,
	LOADING,
	SLASHING,
	PIERCING,
	BLUNT,
	CLOTH,
	LIGHT,
	MEDIUM,
	HEAVY,
	SHIELD,
}

# Using arrays to collect enum into groups
const WEAPON_PROPERTIES: Array[ALL] = [ALL.ONE_HANDED, ALL.TWO_HANDED, ALL.THROWN, ALL.WEIGHTED]

const MELEE_PROPERTIES: Array[ALL] = [ALL.SHORT, ALL.STANDARD, ALL.LONG, ALL.FLEXIBLE, ALL.FIST]

const RANGED_PROPERTIES: Array[ALL] = [ALL.TENSION, ALL.GUNPOWDER, ALL.LOADING]

const DAMAGE_TYPES: Array[ALL] = [ALL.SLASHING, ALL.PIERCING, ALL.BLUNT]

const ARMORS: Array[ALL] = [ALL.CLOTH, ALL.LIGHT, ALL.MEDIUM, ALL.HEAVY, ALL.SHIELD]
