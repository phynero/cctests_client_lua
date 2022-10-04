local M = class("ylgy", cc.load("mvc").ViewBase)
package.loaded["app.views.yang_node"] = nil

local sharedScheduler = cc.Director:getInstance():getScheduler()
function M:onCallBack()
    require("app.MyApp"):create():run()
end

local sq = {
    {6,5},{7,6},
}

function M:onCreate()
    self:initDefData()
    self:initMap()
    self:initSlot()
    self:dealCards()
end

function M:initDefData()
    local layers = {}
    local col,row
    local num = 0
    -- for i = 1, 10, 1 do
    for i = 1, 8, 1 do
        -- row = sq[i%2 + 1][1]
        -- col = sq[i%2 + 1][2]
        row = 11 - i
        col = 10 - i
        layers[i] = layers[i] or {}
        for i1 = 1, row, 1 do
            layers[i][i1] = layers[i][i1] or {}
            for i2 = 1, col, 1 do
                layers[i][i1][i2] = 1
                num = num + 1
            end
        end
    end
    self.layers = layers
    self.def_cards = {}
    for i = 1, num, 1 do
        self.def_cards[i] = i%15 + 1
    end
end

function M:initMap()
    self.node_base = display.newNode()
    self.node_base:addTo(self)
    self.node_base:setPosition(display.center)
    
    local node_yang
    local yang_px, yang_py
    local total_x,total_y
    local card_idx = 1
    self.node_cards = {}
    for k1, v1 in pairs(self.layers) do
        self.node_cards[k1] = self.node_cards[k1] or {}
        for k2, v2 in pairs(v1) do
            self.node_cards[k1][k2] = self.node_cards[k1][k2] or {}
            for k3, v3 in pairs(v2) do
                node_yang = require("app.views.yang_node"):create()
                node_yang:onEnter({
                    alive = true,
                    card_id = 0,
                    p_layer = k1,
                    p_x = k2,
                    p_y = k3,
                    uniq_id = card_idx,
                    scene = self
                })
                self.node_base:addChild(node_yang)
                total_x = #v1
                total_y = #v2
                
                yang_px = (k2-total_x/2 - 0.5) * node_yang:getContentSize().width
                yang_py = (total_y/2-k3 + 2) * node_yang:getContentSize().height
                node_yang:setPosition(cc.p(yang_px,yang_py))

                self.node_cards[k1][k2][k3] = node_yang

                card_idx = card_idx + 1
            end
        end
    end
end

function M:initSlot()
    if self.cardInSlot then
        for i = 1, 7, 1 do
            self.cardInSlot[i].alive = false
            self.cardInSlot[i]:setVisible(false)
        end
        return
    end
    
    self.node_base_slot = display.newNode()
    self.node_base_slot:addTo(self)
    self.node_base_slot:setPosition(cc.p(display.width/2,display.height/2 - 220))

    local sp_slot = display.newSprite("yang/cao.png")
    sp_slot:setAnchorPoint(cc.p(0.5,0.5))
    sp_slot:addTo(self.node_base_slot)
    sp_slot:setScale(0.3)

    self.cardInSlot = {}
    for i = 1, 7, 1 do
        self.cardInSlot[i] = require("app.views.yang_node"):create()
        self.cardInSlot[i]:onEnter({
            alive = false,
            card_id = 0,
            p_x = 0,
            p_y = 0,
            uniq_id = 0,
            scene = self
        })
        self.cardInSlot[i]:addTo(self)
        self.cardInSlot[i]:setPosition(cc.p(display.width/2 + (i-4) * (self.cardInSlot[1]:getContentSize().width + 5),display.height/2 - 215))
        self.cardInSlot[i]:setVisible(false)
    end
end

