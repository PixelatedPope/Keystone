/// @description
//Define or Load your Keystone settings

var _w = sprite_get_width(spr_trials_screenshot)
var _h = sprite_get_height(spr_trials_screenshot);
settings = new KeystoneSettings(_w, _h);
settings.is_borderless = true;
settings.is_fullscreen = true;
settings.is_perfect_scale = true;
settings.should_show_fullscreen_mat = true;

keystone_set_mat_drawing_func(
  function(_win, _app){
    static _off = 0;
    _off -= 1;
    var _scale = _win.width / sprite_get_width(spr_fullscreen_mat)
    draw_sprite_tiled_ext(spr_fullscreen_mat, 0, _off, _off, 64, 64, c_white, 1);
    gpu_set_tex_filter(true)
    var _size = sin_oscillate(0, 150, 4) + random_range(0, 50)
    draw_sprite_stretched_ext(spr_vignette, 0, -_size, -_size, _win.width + _size*2, _win.height + _size*2, c_white, .75)
    gpu_set_tex_filter(false)
    if(KEYSTONE_SETTINGS.is_perfect_scale){
      var _off_x = sprite_get_xoffset(spr_mana_frame)
      var _off_y = sprite_get_yoffset(spr_mana_frame)
      draw_sprite_stretched(spr_mana_frame, 0, _app.x1-_off_x, _app.y1-_off_y, _app.width+_off_x*2, _app.height+_off_y*2);  
    }
  })
keystone_create(settings)
room_goto(rm_demo_1)