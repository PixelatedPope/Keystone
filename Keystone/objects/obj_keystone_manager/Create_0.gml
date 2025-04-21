/// @description
//Define or Load your Keystone settings
if(instance_number(object_index) > 1) {
  throw($"A second instance of {object_get_name(object_index)} was created.");
}

var _settings = new KeystoneSettings(256, 222);
_settings.is_borderless = false;
_settings.is_fullscreen = false;
_settings.is_perfect_scale = true;
_settings.should_show_window_mat = true;
_settings.window_scale = 3;
_settings.gui_scale = 3;
keystone_create(_settings)