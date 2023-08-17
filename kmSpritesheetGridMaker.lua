if not app.isUIAvailable then
  return
end

local sprite = app.activeSprite

if not sprite then 
	return app.alert("There is no active sprite")
end

local cel = app.activeCel
if not cel then	
	return app.alert("There is no active image")
end

local dlg = Dialog {
  title = "Spritesheet Grid Maker"
}

local default_main_color = Color { r = 214, g = 127, b = 255 }
local default_secondary_color = Color { r = 107, g = 63, b = 127 }

function draw_grid(image, data)
  if image.colorMode == ColorMode.RGB then
    local rgba = app.pixelColor.rgba
    
    for it in image:pixels() do
      local x = it.x
      local y = it.y

      if data.drawside == "Bottom Right" then
        x = x + 1
        y = y + 1
      end

      if (y % data.vertical_step) == 0 then
        it(rgba(data.secondarycolor.red, data.secondarycolor.green, data.secondarycolor.blue, 255))
      elseif (x % data.horizontal_step) == 0 then
        it(rgba(data.secondarycolor.red, data.secondarycolor.green, data.secondarycolor.blue, 255))
      else
        it(rgba(data.maincolor.red, data.maincolor.green, data.maincolor.blue, 255))
      end
    end
  end
end

dlg:slider {
  id = "horizontal_step",
  label = "Horizontal Step",
  value = "8",
  min = 1,
  max = 128
}

dlg:slider {
  id = "vertical_step",
  label = "Vertical Step",
  value = "8",
  min = 1,
  max = 128
}

dlg:color {
  id = "maincolor",
  label = "Primary Color",
  color = default_main_color
}

dlg:color {
  id = "secondarycolor",
  label = "Secondary Color",
  color = default_secondary_color
}

dlg:combobox {
  id = "drawside",
  label = "Draw Side",
  option = "Top Left",
  options = { "Top Left", "Bottom Right" }
}

dlg:button {
  id = "confirm",
  text = "Confirm"
}

dlg:button {
  id = "cancel",
  text = "Cancel"
}

local data = dlg:show().data

if data.confirm then
  local img = cel.image:clone()

  draw_grid(img, data)
  cel.image = img
  app.refresh()
end
