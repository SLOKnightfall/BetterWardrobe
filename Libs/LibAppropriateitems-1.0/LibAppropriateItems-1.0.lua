local lib, oldMinor = LibStub:NewLibrary("LibAppropriateItems-1.0", 1)
if not lib then return end

local _, playerclass = UnitClass("player")
local valid_classes

-- Can the player equip this at all?
function lib:CanEquip(item, class)
    return lib:IsAppropriate(item, class) ~= nil
end

-- Is the item "appropriate", per transmog rules -- i.e. is it equipable and of the primary armor-type
-- TODO: class-restricted items, offhand-restricted items?
function lib:IsAppropriate(item, class)
    class = class or playerclass
    local slot, _, itemclass, itemsubclass = select(4, GetItemInfoInstant(item))
    if slot == 'INVTYPE_CLOAK' then
        -- Cloaks are cloth, technically. But everyone can wear them.
        return true
    end
    if not (class and valid_classes[class] and itemclass and itemsubclass) then
        return
    end
    if valid_classes[class][itemclass] and valid_classes[class][itemclass][itemsubclass] then
        return valid_classes[class][itemclass][itemsubclass]
    end
    if valid_classes.ALL[itemclass] and valid_classes.ALL[itemclass][itemsubclass] then
        return valid_classes.ALL[itemclass][itemsubclass]
    end
end

-- Data

-- This is a three-value system:
--  true: can equip and is appropriate
--  false: can equip but isn't appropriate
--  nil: can't equip
valid_classes = {
    ALL = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Generic] = true,
            [Enum.ItemWeaponSubclass.Fishingpole] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Generic] = true, -- includes things like trinkets and rings
            [Enum.ItemArmorSubclass.Cosmetic] = true,
        },
    },
    DEATHKNIGHT = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
            [Enum.ItemWeaponSubclass.Sword2H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
            -- [Enum.ItemWeaponSubclass.Warglaive] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Plate] = true,
            [Enum.ItemArmorSubclass.Mail] = false,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    WARRIOR = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
            [Enum.ItemWeaponSubclass.Sword2H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            -- [Enum.ItemWeaponSubclass.Warglaive] = true,
            [Enum.ItemWeaponSubclass.Bows] = true,
            [Enum.ItemWeaponSubclass.Crossbow] = true,
            [Enum.ItemWeaponSubclass.Guns] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Shield] = true,
            [Enum.ItemArmorSubclass.Plate] = true,
            [Enum.ItemArmorSubclass.Mail] = false,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    PALADIN = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
            [Enum.ItemWeaponSubclass.Sword2H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Shield] = true,
            [Enum.ItemArmorSubclass.Plate] = true,
            [Enum.ItemArmorSubclass.Mail] = false,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    HUNTER = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Bows] = true,
            [Enum.ItemWeaponSubclass.Crossbow] = true,
            [Enum.ItemWeaponSubclass.Guns] = true,
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Sword2H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Mail] = true,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    SHAMAN = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Shield] = true,
            [Enum.ItemArmorSubclass.Mail] = true,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    DEMONHUNTER = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Warglaive] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Leather] = true,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    ROGUE = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Bows] = true,
            [Enum.ItemWeaponSubclass.Crossbow] = true,
            [Enum.ItemWeaponSubclass.Guns] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Leather] = true,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    MONK = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Leather] = true,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    DRUID = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Polearm] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
            [Enum.ItemWeaponSubclass.Bearclaw] = true,
            [Enum.ItemWeaponSubclass.Catclaw] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Leather] = true,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
    PRIEST = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Wand] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Cloth] = true,
        },
    },
    MAGE = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Wand] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Cloth] = true,
        },
    },
    WARLOCK = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Wand] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Cloth] = true,
        },
    },
    EVOKER = {
        [Enum.ItemClass.Weapon] = {
            [Enum.ItemWeaponSubclass.Dagger] = true,
            [Enum.ItemWeaponSubclass.Unarmed] = true,
            [Enum.ItemWeaponSubclass.Axe1H] = true,
            [Enum.ItemWeaponSubclass.Mace1H] = true,
            [Enum.ItemWeaponSubclass.Sword1H] = true,
            [Enum.ItemWeaponSubclass.Axe2H] = true,
            [Enum.ItemWeaponSubclass.Mace2H] = true,
            [Enum.ItemWeaponSubclass.Sword2H] = true,
            [Enum.ItemWeaponSubclass.Staff] = true,
        },
        [Enum.ItemClass.Armor] = {
            [Enum.ItemArmorSubclass.Mail] = true,
            [Enum.ItemArmorSubclass.Leather] = false,
            [Enum.ItemArmorSubclass.Cloth] = false,
        },
    },
}
