local M = class("blendfunc", cc.load("mvc").ViewBase)


local scheduler = cc.Director:getInstance():getScheduler()
function M:onCallBack()
    require("app.MyApp"):create():run()
end


function M:onCreate()
    local nodebase = display.newNode()
    nodebase:addTo(self)
    nodebase:setPosition(cc.p(display.width/2 - 300,display.height/2))
    local nodebase1 = display.newNode()
    nodebase1:addTo(self)
    nodebase1:setPosition(cc.p(display.width/2 + 300,display.height/2))
    display.newSprite("blendfunc/pic1.png"):addTo(nodebase)
    display.newSprite("blendfunc/pic0.png"):addTo(nodebase)

    local pic1 = display.newSprite("blendfunc/pic1.png")
    nodebase1:addChild(pic1)

    local pic0 = display.newSprite("blendfunc/pic0.png")
    nodebase1:addChild(pic0)

    local lb_tips1 = cc.Label:create()
    lb_tips1:setSystemFontSize(50)
    lb_tips1:setColor(cc.c3b(255,0,0))
    lb_tips1:setAnchorPoint(cc.p(1,0.5))
    lb_tips1:setPosition(cc.p(0,300))
    lb_tips1:addTo(nodebase1)
    local lb_tips2 = cc.Label:create()
    lb_tips2:setSystemFontSize(50)
    lb_tips2:setColor(cc.c3b(255,255,0))
    lb_tips2:setAnchorPoint(cc.p(1,0.5))
    lb_tips2:setPosition(cc.p(0,-300))
    lb_tips2:addTo(nodebase1)



    local types1 = {
        {ccb.BlendFactor.ZERO,"ccb.BlendFactor.ZERO"},
        {ccb.BlendFactor.ONE,"ccb.BlendFactor.ONE"},
        {ccb.BlendFactor.SRC_COLOR,"ccb.BlendFactor.SRC_COLOR"},
        {ccb.BlendFactor.ONE_MINUS_SRC_COLOR,"ccb.BlendFactor.ONE_MINUS_SRC_COLOR"},
        {ccb.BlendFactor.SRC_ALPHA,"ccb.BlendFactor.SRC_ALPHA"},
        {ccb.BlendFactor.ONE_MINUS_SRC_ALPHA,"ccb.BlendFactor.ONE_MINUS_SRC_ALPHA"},
        {ccb.BlendFactor.DST_COLOR,"ccb.BlendFactor.DST_COLOR"},
        {ccb.BlendFactor.ONE_MINUS_DST_COLOR,"ccb.BlendFactor.ONE_MINUS_DST_COLOR"},
        {ccb.BlendFactor.DST_ALPHA,"ccb.BlendFactor.DST_ALPHA"},
        {ccb.BlendFactor.ONE_MINUS_DST_ALPHA,"ccb.BlendFactor.ONE_MINUS_DST_ALPHA"},
        {ccb.BlendFactor.CONSTANT_ALPHA,"ccb.BlendFactor.CONSTANT_ALPHA"},
        {ccb.BlendFactor.SRC_ALPHA_SATURATE,"ccb.BlendFactor.SRC_ALPHA_SATURATE"},
        {ccb.BlendFactor.ONE_MINUS_CONSTANT_ALPHA,"ccb.BlendFactor.ONE_MINUS_CONSTANT_ALPHA"},
        {ccb.BlendFactor.BLEND_CLOLO,"ccb.BlendFactor.BLEND_CLOLOR"}
    }

    
    local types2 = {
        {ccb.BlendFactor.ZERO,"ccb.BlendFactor.ZERO"},
        {ccb.BlendFactor.ONE,"ccb.BlendFactor.ONE"},
        {ccb.BlendFactor.SRC_COLOR,"ccb.BlendFactor.SRC_COLOR"},
        {ccb.BlendFactor.ONE_MINUS_SRC_COLOR,"ccb.BlendFactor.ONE_MINUS_SRC_COLOR"},
        {ccb.BlendFactor.SRC_ALPHA,"ccb.BlendFactor.SRC_ALPHA"},
        {ccb.BlendFactor.ONE_MINUS_SRC_ALPHA,"ccb.BlendFactor.ONE_MINUS_SRC_ALPHA"},
        {ccb.BlendFactor.DST_COLOR,"ccb.BlendFactor.DST_COLOR"},
        {ccb.BlendFactor.ONE_MINUS_DST_COLOR,"ccb.BlendFactor.ONE_MINUS_DST_COLOR"},
        {ccb.BlendFactor.DST_ALPHA,"ccb.BlendFactor.DST_ALPHA"},
        {ccb.BlendFactor.ONE_MINUS_DST_ALPHA,"ccb.BlendFactor.ONE_MINUS_DST_ALPHA"},
        {ccb.BlendFactor.CONSTANT_ALPHA,"ccb.BlendFactor.CONSTANT_ALPHA"},
        {ccb.BlendFactor.SRC_ALPHA_SATURATE,"ccb.BlendFactor.SRC_ALPHA_SATURATE"},
        {ccb.BlendFactor.ONE_MINUS_CONSTANT_ALPHA,"ccb.BlendFactor.ONE_MINUS_CONSTANT_ALPHA"},
        {ccb.BlendFactor.BLEND_CLOLO,"ccb.BlendFactor.BLEND_CLOLOR"}
    }

    local idx1 = 1
    local idx2 = 1

    scheduler:scheduleScriptFunc(function()
        lb_tips1:setString(types1[idx1][2].."   "..idx1)
        lb_tips2:setString(types2[idx2][2].."   "..idx2)
        pic0:setBlendFunc(cc.blendFunc(types1[idx1][1], types2[idx2][1]))
        idx2 = idx2 + 1
        if idx2 > 14 then
            idx2 = 1
            idx1 = idx1 + 1
        end

        if idx1 > 14 then
            idx1 =  1
        end
        
    end, 1.0, false)    


    
    
end

return M





-- ZERO,
-- ONE,
-- SRC_COLOR,
-- ONE_MINUS_SRC_COLOR,
-- SRC_ALPHA,
-- ONE_MINUS_SRC_ALPHA,
-- DST_COLOR,
-- ONE_MINUS_DST_COLOR,
-- DST_ALPHA,
-- ONE_MINUS_DST_ALPHA,
-- CONSTANT_ALPHA,
-- SRC_ALPHA_SATURATE,
-- ONE_MINUS_CONSTANT_ALPHA,
-- BLEND_CLOLOR