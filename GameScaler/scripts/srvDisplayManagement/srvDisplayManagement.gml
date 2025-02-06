
//@func DisplaySettings()
function DisplaySettings(_base_w, _base_h) constructor{
  base_width = _base_w;
  base_height = _base_h;
  window_scale = AUTO_MAX;
  is_borderless = true;
  is_fullscreen = false;
  is_perfect_scale = false;
  resolution = AUTO_MAX;
  resolution_max = AUTO_MAX; //Probably shouldn't be exposed to players. This is just to prevent your app surface from getting massive on Super HD Monitors (4k, 8k, etc)
  should_show_fullscreen_mat = false; //TODO: Allow user to define custom function for drawing the mat sprite
  enable_filtering = true;
  gui_scale = 1;
  
  //There are no functions in here to keep it easily serializable
}

#region MACROS
__settings = new DisplaySettings(640, 360)
__gui_cam = camera_create_view(0,0, BASE_W, BASE_H)
__gui_surf = noone

#macro AUTO_MAX 0
#macro DISP_SETTINGS global.__settings

#macro BASE_W DISP_SETTINGS.base_width
#macro BASE_H DISP_SETTINGS.base_height
#macro ASPECT (BASE_W / BASE_H)

#macro DISP_W display_get_width()
#macro DISP_H display_get_height()
#macro WIN_W window_get_width()
#macro WIN_H window_get_height()

#macro APP_SURF application_surface
#macro APP_SURF_W surface_get_width(APP_SURF)
#macro APP_SURF_H surface_get_height(APP_SURF)

#macro VIEW view_camera[0]
#macro VIEW_X camera_get_view_x(VIEW)
#macro VIEW_Y camera_get_view_y(VIEW)
#macro VIEW_W camera_get_view_width(VIEW)
#macro VIEW_H camera_get_view_height(VIEW)
#macro VIEW_R (VIEW_X + VIEW_W)
#macro VIEW_B (VIEW_Y + VIEW_H)
#macro VIEW_CENTER_X (VIEW_X + VIEW_W/2)
#macro VIEW_CENTER_Y (VIEW_Y + VIEW_H/2)

#macro GUI_W camera_get_view_width(global.__gui_cam)
#macro GUI_H camera_get_view_height(global.__gui_cam)

#endregion

#region GETTERS

///@function 
function display_get_max_window_scale(){
  if(DISP_SETTINGS.is_borderless){
    return min(DISP_W div BASE_W, DISP_H div BASE_H)
  }
  
  var _min_w = DISP_W div BASE_W;
  var _min_h = DISP_H div BASE_H;
  if(_min_h * BASE_H == DISP_H) _min_h--;
  
  return min(_min_w, _min_h);
}

function display_get_current_window_scale(){
  return min(WIN_W div BASE_W, WIN_H div BASE_H)
}

function display_get_mouse(_device = 0){
  var _pos;
  var _mouse_x = device_mouse_raw_x(0);
  var _mouse_y = device_mouse_raw_y(0);
  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.is_perfect_scale)
    _pos = __display_calculate_app_surf_perfect_render_position();
  else
    _pos = __display_calculate_app_surf_position();
  
  return {
    x: lerp(VIEW_X, VIEW_R, __position_between(_mouse_x, _pos.x1, _pos.x2)),
    y: lerp(VIEW_Y, VIEW_B, __position_between(_mouse_y, _pos.y1, _pos.y2))
  }
}

function display_get_mouse_gui(_device = 0){
  var _pos;
  var _mouse_x = device_mouse_raw_x(0);
  var _mouse_y = device_mouse_raw_y(0);
  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.is_perfect_scale)
    _pos = __display_calculate_app_surf_perfect_render_position();
  else
    _pos = __display_calculate_app_surf_position();
  
  return {
    x: lerp(0, GUI_W, __position_between(_mouse_x, _pos.x1, _pos.x2)),
    y: lerp(0, GUI_H, __position_between(_mouse_y, _pos.y1, _pos.y2))
  }
}

#endregion

#region UPDATERS
function display_update_base_size(_w, _h){
    DISP_SETTINGS.base_width = _w;
    DISP_SETTINGS.base_height = _h;
    display_update_resolution()
    display_update_window_scale()
    display_update_gui_scale()
}

function display_update_fullscreen(){
  if(!DISP_SETTINGS.is_borderless)
    window_set_fullscreen(DISP_SETTINGS.is_fullscreen);  
  
  call_later(.25, time_source_units_seconds, function(){
    display_update_window_scale();
  })
}


function display_update_borderless(){
  window_set_showborder(!DISP_SETTINGS.is_borderless);  
  if(DISP_SETTINGS.is_fullscreen){
    if(DISP_SETTINGS.is_borderless){
      window_set_fullscreen(false);
      call_later(.25, time_source_units_seconds, function(){
        window_set_rectangle(0, 0, DISP_W, DISP_H)
      })
    } else {
      window_set_fullscreen(true); 
    }
  } else {
    display_update_window_scale()
  }
}

function display_update_gui_scale(){
  var _scale = DISP_SETTINGS.gui_scale;
  _scale = clamp(_scale, 1, display_get_current_window_scale());
  if(BASE_W * _scale == GUI_W && BASE_H * _scale == GUI_H) return;

  camera_set_view_size(global.__gui_cam, BASE_W * _scale, BASE_H * _scale);
  if(surface_exists(global.__gui_surf)) surface_free(global.__gui_surf);
  
  global.__gui_surf = surface_create(GUI_W, GUI_H);
}

