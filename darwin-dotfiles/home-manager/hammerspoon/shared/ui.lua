local M = {}
local activeCanvases = {}

local function showCanvas (level, title, text, duration)
  local screen = hs.screen.mainScreen ()
  local frame = screen:frame ()
  local id = tostring (os.time () * 1000 + math.random (999))

  local canvas = hs.canvas
    .new ({
      x = frame.x + frame.w - 320,
      y = frame.y + frame.h - 80,
      w = 300,
      h = 60,
    })
    :appendElements ({
      {
        type = "rectangle",
        action = "fill",
        fillColor = { white = 0, alpha = 0.92 },
        strokeColor = { white = 1, alpha = 0.15 },
        roundedRectRadii = { xRadius = 12, yRadius = 12 },
      },
      {
        type = "text",
        text = string.format ("[%s] %s\n%s", level, title, text),
        textSize = 14,
        textColor = { white = 1 },
        textFont = "FiraCode Nerd Font",
        frame = { x = 10, y = 10, w = 280, h = 40 },
      },
    })

  canvas:show ()
  activeCanvases[id] = canvas

  if duration and duration > 0 then
    hs.timer.doAfter (duration / 1000, function ()
      M.hide (id)
    end)
  end

  return id
end

function M.alert (title, subtitle, text, duration)
  print (string.format ("[ALERT] [%s] %s", title, text))
  return showCanvas ("INFO", title, text, duration or 1000)
end

function M.info (title, text)
  print (string.format ("[INFO] [%s] %s", title, text))
  return showCanvas ("INFO", title, text, 3000)
end

function M.error (title, text)
  print (string.format ("[ERROR] [%s] %s", title, text))
  return showCanvas ("ERROR", title, text, 5000)
end

function M.hide (id)
  if activeCanvases[id] then
    activeCanvases[id]:delete ()
    activeCanvases[id] = nil
  end
end

return M
