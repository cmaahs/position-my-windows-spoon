# PositionMyWindows Spoon

A Hammerspoon Spoon module to handle positioning open windows for an application.

## What do I use this for

I find myself moving between configurations with multiple monitors in multiple locations.  And I needed a way to create a single configuration that allows me to position certain application windows on a certain monitor.  I ran across what I felt was a fairly easy to understand structure for a Hammerspoon Spoon in [miro-windows-manager](https://github.com/miromannino/miro-windows-manager), and from that I started playing around.

I had one specific special case in which I needed to position several different `firefox` windows that are spawned from different isolated applications using separate firefox profiles.  This way I can have a separate icon in the task bar that will bring me to the application I want, like e-mail, JIRA, github, etc.  

## Installation

This will create a ~/tmp temp file in your home directory and clone the repository into it, then move the Spoon to the ~/.hammerspoon/Spoons install directory.  Then add the base loading lines into your ~/.hammerspoon/init.lua file.  Once complete you can clean up the ~/tmp/position-my-windows-spoon directory as you see fit.

```bash
mkdir ~/tmp

cd ~/tmp && git clone https://github.com/cmaahs/position-my-windows-spoon.git
cd ~/tmp/position-my-windows-spoon
mv PositionMyWindows.spoon ~/.hammerspoon/Spoons

if grep -Fxq 'local hyper = {"ctrl", "alt", "cmd"}' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'local hyper = {"ctrl", "alt", "cmd"}' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'hs.loadSpoon("PositionMyWindows")' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'hs.loadSpoon("PositionMyWindows")' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'hs.window.animationDuration = 0.3' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'hs.window.animationDuration = 0.3' >> ~/.hammerspoon/init.lua
fi
if grep -Fxq 'spoon.PositionMyWindows:bindHotkeys({s = { key = { hyper, "s" }, app = { { name = "Slack", prefs = { { monitor = "DELL U3818DW", position = {0,0,1312,1518} }, { monitor = "Color LCD"   , position = {0,0,1200,1027} }, }, }, }, }, m = { key = { hyper, "m" }, app = { { name = "MacDown",   prefs = { { monitor = "Color LCD", position = {0,23,1680,973} }, { monitor = "DELL U3818DW", position = {290,0,1920,1360} }, }, }, }, } })' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.PositionMyWindows:bindHotkeys({s = { key = { hyper, "s" }, app = { { name = "Slack", prefs = { { monitor = "DELL U3818DW", position = {0,0,1312,1518} }, { monitor = "Color LCD"   , position = {0,0,1200,1027} }, }, }, }, }, m = { key = { hyper, "m" }, app = { { name = "MacDown",   prefs = { { monitor = "Color LCD", position = {0,23,1680,973} }, { monitor = "DELL U3818DW", position = {290,0,1920,1360} }, }, }, }, } })' >> ~/.hammerspoon/init.lua
fi
if grep -Fxq 'spoon.PositionMyWindows._logger.level = 3' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.PositionMyWindows._logger.level = 3' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'spoon.PositionMyWindows:DisplayScreenInfo()' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.PositionMyWindows:DisplayScreenInfo()' >> ~/.hammerspoon/init.lua
fi

```

## Configuration

The configuration file looks like this:

```lua
hs.loadSpoon("PositionMyWindows")
spoon.PositionMyWindows._logger.level = 3
spoon.PositionMyWindows:bindHotkeys({
w = { 
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
    },
p = {
            key = { hyper, "p" }, 
            pathapp = {
                          { path = '/Applications/Firefox-GMail.app', baseprocess = 'firefox', prefs = { 
                                                  { monitor = 'C32F391'     , position = {615,0,1300,950} },
                                                  { monitor = 'DELL U3818DW', position = {300,0,1300,1500} },
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                          { path = '/Applications/Firefox-JIRA.app', baseprocess = 'firefox', prefs = {                                                   
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                          { path = '/Applications/Firefox-Git.app', baseprocess = 'firefox', prefs = {                                                   
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                          { path = '/Applications/Firefox-Azure.app', baseprocess = 'firefox', prefs = {                                                   
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                          { path = '/Applications/Firefox-AWS.app', baseprocess = 'firefox', prefs = {                                                   
                                                  { monitor = 'DELL U3818DW', position = {290,0,1920,1360} },
                                                  { monitor = 'C32F391'     , position = {615,0,1300,950} },                                                  
                                                  { monitor = 'Color LCD'   , position = {0,0,1200,800} },                                              
                                                }, 
                          },
                       },      
    }        
})
```

### Determine your attached screens

You can run these lines in your base init.lua, or simply from the command line in the Hammerspoon console window.

```lua
spoon.PositionMyWindows._logger.level = 3
spoon.PositionMyWindows:DisplayScreenInfo()
```

## TODO

- [] Add the Isolated Applications using Firefox README section

## Isolated Applications using Firefox

