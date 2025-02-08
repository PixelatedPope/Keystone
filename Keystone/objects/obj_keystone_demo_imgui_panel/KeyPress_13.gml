/// @description
if(room == rm_demo_1) {
  room_goto(rm_demo_2)
  keystone_update_base_size(sprite_get_width(spr_mania_screenshot), sprite_get_height(spr_mania_screenshot))
} else if(room == rm_demo_2) {
  keystone_update_base_size(sprite_get_width(spr_trials_screenshot), sprite_get_height(spr_trials_screenshot));
  room_goto(rm_demo_1)
} 