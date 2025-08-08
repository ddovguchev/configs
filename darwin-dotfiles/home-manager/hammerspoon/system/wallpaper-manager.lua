local M = {}

local config = {
  wallpaperPath = "/Users/dzmitriy/Documents/system/pictures",
  supportedFormats = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp" },
  listItemHeight = 60,
  previewSize = { width = 400, height = 300 },
  windowWidth = 600,
  windowHeight = 500,
}

local imageList = {}
local previewWindow = nil
local escapeKey = nil
local selectedIndex = 1

local function log (message, level)
  level = level or "INFO"
  print (string.format ("[WALLPAPER-MANAGER] [%s] %s", level, message))
end

local function getSupportedFiles ()
  local files = {}

  -- Check if directory exists
  local dirHandle = io.open (config.wallpaperPath, "r")
  if not dirHandle then
    log (string.format ("Directory does not exist: %s", config.wallpaperPath), "ERROR")
    return files
  end
  dirHandle:close ()

  local handle = io.popen (string.format ("find '%s' -type f", config.wallpaperPath))
  if not handle then
    log ("Failed to open directory", "ERROR")
    return files
  end

  for file in handle:lines () do
    local ext = string.lower (string.match (file, "%.([^%.]+)$") or "")
    for _, format in ipairs (config.supportedFormats) do
      if format == "." .. ext then
        -- Check if file is readable
        local fileHandle = io.open (file, "r")
        if fileHandle then
          fileHandle:close ()
          table.insert (files, file)
          log (string.format ("Found image: %s", file))
        else
          log (string.format ("Cannot read file: %s", file), "WARNING")
        end
        break
      end
    end
  end
  handle:close ()

  log (string.format ("Found %d supported image files", #files))
  return files
end

local function setWallpaper (imagePath)
  -- Check if file exists before trying to set it
  local fileHandle = io.open (imagePath, "r")
  if not fileHandle then
    log (string.format ("File does not exist: %s", imagePath), "ERROR")
    return false
  end
  fileHandle:close ()

  local success = hs.wallpaper.set (imagePath)
  if success then
    log (string.format ("Wallpaper set to: %s", imagePath))
    return true
  else
    log (string.format ("Failed to set wallpaper: %s", imagePath), "ERROR")
    return false
  end
end

local function setupEscapeKey ()
  if escapeKey then
    escapeKey:delete ()
  end

  escapeKey = hs.hotkey.bind ({}, "escape", function ()
    M.hideWallpaperSelector ()
  end)
end

local function removeEscapeKey ()
  if escapeKey then
    escapeKey:delete ()
    escapeKey = nil
  end
end

local function createListCanvas (files, selectedIndex, onSelect)
  local listWidth = config.windowWidth - config.previewSize.width - 40
  local listCanvas = hs.canvas.new ({
    x = 10,
    y = 60,
    w = listWidth,
    h = config.windowHeight - 80,
  })

  -- Background
  listCanvas:appendElements ({
    {
      type = "rectangle",
      action = "fill",
      fillColor = { white = 0.1, alpha = 0.9 },
      roundedRectRadii = { xRadius = 8, yRadius = 8 },
    },
  })

  -- List items
  for i, file in ipairs (files) do
    local filename = string.match (file, "([^/]+)$") or "Unknown"
    local y = (i - 1) * config.listItemHeight + 10

    -- Item background (highlighted if selected)
    local bgColor = (i == selectedIndex) and { white = 0.3, alpha = 0.8 } or { white = 0.05, alpha = 0.5 }
    listCanvas:appendElements ({
      {
        type = "rectangle",
        action = "fill",
        fillColor = bgColor,
        roundedRectRadii = { xRadius = 4, yRadius = 4 },
        frame = { x = 5, y = y, w = listWidth - 10, h = config.listItemHeight - 5 },
      },
    })

    -- Filename
    listCanvas:appendElements ({
      {
        type = "text",
        text = filename,
        textSize = 14,
        textColor = { white = 1 },
        textFont = "FiraCode Nerd Font",
        frame = { x = 15, y = y + 10, w = listWidth - 30, h = 20 },
      },
    })

    -- File path (smaller)
    listCanvas:appendElements ({
      {
        type = "text",
        text = file,
        textSize = 10,
        textColor = { white = 0.6 },
        textFont = "FiraCode Nerd Font",
        frame = { x = 15, y = y + 30, w = listWidth - 30, h = 15 },
      },
    })
  end

  -- Click handler for list
  local clickHandler = hs.eventtap.new ({ hs.eventtap.event.types.leftMouseDown }, function (event)
    local location = event:location ()
    local canvasFrame = listCanvas:topLeft ()

    -- Adjust for window position
    local relativeX = location.x - canvasFrame.x
    local relativeY = location.y - canvasFrame.y

    -- Check if click is within list bounds
    if relativeX >= 0 and relativeX <= listWidth and relativeY >= 0 and relativeY <= config.windowHeight - 80 then
      local itemIndex = math.floor ((relativeY - 10) / config.listItemHeight) + 1
      if itemIndex >= 1 and itemIndex <= #files then
        log (string.format ("Selected image %d: %s", itemIndex, files[itemIndex]))
        onSelect (itemIndex)
        return true
      end
    end

    return false
  end)

  clickHandler:start ()
  return listCanvas, clickHandler
end

local function createPreviewCanvas (imagePath)
  local previewCanvas = hs.canvas.new ({
    x = config.windowWidth - config.previewSize.width - 10,
    y = 60,
    w = config.previewSize.width,
    h = config.previewSize.height,
  })

  previewCanvas:appendElements ({
    {
      type = "rectangle",
      action = "fill",
      fillColor = { white = 0.1, alpha = 0.9 },
      roundedRectRadii = { xRadius = 8, yRadius = 8 },
    },
  })

  local success, image = pcall (hs.image.imageFromPath, imagePath)
  if success and image then
    local imageSize = image:size ()
    local canvasWidth = config.previewSize.width - 20
    local canvasHeight = config.previewSize.height - 20

    local aspectRatio = imageSize.w / imageSize.h
    local displayWidth, displayHeight

    if aspectRatio > (canvasWidth / canvasHeight) then
      displayWidth = canvasWidth
      displayHeight = canvasWidth / aspectRatio
    else
      displayHeight = canvasHeight
      displayWidth = canvasHeight * aspectRatio
    end

    local x = (canvasWidth - displayWidth) / 2 + 10
    local y = (canvasHeight - displayHeight) / 2 + 10

    previewCanvas:appendElements ({
      {
        type = "image",
        image = image,
        frame = { x = x, y = y, w = displayWidth, h = displayHeight },
      },
    })

    log (
      string.format (
        "Image loaded successfully: %s (%.0fx%.0f -> %.0fx%.0f)",
        imagePath,
        imageSize.w,
        imageSize.h,
        displayWidth,
        displayHeight
      )
    )
  else
    -- Placeholder for failed images
    previewCanvas:appendElements ({
      {
        type = "text",
        text = "⚠️ Image not found",
        textSize = 18,
        textColor = { white = 0.5 },
        textFont = "FiraCode Nerd Font",
        frame = { x = 0, y = 0, w = config.previewSize.width, h = config.previewSize.height },
      },
    })

    log (string.format ("Failed to load image: %s", imagePath), "ERROR")
  end

  return previewCanvas
end

function M.showWallpaperSelector (notificationManager)
  if previewWindow then
    M.hideWallpaperSelector ()
    return
  end

  log ("Loading wallpaper selector")

  -- Check if wallpaper directory exists, create if not
  local dirHandle = io.open (config.wallpaperPath, "r")
  if not dirHandle then
    log (string.format ("Creating wallpaper directory: %s", config.wallpaperPath))
    os.execute (string.format ("mkdir -p '%s'", config.wallpaperPath))
  else
    dirHandle:close ()
  end

  -- Get image files
  local files = getSupportedFiles ()
  if #files == 0 then
    notificationManager.warning (string.format ("No images found in directory: %s", config.wallpaperPath))
    return
  end

  -- Calculate window position
  local screen = hs.screen.mainScreen ()
  local frame = screen:frame ()
  local windowX = (frame.w - config.windowWidth) / 2
  local windowY = (frame.h - config.windowHeight) / 2

  -- Create main window
  local mainCanvas = hs.canvas.new ({
    x = windowX,
    y = windowY,
    w = config.windowWidth,
    h = config.windowHeight,
  })

  -- Main background
  mainCanvas:appendElements ({
    {
      type = "rectangle",
      action = "fill",
      fillColor = { white = 0.05, alpha = 0.95 },
      roundedRectRadii = { xRadius = 12, yRadius = 12 },
    },
  })

  -- Title
  mainCanvas:appendElements ({
    {
      type = "text",
      text = string.format ("Select Wallpaper (%d images)", #files),
      textSize = 18,
      textColor = { white = 1 },
      textFont = "FiraCode Nerd Font",
      frame = { x = 20, y = 20, w = config.windowWidth - 40, h = 30 },
    },
  })

  -- Instructions
  mainCanvas:appendElements ({
    {
      type = "text",
      text = "Click image to set wallpaper • ESC to close",
      textSize = 12,
      textColor = { white = 0.7 },
      textFont = "FiraCode Nerd Font",
      frame = { x = 20, y = config.windowHeight - 30, w = config.windowWidth - 40, h = 20 },
    },
  })

  -- Create list and preview
  local listCanvas, listClickHandler
  local previewCanvas

  local function updateSelection (newIndex)
    selectedIndex = newIndex

    -- Update list highlighting
    listCanvas:delete ()
    listCanvas, listClickHandler = createListCanvas (files, selectedIndex, updateSelection)

    -- Update preview
    previewCanvas:delete ()
    previewCanvas = createPreviewCanvas (files[selectedIndex])
  end

  -- Create initial list and preview
  listCanvas, listClickHandler = createListCanvas (files, selectedIndex, updateSelection)
  previewCanvas = createPreviewCanvas (files[selectedIndex])

  -- Set wallpaper button
  local buttonCanvas = hs.canvas.new ({
    x = config.windowWidth - config.previewSize.width - 10,
    y = 60 + config.previewSize.height + 10,
    w = config.previewSize.width,
    h = 40,
  })

  buttonCanvas:appendElements ({
    {
      type = "rectangle",
      action = "fill",
      fillColor = { r = 0.2, g = 0.8, b = 0.2, alpha = 0.8 },
      roundedRectRadii = { xRadius = 6, yRadius = 6 },
    },
  })

  buttonCanvas:appendElements ({
    {
      type = "text",
      text = "Set as Wallpaper",
      textSize = 14,
      textColor = { white = 1 },
      textFont = "FiraCode Nerd Font",
      frame = { x = 0, y = 0, w = config.previewSize.width, h = 40 },
    },
  })

  -- Refresh button
  local refreshButtonCanvas = hs.canvas.new ({
    x = config.windowWidth - config.previewSize.width - 10,
    y = 60 + config.previewSize.height + 60,
    w = config.previewSize.width,
    h = 30,
  })

  refreshButtonCanvas:appendElements ({
    {
      type = "rectangle",
      action = "fill",
      fillColor = { r = 0.3, g = 0.3, b = 0.8, alpha = 0.8 },
      roundedRectRadii = { xRadius = 4, yRadius = 4 },
    },
  })

  refreshButtonCanvas:appendElements ({
    {
      type = "text",
      text = "🔄 Refresh Images",
      textSize = 12,
      textColor = { white = 1 },
      textFont = "FiraCode Nerd Font",
      frame = { x = 0, y = 0, w = config.previewSize.width, h = 30 },
    },
  })

  -- Button click handler
  local buttonClickHandler = hs.eventtap.new ({ hs.eventtap.event.types.leftMouseDown }, function (event)
    local location = event:location ()
    local canvasFrame = buttonCanvas:topLeft ()

    if
      location.x >= canvasFrame.x
      and location.x <= canvasFrame.x + config.previewSize.width
      and location.y >= canvasFrame.y
      and location.y <= canvasFrame.y + 40
    then
      if setWallpaper (files[selectedIndex]) then
        notificationManager.success ("Wallpaper updated")
      else
        notificationManager.error ("Failed to set wallpaper")
      end

      M.hideWallpaperSelector ()
      return true
    end

    return false
  end)

  buttonClickHandler:start ()

  local refreshButtonClickHandler = hs.eventtap.new ({ hs.eventtap.event.types.leftMouseDown }, function (event)
    local location = event:location ()
    local canvasFrame = refreshButtonCanvas:topLeft ()

    if
      location.x >= canvasFrame.x
      and location.x <= canvasFrame.x + config.previewSize.width
      and location.y >= canvasFrame.y
      and location.y <= canvasFrame.y + 30
    then
      if M.refreshImages () then
        notificationManager.success ("Images refreshed")
      else
        notificationManager.warning ("No new images found")
      end

      return true
    end

    return false
  end)

  refreshButtonClickHandler:start ()

  -- Show main window
  mainCanvas:show ()

  -- Store references
  previewWindow = {
    mainCanvas = mainCanvas,
    listCanvas = listCanvas,
    listClickHandler = listClickHandler,
    previewCanvas = previewCanvas,
    buttonCanvas = buttonCanvas,
    buttonClickHandler = buttonClickHandler,
    refreshButtonCanvas = refreshButtonCanvas,
    refreshButtonClickHandler = refreshButtonClickHandler,
    files = files,
  }

  -- Setup escape key
  setupEscapeKey ()

  log (string.format ("Wallpaper selector shown with %d images", #files))
end

function M.hideWallpaperSelector ()
  if not previewWindow then
    return
  end

  -- Remove escape key
  removeEscapeKey ()

  -- Remove click handlers
  if previewWindow.listClickHandler then
    previewWindow.listClickHandler:stop ()
    previewWindow.listClickHandler:delete ()
  end

  if previewWindow.buttonClickHandler then
    previewWindow.buttonClickHandler:stop ()
    previewWindow.buttonClickHandler:delete ()
  end

  if previewWindow.refreshButtonClickHandler then
    previewWindow.refreshButtonClickHandler:stop ()
    previewWindow.refreshButtonClickHandler:delete ()
  end

  -- Delete canvases
  if previewWindow.mainCanvas then
    previewWindow.mainCanvas:delete ()
  end

  if previewWindow.listCanvas then
    previewWindow.listCanvas:delete ()
  end

  if previewWindow.previewCanvas then
    previewWindow.previewCanvas:delete ()
  end

  if previewWindow.buttonCanvas then
    previewWindow.buttonCanvas:delete ()
  end

  if previewWindow.refreshButtonCanvas then
    previewWindow.refreshButtonCanvas:delete ()
  end

  previewWindow = nil
  log ("Wallpaper selector hidden")
end

function M.isSelectorVisible ()
  return previewWindow ~= nil
end

function M.getImageCount ()
  if previewWindow then
    return #previewWindow.files
  end
  return 0
end

function M.setConfig (newConfig)
  for key, value in pairs (newConfig) do
    if config[key] ~= nil then
      config[key] = value
    end
  end
end

function M.getConfig ()
  return hs.fnutils.copy (config)
end

function M.openWallpaperDirectory ()
  local success = hs.execute (string.format ("open '%s'", config.wallpaperPath))
  if success then
    log (string.format ("Opened wallpaper directory: %s", config.wallpaperPath))
    return true
  else
    log (string.format ("Failed to open wallpaper directory: %s", config.wallpaperPath), "ERROR")
    return false
  end
end

function M.refreshImages ()
  if previewWindow then
    local files = getSupportedFiles ()
    if #files > 0 then
      previewWindow.files = files
      selectedIndex = math.min (selectedIndex, #files)

      -- Update list and preview
      if previewWindow.listCanvas then
        previewWindow.listCanvas:delete ()
      end
      if previewWindow.previewCanvas then
        previewWindow.previewCanvas:delete ()
      end

      local function updateSelection (newIndex)
        selectedIndex = newIndex

        if previewWindow.listCanvas then
          previewWindow.listCanvas:delete ()
        end
        previewWindow.listCanvas, previewWindow.listClickHandler =
          createListCanvas (files, selectedIndex, updateSelection)

        if previewWindow.previewCanvas then
          previewWindow.previewCanvas:delete ()
        end
        previewWindow.previewCanvas = createPreviewCanvas (files[selectedIndex])
      end

      previewWindow.listCanvas, previewWindow.listClickHandler =
        createListCanvas (files, selectedIndex, updateSelection)
      previewWindow.previewCanvas = createPreviewCanvas (files[selectedIndex])

      log (string.format ("Refreshed images, found %d files", #files))
      return true
    else
      log ("No images found after refresh", "WARNING")
      return false
    end
  end
  return false
end

return M