function M:dealCards()
    math.randomseed(os.time())
    local def_cards = clone(self.def_cards)
    local rand_card = {}
    local cur_random_id
    for i = 1, #self.def_cards, 1 do
        cur_random_id = math.random(1,#def_cards)
        rand_card[i] = def_cards[cur_random_id]
        table.remove(def_cards,cur_random_id)
    end

    local card_idx = 1
    local node_lt,node_rt,node_lb,node_rb
    local j
    for i = 1, #self.node_cards, 1 do
        j = #self.node_cards - i + 1
        for k1, v1 in pairs(self.node_cards[j]) do
            for k2, v2 in pairs(v1) do
                v2.alive = true
                v2:setCardId(rand_card[card_idx])
                node_lt = self.node_cards[j + 1] and self.node_cards[j + 1][k1-1] and self.node_cards[j + 1][k1-1][k2-1]
                node_rt = self.node_cards[j + 1] and self.node_cards[j + 1][k1] and self.node_cards[j + 1][k1][k2-1]
                node_lb = self.node_cards[j + 1] and self.node_cards[j + 1][k1-1] and self.node_cards[j + 1][k1-1][k2]
                node_rb = self.node_cards[j + 1] and self.node_cards[j + 1][k1] and self.node_cards[j + 1][k1][k2]
                v2:updateTouchGray(node_lt,node_rt,node_lb,node_rb,j,k1,k2)
                card_idx = card_idx + 1
            end
        end
    end
end

function M:updateMap(node)
    local tar_node
    if self.node_cards[node.p_layer]
    and self.node_cards[node.p_layer][node.p_x]
    and self.node_cards[node.p_layer][node.p_x][node.p_y] then
        tar_node = self.node_cards[node.p_layer][node.p_x][node.p_y]
        tar_node:setKilled()
        if not self.node_cards[node.p_layer - 1] then
            return
        end
        local node_lt = self.node_cards[node.p_layer - 1][node.p_x] and self.node_cards[node.p_layer - 1][node.p_x][node.p_y]
        local node_lb = self.node_cards[node.p_layer - 1][node.p_x] and self.node_cards[node.p_layer - 1][node.p_x][node.p_y + 1]
        local node_rt = self.node_cards[node.p_layer - 1][node.p_x + 1] and self.node_cards[node.p_layer - 1][node.p_x + 1][node.p_y]
        local node_rb = self.node_cards[node.p_layer - 1][node.p_x + 1] and self.node_cards[node.p_layer - 1][node.p_x + 1][node.p_y + 1]

        if node_lt then
            node_lt:updateStatus()
        end
        if node_lb then
            node_lb:updateStatus()
        end
        if node_rt then
            node_rt:updateStatus()
        end
        if node_rb then
            node_rb:updateStatus()
        end
    end
end

function M:updateSlot(node)
    -- self.cardInSlot
    local flag = false
    for i = 1, #self.cardInSlot, 1 do
        if not self.cardInSlot[i].alive then
            self.cardInSlot[i]:setSlotAlive(node.card_id)
            self:moveSlotCard(self.cardInSlot,i)
            break
        end
    end
end

function M:moveSlotCard(nodes, index)
    self.flagMoveLock = true
    local prevPos = {
        x = nodes[index]:getPositionX(),
        y = nodes[index]:getPositionY()
    }
    nodes[index]:setPosition(cc.p(nodes[#nodes]:getPositionX(),nodes[#nodes]:getPositionY()))
    nodes[index]:runAction(cc.Sequence:create(
        cc.MoveTo:create(0.2,cc.p(prevPos.x,prevPos.y)),
        cc.CallFunc:create(function()
            local flag, cardid = self:checkSlotRemove()
            if flag then
                self:execSlotRemove(cardid)
            else
                if self.cardInSlot[#self.cardInSlot].alive then
                    self:TipsGameOver()
                end
                self.flagMoveLock = false
            end
        end)
    ))
end

function M:checkSlotRemove()
    local mapCardid = {}
    for k, v in pairs(self.cardInSlot) do
        if v.alive then
            if not mapCardid[v.card_id..""] then
                mapCardid[v.card_id..""] = 1
            else
                mapCardid[v.card_id..""] = mapCardid[v.card_id..""] + 1
            end
            dump(mapCardid,"mapCardid")
            if mapCardid[v.card_id..""] >= 3 then
                return true, v.card_id
            end
        end
    end
    return false
end

function M:execSlotRemove(cardid)
    local tmp
    local count_total = #self.cardInSlot

    for i = 1, count_total, 1 do
        if cardid == self.cardInSlot[count_total - i + 1].card_id then
            self.cardInSlot[count_total - i + 1]:setSlotKill()
            tmp = clone(self.cardInSlot[count_total - i + 1])
            table.remove(self.cardInSlot,count_total - i + 1)
            self.cardInSlot[#self.cardInSlot + 1] = tmp
        end
    end

    self.countRemove = 0
    self.countRemoveCur = 0
    for k, v in pairs(self.cardInSlot) do
        self.countRemove = self.countRemove + 1
        v:runAction(cc.Sequence:create(
            cc.MoveTo:create(0.2,cc.p(display.width/2 + (k-4) * (self.cardInSlot[1]:getContentSize().width + 5),v:getPositionY())),
            cc.CallFunc:create(function()
                self.countRemoveCur = self.countRemoveCur + 1
                if self.countRemoveCur == self.countRemove then
                    self.flagMoveLock = false
                end
            end)
        ))
    end
end

function M:onClicked(node)
    if self.flagMoveLock or self.gameOvreLock then
        return
    end
    self:updateMap(node)
    self:updateSlot(node)
end

function M:TipsGameOver()
    if self.gameOvreLock then
        return
    end
    self.gameOvreLock = true
    local LayerGameOverMask = cc.LayerColor:create(cc.c3b(100,100,100))
    LayerGameOverMask:setContentSize(cc.size(display.width,display.height))
    LayerGameOverMask:addTo(self)
    LayerGameOverMask:setOpacity(200)
    self.LayerGameOverMask = LayerGameOverMask

    local lb_tips = cc.Label:create()
    lb_tips:setSystemFontSize(50)
    lb_tips:setColor(cc.c3b(255,0,0))
    lb_tips:setString("GAME OVER")
    lb_tips:setAnchorPoint(cc.p(0.5,0.5))
    lb_tips:setPosition(cc.p(display.width/2,-100))
    lb_tips:addTo(LayerGameOverMask)
    lb_tips:setOpacity(0)
    lb_tips:runAction(cc.Sequence:create(cc.Spawn:create(
        cc.FadeIn:create(1),
        cc.MoveTo:create(1,cc.p(display.width/2,display.height/2+50))
        ),
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            self.gameOvreLock = false
        end)
    ))

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function()
        if self.gameOvreLock then
            return
        end
        self:initSlot()
        self:dealCards()
        LayerGameOverMask:removeFromParent(true)
        self.flagMoveLock = false
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = LayerGameOverMask:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, LayerGameOverMask)
    listener:setSwallowTouches(true)
end

return M