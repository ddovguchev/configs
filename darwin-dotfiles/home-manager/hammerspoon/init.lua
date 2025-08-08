local notificationManager = require ("shared.notification-manager")

-- Конфигурация
local config = {
  wallpaperPath = "/Users/dzmitriy/Documents/system/pictures",
  supportedFormats = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp" },
}

-- Функция получения списка изображений
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

-- Функция установки обоев
local function setWallpaper (imagePath)
  local fileURL = "file://" .. imagePath
  local success = true

  -- Устанавливаем обои на все экраны
  local screens = hs.screen.allScreens ()
  for i, screen in ipairs (screens) do
    local screenSuccess = screen:desktopImageURL (fileURL)
    if not screenSuccess then
      success = false
      print ("Ошибка установки обоев на экран " .. i .. ": " .. imagePath)
    else
      print ("Обои установлены на экран " .. i .. ": " .. imagePath)
    end
  end

  -- Устанавливаем обои на все рабочие столы через AppleScript
  local appleScript = string.format (
    [[
        tell application "System Events"
            set desktopCount to count of desktops
            set currentDesktop to 1
            
            repeat with i from 1 to desktopCount
                key code 18 using {control down}
                delay 0.1
                set picture of desktop i to "%s"
                delay 0.1
            end repeat
            
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

  -- Альтернативный подход через defaults
  local cmd2 = string.format (
    [[
        defaults write com.apple.dock persistent-apps -array
        defaults write com.apple.dock persistent-others -array
        defaults write com.apple.dock persistent-apps -array-add '{"tile-data" = {"file-data" = {"_CFURLString" = "%s"; "_CFURLStringType" = 15;};}; "tile-type" = "directory";}'
    ]],
    fileURL
  )
  local result2 = os.execute (cmd2)

  local cmd3 = "killall Dock"
  local result3 = os.execute (cmd3)

  if result1 then
    print ("✅ Обои установлены на все рабочие столы")
  end

  if result2 and result3 then
    print ("✅ Настройки Dock обновлены")
  end

  if success then
    notificationManager.success (
      "✅ Обои установлены: " .. string.match (imagePath, "([^/]+)$") or "Unknown"
    )
    return true
  else
    notificationManager.error ("❌ Ошибка установки обоев")
    return false
  end
end

-- Функция переключения языка
local function switchLanguage ()
  -- Используем Hammerspoon для переключения языка
  local currentSource = hs.keycodes.currentSourceID ()
  local sources = hs.keycodes.sources ()

  if sources and #sources > 1 then
    local currentIndex = 1
    for i, source in ipairs (sources) do
      if source == currentSource then
        currentIndex = i
        break
      end
    end

    local nextIndex = currentIndex % #sources + 1
    hs.keycodes.setMethod (sources[nextIndex])
    notificationManager.info ("🌐 Язык: " .. sources[nextIndex])
    print ("Язык переключен на: " .. sources[nextIndex])
  else
    -- Альтернативный способ через AppleScript
    local appleScript = [[
            tell application "System Events"
                tell process "SystemUIServer"
                    click (menu bar item 1 of menu bar 1 whose description contains "input source")
                    click menu item 2 of menu 1 of menu bar item 1 of menu bar 1
                end tell
            end tell
        ]]

    local result = os.execute ("osascript -e '" .. appleScript .. "'")
    if result then
      notificationManager.info ("🌐 Язык переключен")
      print ("Язык переключен через AppleScript")
    else
      notificationManager.warning ("⚠️ Не удалось переключить язык")
      print ("Не удалось переключить язык")
    end
  end
end

-- Функция обновления Nix
local function updateNix ()
  notificationManager.info ("🔄 Применение конфигурации Nix...")
  print ("🔄 Применяем конфигурацию Nix...")

  -- Используем полный путь к nix
  local applyCmd =
    "cd /Users/dzmitriy/Documents/system/configs/darwin-dotfiles && /run/current-system/sw/bin/nix run --extra-experimental-features 'nix-command flakes' nix-darwin -- switch --flake . > /tmp/nix-output.log 2>&1"

  -- Запускаем в фоне
  local handle = io.popen (applyCmd .. " &")
  if handle then
    handle:close ()

    -- Показываем уведомление о начале
    notificationManager.info ("🔄 Nix обновление запущено в фоне...")
    print ("Nix обновление запущено в фоне")

    -- Проверяем результат через 30 секунд
    hs.timer.doAfter (30, function ()
      local logFile = io.open ("/tmp/nix-output.log", "r")
      if logFile then
        local content = logFile:read ("*a")
        logFile:close ()

        -- Проверяем разные признаки успешного завершения
        if
          content:find ("Activating home%-manager configuration")
          or content:find ("Activating home-manager configuration")
          or content:find ("setupLaunchAgents")
        then
          notificationManager.success ("✅ Конфигурация Nix применена")
          print ("✅ Конфигурация Nix применена")
        else
          -- Проверяем, завершилась ли команда
          local checkCmd = "ps aux | grep 'nix run' | grep -v grep"
          local checkHandle = io.popen (checkCmd)
          if checkHandle then
            local checkOutput = checkHandle:read ("*a")
            checkHandle:close ()

            if checkOutput == "" then
              -- Процесс завершился, но не нашли признаков успеха
              notificationManager.warning ("⚠️ Nix завершился, но результат неясен")
              print ("⚠️ Nix завершился, но результат неясен")
              print ("Лог: " .. content)
            else
              -- Процесс еще работает
              notificationManager.info ("🔄 Nix все еще работает...")
              print ("🔄 Nix все еще работает...")
            end
          else
            notificationManager.error ("❌ Ошибка проверки статуса Nix")
            print ("❌ Ошибка проверки статуса Nix")
          end
        end
      else
        notificationManager.warning ("⚠️ Не удалось прочитать лог Nix")
        print ("Не удалось прочитать лог Nix")
      end
    end)
  else
    notificationManager.error ("❌ Не удалось запустить Nix обновление")
    print ("❌ Не удалось запустить Nix обновление")
  end
end

-- Функция показа селектора обоев
local function showWallpaperSelector ()
  local imageFiles = getImageFiles ()

  if #imageFiles == 0 then
    notificationManager.warning ("⚠️ Изображения не найдены в: " .. config.wallpaperPath)
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
      setWallpaper (choice.path)
    end
  end)

  chooser:choices (choices)
  chooser:show ()
end

-- Привязка хотков
local function bindHotkeys ()
  print ("🔧 Привязка хотков...")

  -- Cmd+Ctrl+W - селектор обоев
  hs.hotkey.bind ({ "cmd", "ctrl" }, "w", function ()
    print ("🎯 Wallpaper hotkey pressed!")
    showWallpaperSelector ()
  end)

  -- Cmd+Space - переключение языка
  hs.hotkey.bind ({ "cmd" }, "space", function ()
    print ("🎯 Language hotkey pressed!")
    switchLanguage ()
  end)

  -- Cmd+Ctrl+K - обновление Nix
  hs.hotkey.bind ({ "cmd", "ctrl" }, "k", function ()
    print ("🎯 Nix hotkey pressed!")
    updateNix ()
  end)

  -- Cmd+Ctrl+R - перезагрузка Hammerspoon
  hs.hotkey.bind ({ "cmd", "ctrl" }, "r", function ()
    notificationManager.info ("🔁 Перезагрузка...")
    hs.timer.doAfter (1, hs.reload)
  end)

  print ("✅ Все хотки привязаны")
end

-- Инициализация
bindHotkeys ()
notificationManager.success ("✅ Hammerspoon загружен")
print ("✅ Hammerspoon configuration loaded")