function display_update_resolution(){
  var _scale = DISP_SETTINGS.resolution;
  if(_scale == 0) _scale = display_get_current_window_scale()
  _scale = clamp(_scale, 1, DISP_SETTINGS.resolution_max);
  var _w = BASE_W * _scale;
  var _h = BASE_H * _scale;
  surface_resize(APP_SURF, _w, _h);
}

function display_update_window_scale(){
  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.is_borderless) {
    window_set_rectangle(0, 0, DISP_W, DISP_H)
    return;
  }
  var _scale = __calculate_max_window_scale()
  window_set_size(BASE_W * _scale, BASE_H * _scale);
  display_update_resolution();
  display_update_gui_scale();
  window_center();
}
#endregion

#region Display Manager Event Functions
function display_create(_settings){
  global.__settings = _settings
  application_surface_draw_enable(false);
  display_update_base_size(_settings.base_width, _settings.base_height)

  display_update_borderless()
  display_update_fullscreen()  
}

function display_draw_gui_begin(){
  if(!surface_exists(global.__gui_surf)){
    global.__gui_surf = surface_create(GUI_W, GUI_H);
  }

  surface_set_target(global.__gui_surf);
  draw_clear_alpha(0,0);
  camera_apply(global.__gui_cam); //NOTE: If at any time in any draw gui event you change render targets (surface_set_target), you will need to call this line again
}


function display_post_draw(){
  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.should_show_fullscreen_mat){
    var _scale = WIN_W / sprite_get_width(spr_fullscreen_mat)
    draw_sprite_ext(spr_fullscreen_mat, 0, WIN_W / 2, WIN_H / 2, _scale, 1, 0, c_white, 1);  
  }

  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.is_perfect_scale){
    var _pos = __display_calculate_app_surf_perfect_render_position();
    draw_surface_stretched(APP_SURF, _pos.x1, _pos.y1, _pos.w, _pos.h);
  } else {
    __surface_draw_filtered(APP_SURF,DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.enable_filtering)
  }
}

function display_draw_gui_end(){
  surface_reset_target();

  if(!surface_exists(global.__gui_surf)) exit;

  display_set_gui_maximize();
  if(DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.is_perfect_scale){
    var _pos = __display_calculate_app_surf_perfect_render_position();
    draw_surface_stretched(global.__gui_surf, _pos.x1, _pos.y1, _pos.w, _pos.h);
  } else {
    __surface_draw_filtered(global.__gui_surf, DISP_SETTINGS.is_fullscreen && DISP_SETTINGS.enable_filtering)
  }  
}

function display_room_start(){
  view_enabled = true;
  view_visible[0] = true;
  camera_set_view_target(VIEW, noone);
  camera_set_view_size(VIEW, BASE_W, BASE_H);
}
#endregion

#region Internal Helpers
function __display_calculate_app_surf_perfect_render_position(){
  var _scale = WIN_H div BASE_H;
  var _w = BASE_W * _scale;
  var _h = BASE_H * _scale;
  var _x1 = WIN_W / 2 - _w / 2;
  var _y1 = WIN_H / 2 - _h / 2;
  var _x2 = _x1 + _w;
  var _y2 = _y1 + _h;
  return {
    x1: _x1,
    y1: _y1,
    x2: _x2,
    y2: _y2,
    w: _w,
    h: _h,
    scale: _scale 
  }
}

function __display_calculate_app_surf_position(){
  var _scale = min(WIN_W / APP_SURF_W, WIN_H / APP_SURF_H);
  var _x = WIN_W / 2 - APP_SURF_W * _scale * .5;
  var _y = WIN_H / 2 - APP_SURF_H * _scale * .5;  
  var _x2 = _x + APP_SURF_W * _scale;
  var _y2 = _y + APP_SURF_H * _scale;
  return {
    x1: _x,
    y1: _y,
    x2: _x2,
    y2: _y2,
    w: APP_SURF_W * _scale,
    h: APP_SURF_H * _scale,
    scale: _scale 
  }
}

function __position_between(_val, _low, _up){
  //normalize values
  _up -= _low
  _val -= _low
  return _val / _up;
}

function __surface_draw_filtered(_surface = application_surface, _enable_filtering = true){
  var _surfWidth = surface_get_width(_surface), 
      _surfHeight = surface_get_height(_surface), 
      _winWidth = window_get_width(), 
      _winHeight = window_get_height(); 
  var _scale = min(_winWidth / _surfWidth, _winHeight / _surfHeight);
  
  var _x = _winWidth / 2 - _surfWidth * _scale * .5;
  var _y = _winHeight / 2 - _surfHeight * _scale * .5;
  
  
  if(_enable_filtering){
      if(_scale != 1){
        shader_set(shd_bilinear);
        shader_set_uniform_f(shader_get_uniform(shd_bilinear, "bitmap_width"), _surfWidth);
        shader_set_uniform_f(shader_get_uniform(shd_bilinear, "bitmap_height"), _surfHeight);
        shader_set_uniform_f(shader_get_uniform(shd_bilinear, "x_scale"), _scale)
        shader_set_uniform_f(shader_get_uniform(shd_bilinear, "y_scale"), _scale); 
      }
  
      draw_surface_ext(_surface, _x, _y, _scale, _scale, 0, c_white, 1);
  
      if (_scale != 1) {
        shader_reset();
      }  
  } else{
    draw_surface_ext(_surface,  _x,  _y, _scale, _scale, 0, c_white, 1)
  }
}

function __calculate_max_window_scale(){
  if(DISP_SETTINGS.window_scale == AUTO_MAX) return display_get_max_window_scale();
  return min(DISP_SETTINGS.window_scale, display_get_max_window_scale());
}

#endregion