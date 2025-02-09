/// @description
//Define or Load your Keystone settings
var _settings = new KeystoneSettings(256, 222);
_settings.is_borderless = false;
_settings.is_fullscreen = false;
_settings.is_perfect_scale = true;
_settings.should_show_window_mat = true;
keystone_create(_settings)