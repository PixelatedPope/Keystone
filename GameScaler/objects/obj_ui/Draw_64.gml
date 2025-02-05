/// @description

var _xoff = sprite_get_xoffset(spr_trials_ui);
var _yoff = sprite_get_yoffset(spr_trials_ui);
var _margin = 5;

draw_sprite(spr_trials_ui, 0, _xoff + _margin, _yoff + _margin)
draw_sprite(spr_trials_ui, 1, GUI_W - _xoff - _margin, _yoff + _margin);
draw_sprite(spr_trials_ui, 2, GUI_W / 2, GUI_H - _yoff - 1 - _margin);

//draw_sprite(spr_target, 1, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));