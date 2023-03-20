local M = class("physic", cc.load("mvc").ViewBase)
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.5, 1, 0)
local STATIC_COLOR = cc.c4f(1.0, 0.0, 0.0, 1.0)
local DRAG_BODYS_TAG = 0x80
local sizeWall = cc.size(display.width-50,display.height-50)

local function makeBall(point, radius)
    local material = MATERIAL_DEFAULT
    local ball = cc.Sprite:create("ball.png")
    ball:setScale(0.13 * radius)

    local body = cc.PhysicsBody:createCircle(ball:getContentSize().width / 2, material)
    ball:setPhysicsBody(body)
    ball:setPosition(point)

    return ball
end

local scheduler = cc.Director:getInstance():getScheduler()
function M:onCallBack()
    require("app.MyApp"):create():run()
end

function M:onCreate()
    local root = cc.Node:create()
    root:setTag(10)
    self:addChild(root)
    root:setPosition(display.center)
    local wall = cc.Node:create()
    wall:setAnchorPoint(cc.p(0.5,0.5))
    wall:setContentSize(sizeWall)
    root:addChild(wall)
    local layerC = cc.LayerColor:create(cc.c4b(255,0,0,100))
    wall:addChild(layerC)
    layerC:setContentSize(wall:getContentSize())

    local scene = self:getScene()
    local scene2 = wall:getScene()
    self.wall = wall
    self.m_schId = scheduler:scheduleScriptFunc(function()
        if self.m_schId then
            scheduler:unscheduleScriptEntry(self.m_schId)
        end
        local scene = self.wall:getScene()
        scene:initWithPhysics()
        local world = cc.Director:getInstance():getRunningScene():getPhysicsWorld()
        world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
        world:setGravity(cc.p(0,0))
        wall:setPhysicsBody(cc.PhysicsBody:createEdgeBox(sizeWall,MATERIAL_DEFAULT))


        local ball = makeBall(cc.p(0,0), 10)
        local ballPhysicsBody = ball:getPhysicsBody()
        ballPhysicsBody:setVelocity(cc.p(500, -400))
        ballPhysicsBody:setTag(DRAG_BODYS_TAG)
        ballPhysicsBody:setMass(1.0)
        ballPhysicsBody:setContactTestBitmask(0xFFFFFFFF)
        root:addChild(ball)
    end,0.1,false)

    

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
    listener:registerScriptHandler(function()
        
        local ball = makeBall(cc.p(0,0), 10)
        local ballPhysicsBody = ball:getPhysicsBody()

        -- math.newrandomseed()
        local rX = math.random(-500,500)
        local rY = math.random(-500,500)
        ballPhysicsBody:setVelocity(cc.p(rX, rY))
        ballPhysicsBody:setTag(DRAG_BODYS_TAG)
        ballPhysicsBody:setMass(1.0)
        ballPhysicsBody:setContactTestBitmask(0xFFFFFFFF)
        root:addChild(ball)
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = wall:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,wall)





end

return M