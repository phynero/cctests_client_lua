
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.notneedback = true

function MainScene:onCreate()
    local ListView = ccui.ListView:create()
    ListView:setDirection(5)
    ListView:setGravity(5)
    ListView:setBounceEnabled(true)
    ListView:setContentSize(cc.size(display.width,display.height))
    ListView:setAnchorPoint(cc.p(0,0))
    ListView:setPosition(cc.p(0,0))
    ListView:addTo(self)

    ListView:pushBackDefaultItem()

    local names = {
        "a_star",
        "jps",
        "yang",
    }

    for i = 1, #names, 1 do
        local item = ccui.Button:create("button2.png")
        item:setScale9Enabled(true)
        item:setContentSize(cc.size(display.width,50))
        local btnname = ccui.Text:create(names[i], "Arial", 20)
        btnname:setTextColor(cc.c4b(0, 255,   0, 255))
        item:setAnchorPoint(cc.p(0.5,0.5))
        item:setAnchorPoint(cc.p(0,0))
        item:addChild(btnname)
        btnname:setPosition(cc.p(item:getContentSize().width/2,item:getContentSize().height/2))
        ListView:pushBackCustomItem(item)
        item:addClickEventListener(function(sender)
            require("app.MyApp"):create():run(names[i])
        end)
    end
    


end

return MainScene
