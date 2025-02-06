/// @description

var _xoff = sprite_get_xoffset(spr_trials_ui);
var _yoff = sprite_get_yoffset(spr_trials_ui);
var _margin = 5;

draw_sprite_ext(spr_trials_ui, 0, _xoff + _margin, _yoff + _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5))
draw_sprite_ext(spr_trials_ui, 1, GUI_W - _xoff - _margin, _yoff + _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5));
draw_sprite_ext(spr_trials_ui, 2, GUI_W / 2, GUI_H - _yoff - 1 - _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5));

draw_sprite_ext(spr_target, 1, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),1,1,0,c_white,sin_oscillate(0,1,3));