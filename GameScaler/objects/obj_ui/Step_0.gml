/// @description
  
var _x = VIEW_X + lengthdir_x(.1, camera_direction),
    _y = VIEW_Y + lengthdir_y(.1, camera_direction);

var _clamped_x = clamp(_x, 0, room_width - VIEW_W);
var _clamped_y = clamp(_y, 0, room_height - VIEW_H);

if(_clamped_x != _x || _clamped_y != _y)
  camera_direction -= 90;

camera_set_view_pos(VIEW, _clamped_x, _clamped_y)

