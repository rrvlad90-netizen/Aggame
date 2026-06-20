local Assets = require("src.assets")
local AnimationSet = require("src.animation_set")
local Collision = require("src.collision")
local Render = require("src.render")

local Checkpoint = {}
Checkpoint.__index = Checkpoint

function Checkpoint:new(config)
    config = config or {}

    local checkpoint = setmetatable({}, Checkpoint)

    checkpoint.id = config.id or "checkpoint"
    checkpoint.entityType = "checkpoint"
    checkpoint.targetGroup = "checkpoint"

    checkpoint.x = config.x or 0
    checkpoint.y = config.y or 0

    checkpoint.respawnX = config.respawnX
        or config.respawn_x

    checkpoint.respawnY = config.respawnY
        or config.respawn_y

    checkpoint.facing = config.facing or 1

    checkpoint.canvas = config.canvas or {
        width = config.w or config.width or 48,
        height = config.h or config.height or 80
    }

    checkpoint.offset = config.offset or {
        x = checkpoint.canvas.width / 2,
        y = checkpoint.canvas.height
    }

    checkpoint.bbox = config.bbox or {
        x = 0,
        y = 0,
        w = checkpoint.canvas.width,
        h = checkpoint.canvas.height
    }

    checkpoint.image = config.image

    checkpoint.alpha = config.alpha or 1
    checkpoint.color = config.color or {0.2, 0.8, 1.0}

    checkpoint.layer = config.layer or "middle"

    checkpoint.activated = config.activated == true

    checkpoint.idleAnimation = config.idleAnimation
        or config.idle_animation
        or "idle"

    checkpoint.activeAnimation = config.activeAnimation
        or config.active_animation
        or "active"

    checkpoint.activateSound = config.activateSound
        or config.activate_sound

    checkpoint.animationSet = nil

    if config.animations then
        checkpoint.animationSet = AnimationSet:new({
            default = checkpoint.activated
                and checkpoint.activeAnimation
                or checkpoint.idleAnimation,
            animations = config.animations
        })

        if checkpoint.activated then
            checkpoint.animationSet:set(checkpoint.activeAnimation, true)
        else
            checkpoint.animationSet:set(checkpoint.idleAnimation, true)
        end
    end

    return checkpoint
end

function Checkpoint:getHitbox()
    return Collision.localBoxToWorld(self, self.bbox)
end

function Checkpoint:getRespawnPosition()
    return {
        x = self.respawnX or self.x,
        y = self.respawnY or self.y,
        facing = self.facing or 1
    }
end

function Checkpoint:activate()
    if self.activated then
        return false
    end

    self.activated = true

    if self.animationSet and self.animationSet:has(self.activeAnimation) then
        self.animationSet:set(self.activeAnimation, true)
    end

    if self.activateSound then
        Assets.playSound(self.activateSound)
    end

    return true
end

function Checkpoint:deactivate()
    if not self.activated then
        return false
    end

    self.activated = false

    if self.animationSet and self.animationSet:has(self.idleAnimation) then
        self.animationSet:set(self.idleAnimation, true)
    end

    return true
end

function Checkpoint:update(dt)
    if self.animationSet then
        self.animationSet:update(dt)
    end
end

function Checkpoint:draw(camera)
    Render.drawEntity(self, camera)
end

return Checkpoint