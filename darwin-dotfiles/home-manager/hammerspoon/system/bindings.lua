local M = {}

local icons = require ("enum.LayoutIcons")

local function getCurrentLayoutIcon ()
  local layout = hs.keycodes.currentLayout () or "?"
  return icons[layout] or layout
end

function M.setup ()
  hs.hotkey.bind ({ "cmd" }, "space", function ()
    local icon = getCurrentLayoutIcon ()
    print ("[LAYOUT]", "Switched to: " .. icon)
    _G.progressUI.info ("LAYOUT: " .. icon, 1.0)
    hs.eventtap.keyStroke ({ "ctrl" }, "space")
  end)

  hs.hotkey.bind ({ "cmd", "ctrl" }, 15, function () -- 'r' ANSI
    _G.progressUI.info ("SYSTEM", "🔁 Reloading...")
    hs.timer.doAfter (1, hs.reload)
  end)

  -- Тестовая горячая клавиша для проверки уведомлений (Cmd+Ctrl+T)
  hs.hotkey.bind ({ "cmd", "ctrl" }, 17, function () -- 't' ANSI
    print ("Testing notifications...")

    -- Показываем разные типы уведомлений
    _G.progressUI.info ("Test Info", 3.0)

    hs.timer.doAfter (1.0, function ()
      _G.progressUI.success ("Test Success", 3.0)
    end)

    hs.timer.doAfter (2.0, function ()
      _G.progressUI.warning ("Test Warning", 5.0)
    end)

    hs.timer.doAfter (3.0, function ()
      _G.progressUI.error ("Test Error", 5.0)
    end)

    hs.timer.doAfter (4.0, function ()
      _G.progressUI.showProgress ("info", "Test Progress", 4.0, function ()
        print ("Progress completed!")
      end)
    end)
  end)
end

return M
