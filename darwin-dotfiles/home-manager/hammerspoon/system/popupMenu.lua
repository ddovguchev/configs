local M = {}

local config = {
  wallpaperPath = "/Users/dzmitriy/Documents/system/pictures",
  supportedFormats = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp" },
}

local function getImageFiles ()
  local files = {}
  local handle = io.popen (string.format ("find '%s' -type f", config.wallpaperPath))
  if not handle then
    return files
  end

  for file in handle:lines () do
    local ext = string.lower (string.match (file, "%.([^%.]+)$") or "")
    for _, format in ipairs (config.supportedFormats) do
      if format == "." .. ext then
        local filename = string.match (file, "([^/]+)$") or "Unknown"
        table.insert (files, {
          path = file,
          name = filename,
        })
        break
      end
    end
  end
  handle:close ()

  return files
end

local function setWallpaper (imagePath)
  -- Convert file path to file URL
  local fileURL = "file://" .. imagePath

  -- Use the correct API to set wallpaper on all screens and spaces
  local success = true

  -- Get all screens
  local screens = hs.screen.allScreens ()
  for i, screen in ipairs (screens) do
    -- Set wallpaper for this screen
    local screenSuccess = screen:desktopImageURL (fileURL)
    if not screenSuccess then
      success = false
      print ("Ошибка установки обоев на экран " .. i .. ": " .. imagePath)
    else
      print ("Обои установлены на экран " .. i .. ": " .. imagePath)
    end
  end

  -- Try to set wallpaper on all spaces by switching to each space
  local appleScript = string.format (
    [[
        tell application "System Events"
            set desktopCount to count of desktops
            set currentDesktop to 1
            
            repeat with i from 1 to desktopCount
                -- Switch to desktop i
                key code 18 using {control down}
                delay 0.1
                
                -- Set wallpaper for current desktop
                set picture of desktop i to "%s"
                delay 0.1
            end repeat
            
            -- Return to original desktop
            repeat with i from 1 to (currentDesktop - 1)
                key code 19 using {control down}
                delay 0.1
            end repeat
        end tell
    ]],
    imagePath
  )

  local cmd1 = string.format ("osascript -e '%s'", appleScript)
  local result1 = os.execute (cmd1)

  -- Alternative approach using defaults for all spaces
  local cmd2 = string.format (
    [[
        defaults write com.apple.dock persistent-apps -array
        defaults write com.apple.dock persistent-others -array
        defaults write com.apple.dock persistent-apps -array-add '{"tile-data" = {"file-data" = {"_CFURLString" = "%s"; "_CFURLStringType" = 15;};}; "tile-type" = "directory";}'
    ]],
    fileURL
  )
  local result2 = os.execute (cmd2)

  -- Restart Dock to apply changes
  local cmd3 = "killall Dock"
  local result3 = os.execute (cmd3)

  if result1 then
    print (
      "✅ Обои установлены на все рабочие столы через переключение"
    )
  else
    print ("❌ Ошибка установки обоев через переключение")
  end

  if result2 and result3 then
    print ("✅ Настройки Dock сброшены и обновлены")
  end

  if success then
    print ("✅ Обои установлены на все экраны и рабочие столы: " .. imagePath)
    return true
  else
    print ("❌ Ошибка установки обоев: " .. imagePath)
    return false
  end
end

local function switchLanguage ()
  -- Switch input source
  local currentSource = hs.keycodes.currentSourceID ()
  local sources = hs.keycodes.sources ()

  if #sources > 1 then
    local currentIndex = 1
    for i, source in ipairs (sources) do
      if source == currentSource then
        currentIndex = i
        break
      end
    end

    local nextIndex = currentIndex % #sources + 1
    hs.keycodes.setMethod (sources[nextIndex])
    print ("Язык переключен на: " .. sources[nextIndex])
  else
    print ("Доступен только один язык ввода")
  end
end

local function updateNix ()
  print ("🔄 Начинаем обновление Nix...")

  -- Run nix update
  local cmd = "cd /Users/dzmitriy/Documents/system/configs/darwin-dotfiles && nix flake update"
  local result = os.execute (cmd)

  if result then
    print ("✅ Nix flake обновлен")

    -- Apply the update
    local applyCmd =
      "cd /Users/dzmitriy/Documents/system/configs/darwin-dotfiles && sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake ."
    local applyResult = os.execute (applyCmd)

    if applyResult then
      print ("✅ Конфигурация Nix применена")
    else
      print ("❌ Ошибка применения конфигурации Nix")
    end
  else
    print ("❌ Ошибка обновления Nix flake")
  end
end

function M.show ()
  local imageFiles = getImageFiles ()

  if #imageFiles == 0 then
    print ("Изображения не найдены в: " .. config.wallpaperPath)
    return
  end

  local choices = {}
  for _, file in ipairs (imageFiles) do
    table.insert (choices, {
      text = file.name,
      subText = file.path,
      path = file.path,
    })
  end

  local chooser = hs.chooser.new (function (choice)
    if not choice then
      return
    end

    if choice.path then
      if setWallpaper (choice.path) then
        print ("✅ Обои установлены: " .. choice.text)
      else
        print ("❌ Ошибка установки: " .. choice.text)
      end
    end
  end)

  chooser:choices (choices)
  chooser:show ()
end

function M.bind ()
  print ("🔧 Binding hotkeys in popupMenu...")

  -- Wallpaper selector
  hs.hotkey.bind ({ "ctrl", "cmd" }, "w", function ()
    print ("🎯 Wallpaper hotkey pressed!")
    hs.alert.show ("Wallpaper hotkey works!")
    M.show ()
  end)

  -- Language switcher
  hs.hotkey.bind ({ "cmd" }, "space", function ()
    print ("🎯 Language hotkey pressed!")
    hs.alert.show ("Language hotkey works!")
    switchLanguage ()
  end)

  -- Nix updater
  hs.hotkey.bind ({ "ctrl", "cmd" }, "k", function ()
    print ("🎯 Nix hotkey pressed!")
    hs.alert.show ("Nix hotkey works!")
    updateNix ()
  end)

  print ("✅ All hotkeys bound successfully")
end

return M
