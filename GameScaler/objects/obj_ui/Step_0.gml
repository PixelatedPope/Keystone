/// @description
  
var _x = KEYSTONE_VIEW_X + lengthdir_x(.33, camera_direction),
    _y = KEYSTONE_VIEW_Y + lengthdir_y(.33, camera_direction);

var _clamped_x = clamp(_x, 0, room_width - KEYSTONE_VIEW_W);
var _clamped_y = clamp(_y, 0, room_height - KEYSTONE_VIEW_H);

if(_clamped_x != _x || _clamped_y != _y)
  camera_direction -= 90;

camera_set_view_pos(KEYSTONE_VIEW, _clamped_x, _clamped_y)

