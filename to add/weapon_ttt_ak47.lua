---- Example TTT custom weapon
AddCSLuaFile()

if CLIENT then
   SWEP.PrintName = "AK47"
   SWEP.Slot      = 2 -- add 1 to get the slot number key

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   SWEP.Icon = "VGUI/ttt/ak47_icon_dark.png"
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.135
SWEP.Primary.Recoil      = 1.85
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 20
SWEP.Primary.Cone        = 0.024
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Sound       = Sound( "Weapon_AK47.Single" )
SWEP.HeadshotMultiplier = 1.9

SWEP.IronSightsPos = Vector( 6.05, -5, 4.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

SWEP.ViewModel  = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"


--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = false

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false

function SWEP:SetZoom(state)
   if CLIENT then return end
   if state then
      self.Owner:SetFOV(35, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self.Weapon:GetNextSecondaryFire() > CurTime() then return end

   bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom(bIronsights)
   end

   self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   self.Weapon:DefaultReload( ACT_VM_RELOAD );
   self:SetIronsights( false )
   self:SetZoom(false)
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end