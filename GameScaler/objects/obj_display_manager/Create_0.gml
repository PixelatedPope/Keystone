/// @description
settings = new KeystoneDisplaySettings(320, 180);
settings.is_borderless = false;
settings.is_fullscreen = true;
settings.is_perfect_scale = true;
settings.resolution_max = 4;
settings.gui_scale = 2;
display_create(settings)
room_goto(rm_demo_1)