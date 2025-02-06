/// @description
x = KEYSTONE_VIEW_CENTER_X
y = KEYSTONE_VIEW_CENTER_Y
if(!keyboard_check(vk_space)) return;
image_angle += 1;
draw_self();