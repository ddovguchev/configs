local M = {}

local config = {
  colors = {
    info = { r = 0.2, g = 0.6, b = 1.0, alpha = 1.0 },
    success = { r = 0.2, g = 0.8, b = 0.2, alpha = 1.0 },
    warning = { r = 1.0, g = 0.8, b = 0.0, alpha = 1.0 },
    error = { r = 1.0, g = 0.2, b = 0.2, alpha = 1.0 },
    neutral = { r = 0.4, g = 0.4, b = 0.4, alpha = 1.0 },
  },
  icons = {
    info = "ℹ",
    success = "✓",
    warning = "⚠",
    error = "✗",
    neutral = "?",
  },
  defaultDuration = 3.0,
  animationInterval = 0.05,
  notificationWidth = 350,
  notificationHeight = 80,
  margin = 20,
}

local activeNotifications = {}
local notificationQueue = {}
local isProcessingQueue = false

local function generateId ()
  return tostring (os.time () * 1000 + math.random (999))
end

local function getScreenFrame ()
  local screen = hs.screen.mainScreen ()
  return screen:frame ()
end

local function calculatePosition (frame, width, height)
  return {
    x = frame.x + frame.w - width - config.margin,
    y = frame.y + frame.h - height - config.margin,
  }
end

local function createCanvasElements (color, icon, title, width, height)
  local elements = {}

  table.insert (elements, {
    type = "rectangle",
    action = "fill",
    fillColor = color,
    roundedRectRadii = { xRadius = 8, yRadius = 8 },
  })

  table.insert (elements, {
    type = "text",
    text = icon,
    textSize = 20,
    textColor = { white = 1 },
    textFont = "FiraCode Nerd Font",
    frame = { x = 15, y = 15, w = 30, h = 30 },
  })

  table.insert (elements, {
    type = "text",
    text = title,
    textSize = 16,
    textColor = { white = 1 },
    textFont = "FiraCode Nerd Font",
    frame = { x = 55, y = 15, w = width - 80, h = 25 },
  })

  table.insert (elements, {
    type = "text",
    text = "✕",
    textSize = 16,
    textColor = { white = 1 },
    textFont = "FiraCode Nerd Font",
    frame = { x = width - 35, y = 15, w = 20, h = 20 },
  })

  table.insert (elements, {
    type = "rectangle",
    action = "fill",
    fillColor = { white = 0.3, alpha = 0.5 },
    roundedRectRadii = { xRadius = 4, yRadius = 4 },
    frame = { x = 15, y = 50, w = width - 30, h = 8 },
  })

  table.insert (elements, {
    type = "rectangle",
    action = "fill",
    fillColor = { white = 1, alpha = 0.8 },
    roundedRectRadii = { xRadius = 4, yRadius = 4 },
    frame = { x = 15, y = 50, w = 0, h = 8 },
  })

  return elements
end

function M.showProgress (level, title, duration, callback)
  local id = generateId ()
  local durationNum = tonumber (duration) or config.defaultDuration
  local color = config.colors[level] or config.colors.neutral
  local icon = config.icons[level] or config.icons.neutral

  local frame = getScreenFrame ()
  local position = calculatePosition (frame, config.notificationWidth, config.notificationHeight)

  local canvas = hs.canvas.new ({
    x = position.x,
    y = position.y,
    w = config.notificationWidth,
    h = config.notificationHeight,
  })

  local elements = createCanvasElements (color, icon, title, config.notificationWidth, config.notificationHeight)
  for _, element in ipairs (elements) do
    canvas:appendElements (element)
  end

  canvas:show ()

  activeNotifications[id] = {
    canvas = canvas,
    startTime = hs.timer.secondsSinceEpoch (),
    duration = durationNum,
    callback = callback,
    level = level,
    title = title,
  }

  local startTime = hs.timer.secondsSinceEpoch ()
  local timer = hs.timer.new (config.animationInterval, function ()
    local elapsed = hs.timer.secondsSinceEpoch () - startTime
    local progress = math.min (elapsed / durationNum, 1.0)

    local progressWidth = (config.notificationWidth - 30) * progress
    canvas:elementAttribute (6, "frame", {
      x = 15,
      y = 50,
      w = progressWidth,
      h = 8,
    })

    if progress >= 1.0 then
      M.hide (id)
      if callback then
        callback ()
      end
    end
  end)
  timer:start ()

  activeNotifications[id].timer = timer

  return id
end

function M.show (level, title, duration)
  local durationNum = tonumber (duration) or config.defaultDuration
  return M.showProgress (level, title, durationNum)
end

function M.hide (id)
  if activeNotifications[id] then
    if activeNotifications[id].timer then
      activeNotifications[id].timer:stop ()
    end
    activeNotifications[id].canvas:delete ()
    activeNotifications[id] = nil
  end
end

function M.info (title, duration)
  return M.show ("info", title, duration or config.defaultDuration)
end

function M.success (title, duration)
  return M.show ("success", title, duration or config.defaultDuration)
end

function M.warning (title, duration)
  return M.show ("warning", title, duration or 5.0)
end

function M.error (title, duration)
  return M.show ("error", title, duration or 5.0)
end

function M.queue (level, title, duration)
  table.insert (notificationQueue, {
    level = level,
    title = title,
    duration = duration or config.defaultDuration,
  })

  if not isProcessingQueue then
    M.processQueue ()
  end
end

function M.processQueue ()
  if #notificationQueue == 0 then
    isProcessingQueue = false
    return
  end

  isProcessingQueue = true
  local notification = table.remove (notificationQueue, 1)

  M.showProgress (notification.level, notification.title, notification.duration, function ()
    hs.timer.doAfter (0.5, M.processQueue)
  end)
end

function M.hideAll ()
  for id, _ in pairs (activeNotifications) do
    M.hide (id)
  end
end

function M.getActiveCount ()
  return hs.fnutils.count (activeNotifications)
end

function M.getQueueCount ()
  return #notificationQueue
end

function M.setConfig (newConfig)
  for key, value in pairs (newConfig) do
    if config[key] then
      if type (value) == "table" then
        for subKey, subValue in pairs (value) do
          config[key][subKey] = subValue
        end
      else
        config[key] = value
      end
    end
  end
end

function M.getConfig ()
  return hs.fnutils.copy (config)
end

return M
