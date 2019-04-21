-- Copyright (c) 2019 Christopher Maahs
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

--- === PositionMyWindows ===
---
--- With this Spoon you will be able to define Application window locations/sizes per Monitor name.
--- Official homepage for more info and documentation:
--- [https://github.com/cmaahs/position-my-windows-spoon](https://github.com/cmaahs/position-my-windows-spoon)
--- 
-- ## TODO

local obj={}
obj.__index = obj

-- Metadata
obj.name = "PositionMyWindows"
obj.version = "0.1"
obj.author = "Christopher Maahs <cmaahs@gmail.com>"
obj.homepage = "https://github.com/cmaahs/position-my-windows-spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- PositionMyWindows.logger
--- Variable
--- Accessible variable to adjust the logging level
local logger = hs.logger.new(obj.name)
obj._logger = logger
logger.i("Loading ".. obj.name)


-- ## Public variables

-- Comment: Lots of work here to save users a little work. Previous versions required users to call
-- PositionMyWindows:start() every time they changed GRID. The metatable work here watches for those changes and does the work :start() would have done.
package.path = package.path..";Spoons/".. ... ..".spoon/?.lua"

-- ## Internal

function getscreen(s)
  screen = hs.screen(s)
  if not screen then
    return hs.screen{x=0,y=0}
  end
  return screen
end

-- ### Utilities

-- ## Public
-- spoon.PositionMyWindows._logger.level = 3
-- spoon.PositionMyWindows:DisplayScreenInfo()

--- PositionMyWindows:DisplayScreenInfo()
--- Method
--- Expose a routine that the user can call to output screen resolution information to the console window.
function obj:DisplayScreenInfo()
  local screens = hs.screen.allScreens()
  for _, newScreen in ipairs(screens) do
    local coord = newScreen:frame()
    logger.i('Display: '.. newScreen:name())
    logger.i('    ( x='.. coord.x ..', y='.. coord.y ..', w='.. coord.w ..', h='.. coord.h ..' )')
  end
end

function obj:TestSchema()
  local hyper = {"ctrl", "alt", "cmd"}
  local w = { 
            key = { hyper, "w" }, 
            app = { 
                    { name = 'Slack',   prefs = { 
                                                  { monitor = 'DELL U3818DW', position = {0,0,1312,1518} },
                                                  { monitor = 'C32F391'     , position = {0,0,1400,1057} },
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,1027} },                                              
                                                }, 
                    },
                    { name = 'OneNote', prefs = { 
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {100,0,1200,800} },
                                                  { monitor = 'Color LCD'   , position = {100,0,1200,800} },
                                                },
                    },
                    { name = 'MacDown', prefs = {
                                                  { monitor = 'Color LCD'   , position = {0,23,1680,973} },
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {100,0,1200,800} },
                                                },
                    },
                  },
              pathapp = {
                          { path = '/Applications/Firefox-GMail.app', baseprocess = 'firefox', prefs = { 
                                                  { monitor = 'C32F391'     , position = {640,0,1300,950} },
                                                  { monitor = 'DELL U3818DW', position = {300,0,1300,1500} },
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                        },
            }

  
  for i,stuff in pairs(w) do
    if i == 'pathapp' then
      for z,applist in pairs(stuff) do
        logger.i(applist.path)
        logger.i(applist.baseprocess)
        local myprefs = applist.prefs
        for y,pref in pairs(myprefs) do
          --logger.i('prefs: '.. y)
          logger.i(y ..' = '.. pref.monitor)
          logger.i(y ..' = { '.. pref.position[1] ..','.. pref.position[2] ..','.. pref.position[3] ..','.. pref.position[4] ..' }')
        end
      end      
    end
    if i == 'app' then
      for z,applist in pairs(stuff) do
        logger.i(applist.name)
        local myprefs = applist.prefs
        for y,pref in pairs(myprefs) do
          --logger.i('prefs: '.. y)
          logger.i(y ..' = '.. pref.monitor)
          logger.i(y ..' = { '.. pref.position[1] ..','.. pref.position[2] ..','.. pref.position[3] ..','.. pref.position[4] ..' }')
        end
      end
    end
    --logger.i('App:'.. stuff.name)
    --logger.i('Name: '.. stuff.app.name)
  end             
end

--- PositionMyWindows:position(appinfo)
--- Method
--- Called for each appinfo object and used to position the application window defined.
---
--- Parameters:
---  * appinfo - Struct containing screen, app, and positioning info.
function obj:position(appinfo)
  
  for i,appdetail in pairs(appinfo) do
    if i == 'pathapp' then
      for z,applist in pairs(appdetail) do
        local baseproc = {hs.application.find(applist.baseprocess)}
        if baseproc then
          for _, app in pairs(baseproc) do
            logger.i(app:name())
            if app:isHidden() == false then
              -- name from the struct
              logger.i(applist.path)
              logger.i(app:path())
              logger.i(app:name())
              logger.i(applist.baseprocess)
              if app:name():lower() == applist.baseprocess:lower() then
                if app:path() == applist.path then 
                  --hs.alert.show(app:path())
                  local myprefs = applist.prefs
                  placed = false
                  for y,pref in pairs(myprefs) do
                    if not placed then
                      s = hs.screen(pref.monitor)
                      if s then
                        hs.fnutils.each(app:visibleWindows(), function(w)
                        if w:screen():id() ~= s:id() then
                          logger.i('moving screens'.. w:screen():name() ..' to '.. s:name())
                          w:moveToScreen(s)
                        end
                        w:setFrameInScreenBounds()
                        end)
                      end
                      if pref.position then
                        local preferred_position = {}
                        for i=1, #pref.position do
                          preferred_position[i] = pref.position[i]
                        end     
                        coord = s:frame()
                        preferred_position[1] = preferred_position[1] + coord.x
                        preferred_position[2] = preferred_position[2] + coord.y                      
                        local win = app:mainWindow()
                        if not app:isHidden() and win then
                          logger.i('set position')
                          logger.i('monitor:'.. s:name())                          
                          win:setFrame(hs.geometry.rect(preferred_position))
                        end
                        placed = true
                      end
                    end --not placed
                  end                  
                end
              end
            end
          end
        end
      end
    end


    if i == 'app' then
      for z,applist in pairs(appdetail) do
        logger.i(applist.name)

        local app = hs.application.find(applist.name)
        if app then
          --for i, app in ipairs(findapp) do
          -- unhide it if we are going to adjust it
          if applist.prefs then
            if app:isHidden() then
              app:unhide()
            end
          end


          local myprefs = applist.prefs
          placed = false
          for y,pref in pairs(myprefs) do
            --logger.i('prefs: '.. y)
            logger.i(y ..' = '.. pref.monitor)
            if not placed then
              monitorCheck = hs.screen(pref.monitor)
              if monitorCheck then
                logger.i('moving to...'.. pref.monitor ..' @ { '.. pref.position[1] ..','.. pref.position[2] ..','.. pref.position[3] ..','.. pref.position[4] ..' }')
                hs.fnutils.each(app:visibleWindows(), function(w)
                  if w:screen():id() ~= monitorCheck:id() then
                    w:moveToScreen(s)
                  end
                  w:setFrameInScreenBounds()
                end)

                if pref.position then
                  local preferred_position = {}
                  for i=1, #pref.position do
                    preferred_position[i] = pref.position[i]
                  end                  
                  local win = app:mainWindow()
                  if not app:isHidden() and win then
                    coord = monitorCheck:frame()
                    local wcoord = win:frame()
                    preferred_position[1] = preferred_position[1] + coord.x
                    preferred_position[2] = preferred_position[2] + coord.y                             
                    win:setFrame(hs.geometry.rect(preferred_position))
                  end
                end                
                placed = true
              end
            end
            logger.i(y ..' = { '.. pref.position[1] ..','.. pref.position[2] ..','.. pref.position[3] ..','.. pref.position[4] ..' }')
          end
        end
      end
    end
  end
end

-- ## Spoon mechanics (`bind`, `init`)

obj.hotkeys = {}

--- PositionMyWindows:bindHotkeys()
--- Method
--- Binds hotkeys for CacadeWindows
---
--- Parameters:
---  * applist - A table containing hotkey details for defined applications:
---
--- A configuration example:
--- ``` lua
--- hs.loadSpoon("PositionMyWindows")
--- spoon.PositionMyWindows:bindHotkeys({
--- w = { 
---             key = { hyper, "w" }, 
---             app = { 
---                     { name = 'Slack',   prefs = { 
---                                                   { monitor = 'DELL U3818DW', position = {0,0,1312,1518} },
---                                                   { monitor = 'C32F391'     , position = {0,0,1400,1057} },
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,1027} },                                              
---                                                 }, 
---                     },
---                     { name = 'OneNote', prefs = { 
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {100,0,1200,800} },
---                                                   { monitor = 'Color LCD'   , position = {100,0,1200,800} },
---                                                 },
---                     },
---                     { name = 'MacDown', prefs = {
---                                                   { monitor = 'Color LCD'   , position = {0,23,1680,973} },
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {100,0,1200,800} },
---                                                 },
---                     },
---                   },
---               pathapp = {
---                           { path = '/Applications/Firefox-GMail.app', baseprocess = 'firefox', prefs = { 
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },
---                                                   { monitor = 'DELL U3818DW', position = {300,0,1300,1500} },
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                           { path = '/Applications/Firefox-JIRA.app', baseprocess = 'firefox', prefs = {                                                   
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                           { path = '/Applications/Firefox-Git.app', baseprocess = 'firefox', prefs = {                                                   
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                           { path = '/Applications/Firefox-Azure.app', baseprocess = 'firefox', prefs = {                                                   
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                           { path = '/Applications/Firefox-AWSProd.app', baseprocess = 'firefox', prefs = {                                                   
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                           { path = '/Applications/Firefox-AWSQA.app', baseprocess = 'firefox', prefs = {                                                   
---                                                   { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
---                                                   { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
---                                                   { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
---                                                 }, 
---                           },
---                         },      
---     }    
--- })
--- spoon.PositionMyWindows._logger.level = 3
--- ```
---
function obj:bindHotkeys(applist)
  logger.i("Bind Hotkeys for PositionMyWindows")

  for key,appdef in pairs(applist) do
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind(
      applist[key].key[1],
      key,
      function() self:position(appdef) end)
  
  end

end

--- PositionMyWindows:init()
--- Method
--- Currently does nothing (implemented so that treating this Spoon like others won't cause errors).
function obj:init()
  -- void (but it could be used to initialize the module)
end

return obj