local M = class("ylgy_node", cc.Node)

function M:onEnter(params)
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setContentSize(cc.size(140*0.3,145*0.3))

    local sp = display.newSprite("yang/card_bg.png")
    sp:setAnchorPoint(cc.p(0.5,0.5))
    sp:setScale(0.3)
    self:addChild(sp)
    sp:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
    self.sp_bg = sp
    ---------------
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    listener:setSwallowTouches(true)
    self.listener = listener

    -----------------
    -- self.cantouch = params.cantouch or false
    -- self.isgray = params.isgray or false
    self.alive = not not params.alive
    self.card_id = params.card_id or 0
    self.p_x = params.p_x or 0
    self.p_y = params.p_y or 0    
    self.p_layer = params.p_layer or 0    
    self.scene = params.scene
end

function M:setCardId(icon_id)
    if not self.icon then
        self.icon = display.newSprite()
        self.icon:setAnchorPoint(cc.p(0.5,0.5))
        self.icon:setScale(0.3)
        self:addChild(self.icon)
        self.icon:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
    end
    self.card_id = icon_id < 1 and 1 or icon_id
    self.icon:setTexture("yang/item_"..self.card_id..".png")
end

function M:setSlotAlive(card_id)
    self:setCardId(card_id)
    self.alive = true
    self.cantouch = false
    self:setVisible(true)
    self.listener:setSwallowTouches(false)
end
function M:setSlotKill()
    self:setCardId(0)
    self.alive = false
    self.cantouch = false
    self:setVisible(false)
    self.listener:setSwallowTouches(false)
end

function M:setKilled()
    self.alive = false
    self.cantouch = false
    self:setVisible(false)
    self.listener:setSwallowTouches(false)
end

function M:updateStatus()
    self:updateTouchGray(self.node_lt,self.node_rt,self.node_lb,self.node_rb)
end

function M:updateTouchGray(node_lt,node_rt,node_lb,node_rb)
    local flag1,flag2,flag3,flag4 = true,true,true,true
    if node_lt and node_lt.alive then
        flag1 = false
        self.node_lt = node_lt
    end
    if node_rt and node_rt.alive then
        flag2 = false
        self.node_rt = node_rt
    end
    if node_lb and node_lb.alive then
        flag3 = false
        self.node_lb = node_lb
    end
    if node_rb and node_rb.alive then
        flag4 = false
        self.node_rb = node_rb
    end

    if not self.alive then
        self.cantouch = false
    else
        self.cantouch = flag1 and flag2 and flag3 and flag4
    end
    self.isgray = not self.cantouch

    if self.isgray then
        self.icon:setColor(cc.c3b(100,100,100))
        self.sp_bg:setColor(cc.c3b(100,100,100))
    else
        self.icon:setColor(cc.c3b(255,255,255))
        self.sp_bg:setColor(cc.c3b(255,255,255))
    end
    self:setVisible(true)
end

function M:onTouchBegan(touch,event)
    local rect = event:getCurrentTarget():getBoundingBox()
    local location_target = event:getCurrentTarget():getParent():convertToNodeSpace(touch:getLocation())
    if cc.rectContainsPoint(rect, location_target) then
        if not self.cantouch then
            return false
        end
        return true
    end
    return false
end

function M:onTouchEnded(touch,event)
    self.scene:onClicked(self)
end

return M
