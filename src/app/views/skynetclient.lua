local M = class("skynetclient", cc.load("mvc").ViewBase)
require("json")
local scheduler = cc.Director:getInstance():getScheduler()
function M:onCallBack()
    require("app.MyApp"):create():run()
end
function M:onEnter()
    self.heartTick = 0
    self.wsSendText = cc.WebSocket:create("ws://127.0.0.1:8001/client")
    self.wsSendText:registerScriptHandler(handler(self,self.wsSendTextOpen) ,cc.WEBSOCKET_OPEN)
    self.wsSendText:registerScriptHandler(handler(self,self.wsSendTextMessage) ,cc.WEBSOCKET_MESSAGE)
    self.wsSendText:registerScriptHandler(handler(self,self.wsSendTextClose) ,cc.WEBSOCKET_CLOSE)
    self.wsSendText:registerScriptHandler(handler(self,self.wsSendTextError) ,cc.WEBSOCKET_ERROR)

    
    -- self.m_schId = scheduler:scheduleScriptFunc(function()
    --     if self.wsSendText then
    --         self.heartTick = self.heartTick + 1
    --         local d = {
    --             pid = "c2s_login",
    --             pid = "handshack",
    --             status = 0,
    --             data = "心跳",
    --             heartTick = self.heartTick
    --         }
    --         local daaaa = json.encode(d)
    --         dump(daaaa)
    --         self.wsSendText:sendString(daaaa)
    --     else
    --         if self.m_schId then
    --             scheduler:unscheduleScriptEntry(self.m_schId)
    --         end
    --     end
    -- end,1,false)


    dump(ccui.Scale9Sprite)

    local width = 400
    local height = 40
    local back = ccui.Scale9Sprite:create("common_sp9_bg_2.png")
    self.editname = ccui.EditBox:create(cc.size(width,height),back)
    self:addChild(self.editname)
    self.editname:setPosition(cc.p(display.cx,display.cy + 100))
    self.editname:setPlaceHolder("click to input name")


    local width = 400
    local height = 40
    local back = ccui.Scale9Sprite:create("common_sp9_bg_2.png")
    self.editPasswd = ccui.EditBox:create(cc.size(width,height),back)
    self:addChild(self.editPasswd)
    self.editPasswd:setPosition(cc.p(display.cx,display.cy + 40))
    self.editPasswd:setPlaceHolder("click to input passwd")


    local btngo = ccui.Button:create("button2.png")
    btngo:addTo(self)
    btngo:setPosition(cc.p(display.cx,display.cy - 20))
    btngo:addClickEventListener(handler(self,self.goLogin))
    local textbtn = cc.Label:createWithTTF("Login","fonts/arial.ttf",30)
    textbtn:addTo(btngo)
    textbtn:setPosition(cc.p(btngo:getContentSize().width/2,btngo:getContentSize().height/2))
end

function M:wsSendTextOpen(params1,params2)
    print("ws--->>> wsSendTextOpen ")
    dump(params1)
    dump(params2)

end

function M:wsSendTextMessage(params1,params2)
    print("ws--->>> wsSendTextMessage ")
    dump(params1)
    dump(params2)

end

function M:wsSendTextClose(params1,params2)
    print("ws--->>> wsSendTextClose ")
    dump(params1)
    dump(params2)
    self.wsSendText = nil
end

function M:wsSendTextError(params1,params2)
    print("ws--->>> wsSendTextError ")
    dump(params1)
    dump(params2)
    self.wsSendText = nil

end

function M:goLogin(params1,params2)
    local name = string.trim(self.editname:getText())
    local pwd = string.trim(self.editPasswd:getText())
    dump(name)
    dump(pwd)
    local data = {
        pid = "c2s_login",
        token = "token",
        acc = name,
        sign = pwd
    }
    local pkg = json.encode(data)
    self.wsSendText:sendString(pkg)
end

function M:onExit()
    if self.m_schId then
        scheduler:unscheduleScriptEntry(self.m_schId)
    end
    if self.wsSendText then
        self.wsSendText:close()
    end
end
return M