/// @description

var _xoff = sprite_get_xoffset(spr_trials_ui);
var _yoff = sprite_get_yoffset(spr_trials_ui);
var _margin = 5;

draw_sprite_ext(spr_trials_ui, 0, _xoff + _margin, _yoff + _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5))
draw_sprite_ext(spr_trials_ui, 1, KEYSTONE_GUI_W - _xoff - _margin, _yoff + _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5));
draw_sprite_ext(spr_trials_ui, 2, KEYSTONE_GUI_W / 2, KEYSTONE_GUI_H - _yoff - 1 - _margin, 1, 1, 0, c_white, sin_oscillate(0, 1, 5));


var _pos = display_get_mouse_gui()
draw_sprite_ext(spr_target, 1, _pos.x, _pos.y,1,1,0,c_white,sin_oscillate(0,1,3));