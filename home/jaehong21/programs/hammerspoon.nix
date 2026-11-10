{ ... }:

{
  home.file.".hammerspoon/init.lua".text = ''
    local english = "com.apple.keylayout.ABC"
    local araso = "com.nyttastudio.inputmethod.Araso"
    -- hs.keycodes.currentSourceID()

    local escapeBind

    function setEnglish()
      local source = hs.keycodes.currentSourceID()
      -- hs.alert.show("Current Keyboard Layout: " .. source)

      if not (source == english) then
        hs.keycodes.currentSourceID(english)
      end
      escapeBind:disable()
      hs.eventtap.keyStroke({}, "escape")
      escapeBind:enable()
    end

    escapeBind = hs.hotkey.new({}, "escape", setEnglish):enable()

    local arasoBind = hs.hotkey.new({ "shift" }, "escape", function()
      hs.keycodes.currentSourceID(araso)
    end)

    local function updateArasoBind()
      -- Let Araso receive Shift+Esc directly while it is active.
      if hs.keycodes.currentSourceID() == araso then
        arasoBind:disable()
      else
        arasoBind:enable()
      end
    end

    hs.keycodes.inputSourceChanged(updateArasoBind)
    updateArasoBind()

  '';
}
