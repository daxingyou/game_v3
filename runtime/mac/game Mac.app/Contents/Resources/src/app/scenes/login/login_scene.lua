--
-- Author: Anthony
-- Date: 2014-09-11 11:54:54
--
collectgarbage("setpause"  ,  100)
collectgarbage("setstepmul"  ,  5000)

------------------------------------------------------------------------------
local ui_manager = import(".login_ui_manager")
local conf_mgr_anis = require("config.anis.conf_mgr_anis")
local MapConstants      = require("app.ac.MapConstants")
------------------------------------------------------------------------------
local login_scene = class("login_scene", function()
    return display.newScene("login_scene")
end)
----------------------------------------------------------------
function login_scene:ctor()
    -- init
    PLAYER:init()
    -----------
    -- test数据
    if CHANNEL_ID == "test" then
        -- 创建
        local function create_hero( GUID, dataid )
            local configMgr = require("config.configMgr")
            local confHeros = configMgr:getConfig("hero")
            local confHeroData = confHeros:GetHeroDataById(dataid)
            local cfheroArt = confHeros:GetHerosArt(confHeroData.artId)
            -- 国家信息
            local countryInfo = {
                id      = confHeroData.country,
                name    = confHeros:getCountryName(confHeroData.country)
            }
        --     dataId  = olddata.dataId,
        -- GUID    = olddata.GUID,
        -- campId  = MapConstants.PLAYER_CAMP,
        -- level   = olddata.level,
        -- quality = olddata.quality,
        -- stars   = olddata.stars,
        -- exp     = olddata.exp,
        -- favor   = olddata.favor, -- 好友度
        -- armId   = olddata.armId,
        -- skills  = skills,
        -- equips  = equips,
            --新数据
            local outInfo = {
                dataId      = dataid,
                GUID        = GUID,
                exp         = confHeroData.exp,
                favor       = confHeroData.favor,
                level       = confHeroData.level,
                campId      = MapConstants.PLAYER_CAMP,
                quality     = confHeroData.quality,    -- 品质
                stars       = confHeroData.stars,      -- 星级

                armId       = confHeroData.armId,
                skills      = confHeroData.skills,
            }
            return outInfo
        end
        local data = {
            create_hero(1001, 1001),
            create_hero(2001, 2001),
            -- create_hero(3001, 3001),
            -- create_hero(4001, 4001),
            -- create_hero(5001, 5001),
            -- create_hero(105, 6001),

        }
        PLAYER:get_mgr("hero"):set_data(data)
         -- fId == 1    "2,4,5,6,8"  -- 鱼鳞阵
         -- fId == 2    "2,3,4,5,7"  -- 长蛇阵
         -- fId == 3    "1,2,3,4,5"  -- 乱剑阵
         -- fId == 4    "2,3,6,8,9"  -- 方圆阵
         -- fId == 5    "1,4,5,6,7"  -- 虎韬阵
         -- fId == 6    "1,3,4,7,9"  -- 鹤翼阵
         -- fId == 7    "1,3,5,7,9"  -- 箕行阵
         -- fId == 8    "2,3,4,8,9"  -- 雁形阵
         -- fId == 9    "1,2,6,7,8"  -- 锥形阵
         -- fId == 10   "3,4,5,6,9"  -- 锋矢阵
        local formation_info = {fId=1,level=0}
       local Formationdata = {
            {index= 2, GUID=data[1].GUID, dataId = data[1].dataId },
            -- {index= 4, GUID=data[2].GUID, dataId = data[2].dataId },
            -- {index= 5, GUID=data[2].GUID, dataId = data[3].dataId },
            -- {index= 6, GUID=data[2].GUID, dataId = data[4].dataId },
            -- {index= 8, GUID=data[5].GUID, dataId = data[5].dataId },
        }
        -- 上阵数据
        PLAYER:get_mgr("formations"):set_data(Formationdata,formation_info)
        -- 关卡数据
        local stages = {
            {Id      = 101,count   = 10,stars   = 2}
        }
        PLAYER:get_mgr("stage"):set_data(stages)
    end
    -----------


    ---------------插入layer---------------------
    -- UI管理层
    self.UIlayer = ui_manager.new(self)
    ---------------------------------------------
end
----------------------------------------------------------------
function login_scene:onEnter()
    conf_mgr_anis:load()

    INIT_FUNCTION.AppExistsListener(self)

    -- 初始
    if self.UIlayer then self.UIlayer:init() end
end
----------------------------------------------------------------
function login_scene:onExit()

    if self.UIlayer then
        self.UIlayer:removeFromParent()
        self.UIlayer = nil
    end
end
----------------------------------------------------------------
return login_scene
----------------------------------------------------------------