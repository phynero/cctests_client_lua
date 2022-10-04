
local M = class("A_Star", cc.load("mvc").ViewBase)
local sharedScheduler = cc.Director:getInstance():getScheduler()
function M:onCreate()
    -- init棋盘
    local num_w = display.width/50
    local num_h = display.height/50

	math.newrandomseed()
    local maps = {
        {1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
        {1,2,2,2,1,1,2,2,2,2,2,1,1,1,1,1,1,1,1},
        {1,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
        {1,2,2,2,1,1,2,2,2,2,2,1,1,1,1,1,1,1,1},
        {1,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
        {1,2,2,2,1,1,2,2,2,2,2,1,1,1,1,1,1,1,1},
        {1,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
        {1,2,2,2,1,1,2,2,2,2,2,1,1,1,1,1,1,1,1},
        {1,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
        {1,1,1,1,1,1,2,2,2,2,2,1,1,1,1,1,1,1,1},
        {1,2,1,2,1,2,2,2,2,2,2,2,1,2,1,2,1,2,1},
    }
    
    local blocks = {}
    self.blocks = {}
    local sp_block
    for i = 1, num_h, 1 do
        blocks[i] = blocks[i] or {}
        self.blocks[i] = self.blocks[i] or {}
        for j = 1, num_w, 1 do
            -- blocks[i][j] = math.random(1,2)
            blocks[i][j] = maps[i][j]
            sp_block = display.newSprite("block"..blocks[i][j]..".jpg")
            sp_block:addTo(self)
            sp_block:setAnchorPoint(cc.p(0,1))
            sp_block:setPosition(cc.p((j-1)*50,display.height - (i-1)*50))
            sp_block:setScale(50/280)

            local t1 = ccui.Text:create("g", "Arial", 60)
            local t2 = ccui.Text:create("h", "Arial", 60)
            local t3 = ccui.Text:create("f", "Arial", 70)
            t1:setColor(cc.c3b(255,0,0))
            t2:setColor(cc.c3b(255,0,255))
            t3:setColor(cc.c3b(255,255,0))
            t1:setAnchorPoint(cc.p(0,1))
            t2:setAnchorPoint(cc.p(1,0))
            sp_block:addChild(t1,1,1)
            sp_block:addChild(t2,2,2)
            sp_block:addChild(t3,3,3)
            t1:setPosition(cc.p(0,255))
            t2:setPosition(cc.p(255,50))
            t3:setPosition(cc.p(127,157))

            local t4 = ccui.Text:create("x:"..j.." y:"..i, "Arial", 70)
            t4:setColor(cc.c3b(0,0,0))
            t4:setAnchorPoint(cc.p(0,0))
            sp_block:addChild(t4,4,4)
            t4:setPosition(cc.p(0,0))
            t1:setVisible(blocks[i][j] == 1)
            t2:setVisible(blocks[i][j] == 1)
            t3:setVisible(blocks[i][j] == 1)
            t4:setVisible(blocks[i][j] == 1)
            self.blocks[i][j] = sp_block
        end 
    end
    


    local b_idx
    for k, v in pairs(blocks) do
        b_idx = ""
        for k1, v1 in pairs(v) do
            b_idx = b_idx..v1 .."  "
        end
        print(b_idx)
    end
    self.world = blocks

    local btngo = ccui.Button:create("back.png")
    btngo:addTo(self)
    btngo:setAnchorPoint(cc.p(0.5,1))
    btngo:setPosition(cc.p(display.width/2,display.height))
    btngo:addClickEventListener(function(sender)
        self:test()
    end)
    btngo = ccui.Button:create("back.png")
    btngo:addTo(self)
    btngo:setAnchorPoint(cc.p(0.5,1))
    btngo:setPosition(cc.p(display.width/2+300,display.height))
    btngo:addClickEventListener(function(sender)
        sharedScheduler:unscheduleScriptEntry(self.m_schId)
    end)
end

function M:test()
    -- self.world = {}    -- 地图
    self.open = {}    -- 开放列表
    self.closed = {}    -- 闭合列表
    -- self.path = {}    -- 路径列表
    self.closedIndex = 0 -- 闭合列表的下标
    self.targetX = 0 -- 目标节点坐标x
    self.targetY = 0 -- 目标节点坐标y
    self.maxCheckTime = 1000 -- 最大检索步数


    self:placeTarget({1,1},{19,11})
    
end

function M:placeTarget(start_p,end_p)
    local p_start = {   x = start_p[1], 
                        y = start_p[2],
                        g = 0,
                        f = 0,
                        h = 0,
    }

    p_start.h = math.abs(p_start.x - end_p[1]) + math.abs(p_start.y - end_p[2])

    local p_end = {x = end_p[1], y = end_p[2]}

    local openList,closeList = {},{}

    local function getminG(tb)
        local ming,minidx
        for k, v in pairs(tb) do
            if (not ming) or (ming > (v.g + v.h)) then
                ming = v.g + v.h
                minidx = k
            end
        end
        return minidx
    end

    local math_list, minidx
    local cur_x,cur_y
    openList = {
        [start_p[1].."_"..start_p[2]] = p_start
    }
    local path = {}

    local c_base = 100

    self.m_schId = sharedScheduler:scheduleScriptFunc(function()
        print "搜索中......"
        -- dump(openList)
        if table.nums(openList) == 0 then
            sharedScheduler:unscheduleScriptEntry(self.m_schId)
            return print "搜索失败"
        end
        minidx = getminG(openList)
        cur_x,cur_y = openList[minidx].x,openList[minidx].y
        closeList[cur_x.."_"..cur_y] = clone(openList[minidx])
        -- path[#path + 1] = cur_x.."_"..cur_y
        -- c_base = c_base + 10
        -- c_base = c_base >= 255 and 255 or c_base
        self.blocks[tonumber(cur_y)][tonumber(cur_x)]:setColor(cc.c3b(c_base,c_base,c_base))
        self.blocks[tonumber(cur_y)][tonumber(cur_x)]:getChildByTag(1):setString("g:"..openList[minidx].g)
        self.blocks[tonumber(cur_y)][tonumber(cur_x)]:getChildByTag(2):setString("h:"..openList[minidx].h)
        self.blocks[tonumber(cur_y)][tonumber(cur_x)]:getChildByTag(3):setString("f:"..(openList[minidx].g + openList[minidx].h))
        openList[minidx] = nil

        math_list = {
            {cur_x + 1,cur_y},
            {cur_x - 1,cur_y},
            {cur_x,cur_y + 1},
            {cur_x,cur_y - 1},
        }
        print("------------------------------------------------------")
        print("目标:  ",p_end.x,p_end.y)
        print("当前:  ",cur_x,cur_y)
        for k, v in pairs(math_list) do
            if not closeList[v[1].."_"..v[2]] and
            v[1] >= 1 and v[1] <= 19 and v[2] >= 1 and v[2] <= 12
            and self.world[v[2]][v[1]] == 1
             then
                openList[v[1].."_"..v[2]] = {
                    x = v[1],
                    y = v[2],
                    g = math.abs(p_start.x - v[1]) + math.abs(p_start.y - v[2]),
                    h = math.abs(v[1] - end_p[1]) + math.abs(v[2] - end_p[2]),
                    p = cur_x.."_"..cur_y
                }
            end
        end
        self.openList = openList
        self.closeList = closeList
        -- self.path = path
        -- self.list_content:setNumItems(64)
        if cur_x == p_end.x and cur_y == p_end.y then
            sharedScheduler:unscheduleScriptEntry(self.m_schId)
            self:showPath(cur_x.."_"..cur_y)
            return print "寻路结束"
        end
    end,0.1,false)
end

function M:onCallBack()
    if self.m_schId then
        sharedScheduler:unscheduleScriptEntry(self.m_schId)
    end
    require("app.MyApp"):create():run()
end

function M:showPath(endpos)
    local path = {}
    local curpos = endpos
    while self.closeList[curpos] ~= nil do
        path[#path + 1] = string.split(curpos,"_")
        curpos = self.closeList[curpos].p
    end
    -- dump(path,"path")
    for k, v in pairs(path) do
        self.blocks[tonumber(v[2])][tonumber(v[1])]:setColor(cc.c3b(0,255,0))
    end
end



return M
