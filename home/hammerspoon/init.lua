-- Hammerspoon Configuration File
-- Save this file as ~/.hammerspoon/init.lua
-- Then reload Hammerspoon

--------------------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------------------

-- Set variables for commonly used modifiers
local hyper = {"cmd", "alt", "ctrl"}
local shift_hyper = {"cmd", "alt", "ctrl", "shift"}

-- Animation duration for window movements (set to 0 for instant movement)
local window_animation_duration = 0.2

--------------------------------------------------------------------------------
-- APPLICATION LAUNCHER SHORTCUTS
--------------------------------------------------------------------------------

-- Open Firefox with Command + Option + Control + F
hs.hotkey.bind(hyper, "F", function()
    local firefox = hs.application.find("Firefox")
    if firefox then
        firefox:activate()
    else
        hs.application.launchOrFocus("/Applications/Firefox.app")
    end
    
    -- If you want to automatically position Firefox when opened, uncomment this:
    -- hs.timer.doAfter(0.5, function()
    --     local win = hs.window.focusedWindow()
    --     if win and win:application():name() == "Firefox" then
    --         win:moveToUnit({x=0, y=0, w=0.7, h=1})
    --     end
    -- end)
end)

-- Create a table to map hotkeys to applications
local appShortcuts = {
    C = "Calendar",
    M = "Mail",
    S = "Slack",
    T = "WezTerm",
    N = "Notes",
    P = "Spotify",
    V = "VMWare Fusion" 
}

-- Register hotkeys for all the applications in the table
for key, app in pairs(appShortcuts) do
    hs.hotkey.bind(hyper, key, function()
        hs.application.launchOrFocus(app)
    end)
end

--------------------------------------------------------------------------------
-- WINDOW MANAGEMENT
--------------------------------------------------------------------------------

-- Move window to the left half of the screen
hs.hotkey.bind(hyper, "Left", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0, w=0.5, h=1}, window_animation_duration)
    end
end)

-- Move window to the right half of the screen
hs.hotkey.bind(hyper, "Right", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0.5, y=0, w=0.5, h=1}, window_animation_duration)
    end
end)

-- Move window to the top half of the screen
hs.hotkey.bind(hyper, "Up", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0, w=1, h=0.5}, window_animation_duration)
    end
end)

-- Move window to the bottom half of the screen
hs.hotkey.bind(hyper, "Down", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0.5, w=1, h=0.5}, window_animation_duration)
    end
end)

-- Make window full screen (not macOS full screen mode, just fills the screen)
hs.hotkey.bind(hyper, "Return", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0, w=1, h=1}, window_animation_duration)
    end
end)

-- Center window on screen with reasonable size
hs.hotkey.bind(hyper, "C", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0.15, y=0.15, w=0.7, h=0.7}, window_animation_duration)
    end
end)

-- Move window to the top-left quarter of the screen
hs.hotkey.bind(shift_hyper, "1", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0, w=0.5, h=0.5}, window_animation_duration)
    end
end)

-- Move window to the top-right quarter of the screen
hs.hotkey.bind(shift_hyper, "2", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0.5, y=0, w=0.5, h=0.5}, window_animation_duration)
    end
end)

-- Move window to the bottom-left quarter of the screen
hs.hotkey.bind(shift_hyper, "3", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0, y=0.5, w=0.5, h=0.5}, window_animation_duration)
    end
end)

-- Move window to the bottom-right quarter of the screen
hs.hotkey.bind(shift_hyper, "4", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToUnit({x=0.5, y=0.5, w=0.5, h=0.5}, window_animation_duration)
    end
end)

--------------------------------------------------------------------------------
-- MULTI-DISPLAY CONTROLS
--------------------------------------------------------------------------------

-- Move window to the next monitor (right or below)
hs.hotkey.bind(hyper, "N", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next(), false, true, window_animation_duration)
    end
end)

-- Move window to the previous monitor (left or above)
hs.hotkey.bind(hyper, "P", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():previous(), false, true, window_animation_duration)
    end
end)

-- Alternate shortcut to move window to next monitor (easier to remember)
hs.hotkey.bind(hyper, "]", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next(), false, true, window_animation_duration)
    end
end)

-- Alternate shortcut to move window to previous monitor (easier to remember)
hs.hotkey.bind(hyper, "[", function()
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():previous(), false, true, window_animation_duration)
    end
end)

--------------------------------------------------------------------------------
-- WINDOW GRID FOR FINE-GRAINED CONTROL
--------------------------------------------------------------------------------

-- Set up a larger grid (higher numbers = more precise control)
hs.grid.setGrid('12x12')
hs.grid.setMargins({x=0, y=0})

-- Show the grid for the current window
hs.hotkey.bind(hyper, "G", function()
    local win = hs.window.focusedWindow()
    if win then
        hs.grid.show()
    end
end)

--------------------------------------------------------------------------------
-- WINDOW HINTS (LIKE EXPOSE BUT WITH KEYBOARD SHORTCUTS)
--------------------------------------------------------------------------------

-- Show window hints (letters) for quick window selection
hs.hotkey.bind(hyper, "H", function()
    hs.hints.windowHints()
end)

--------------------------------------------------------------------------------
-- RELOAD CONFIGURATION
--------------------------------------------------------------------------------

-- Reload Hammerspoon configuration
hs.hotkey.bind(hyper, "R", function()
    hs.reload()
end)

-- Notify user when config is loaded
hs.alert.show("Hammerspoon config loaded")

--------------------------------------------------------------------------------
-- HELPER FUNCTIONS
--------------------------------------------------------------------------------

-- Toggle an application between hidden and shown
function toggleApplication(appName)
    local app = hs.application.find(appName)
    if app then
        if app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocus(appName)
    end
end

-- This function maximizes the window with a small margin on all sides
-- Great for when you want "almost" fullscreen
function almostMaximize()
    local win = hs.window.focusedWindow()
    if win then
        local margin = 10 -- pixels
        local screenFrame = win:screen():frame()
        local newFrame = {
            x = screenFrame.x + margin,
            y = screenFrame.y + margin,
            w = screenFrame.w - (margin * 2),
            h = screenFrame.h - (margin * 2)
        }
        win:setFrame(newFrame, window_animation_duration)
    end
end

-- Bind the almost maximize function
hs.hotkey.bind(shift_hyper, "Return", almostMaximize)

-- Function to switch between two most recent applications
function switchToNextApplication()
    -- Get the frontmost application
    local currentApplication = hs.application.frontmostApplication()
    
    -- Get all running applications and sort by last activation
    local runningApplications = hs.application.runningApplications()
    table.sort(runningApplications, function(a, b) 
        return a:focusedWindow() ~= nil and b:focusedWindow() == nil
    end)
    
    -- Loop through and find the next app that isn't the current one
    for i, app in ipairs(runningApplications) do
        if app ~= currentApplication and app:focusedWindow() then
            app:activate()
            return
        end
    end
end

-- Bind a shortcut for app switching
hs.hotkey.bind(hyper, "Tab", switchToNextApplication)

-- Log that we've finished loading
print("Hammerspoon configuration loaded")
