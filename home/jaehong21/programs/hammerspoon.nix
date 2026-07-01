{ ... }:

{
  home.file.".hammerspoon/init.lua".text = ''
    local english = "com.apple.keylayout.ABC"
    -- local english = "io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi"
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
  '';
}
