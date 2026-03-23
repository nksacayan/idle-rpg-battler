extends RefCounted
class_name EquipmentProperties

# Using a collated enum for now since idk how to keep categories but let me
#  add these to gear in editor
enum ALL_PROPERTIES {
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

# Remember that enums are ints not their strings
enum RANGED_OR_MELEE_PROPERTIES {
	ONE_HANDED,
	TWO_HANDED,
	THROWN,
	WEIGHTED
}

enum MELEE_PROPERTIES {
	SHORT,
	STANDARD,
	LONG,
	FLEXIBLE,
	FIST
}

enum RANGED_PROPERTIES {
	TENSION,
	GUNPOWDER,
	LOADING
}

enum DAMAGE_TYPES {
	SLASHING,
	PIERCING,
	BLUNT
}

enum ARMORS {
	CLOTH,
	LIGHT,
	MEDIUM,
	HEAVY,
	SHIELD
}
