
//@func KeystoneSettings()
function KeystoneSettings(_base_w, _base_h) constructor {
  //There are no functions in here to keep it easily serializable
  base_width = _base_w;
  base_height = _base_h;
  window_scale = KEYSTONE_AUTO_MAX;
  is_borderless = true;
  is_fullscreen = false;
  is_perfect_scale = false;
  resolution = KEYSTONE_AUTO_MAX;
  resolution_max = KEYSTONE_AUTO_MAX; //Probably shouldn't be exposed to players. This is just to prevent your app surface from getting massive on Super HD Monitors (4k, 8k, etc)
  should_show_fullscreen_mat = false; 
  enable_filtering = true;
  gui_scale = 1;
}

function KeystoneBounds(_x1, _y1, _x2 = undefined, _y2 = undefined, _width = undefined, _height = undefined) constructor {
  x1 = _x1;
  y1 = _y1;
  if(_x2 == undefined) {
    width = _width;
    x2 = x1 + _width;  
    height = _height;
    y2 = y1 + _height;
  } else {
    x2 = _x2;
    width = x2 - x1;
    y2 = _y2;
    height = y2 - y1;
  }
}

#region MACROS
#macro KEYSTONE_AUTO_MAX 0
#macro KEYSTONE_SETTINGS global.__keystone_settings
#macro KEYSTONE_VIEW view_camera[0]

#macro KEYSTONE_VIEW_X camera_get_view_x(KEYSTONE_VIEW)
#macro KEYSTONE_VIEW_Y camera_get_view_y(KEYSTONE_VIEW)
#macro KEYSTONE_VIEW_W camera_get_view_width(KEYSTONE_VIEW)
#macro KEYSTONE_VIEW_H camera_get_view_height(KEYSTONE_VIEW)
#macro KEYSTONE_VIEW_R (KEYSTONE_VIEW_X + KEYSTONE_VIEW_W)
#macro KEYSTONE_VIEW_B (KEYSTONE_VIEW_Y + KEYSTONE_VIEW_H)
#macro KEYSTONE_VIEW_CENTER_X (KEYSTONE_VIEW_X + KEYSTONE_VIEW_W/2)
#macro KEYSTONE_VIEW_CENTER_Y (KEYSTONE_VIEW_Y + KEYSTONE_VIEW_H/2)

#macro KEYSTONE_DISP_W display_get_width()
#macro KEYSTONE_DISP_H display_get_height()

#macro KEYSTONE_GUI_W camera_get_view_width(global.__keystone_gui_cam)
#macro KEYSTONE_GUI_H camera_get_view_height(global.__keystone_gui_cam)

#macro KEYSTONE_BASE_W KEYSTONE_SETTINGS.base_width
#macro KEYSTONE_BASE_H KEYSTONE_SETTINGS.base_height
#macro KEYSTONE_ASPECT (KEYSTONE_BASE_W / KEYSTONE_BASE_H)

#macro KEYSTONE_APP_SURF application_surface
#macro KEYSTONE_APP_SURF_W surface_get_width(KEYSTONE_APP_SURF)
#macro KEYSTONE_APP_SURF_H surface_get_height(KEYSTONE_APP_SURF)

#macro KEYSTONE_WIN_W window_get_width()
#macro KEYSTONE_WIN_H window_get_height()

#region PRIVATE GLOBAL VARIABLES
__keystone_settings = new KeystoneSettings(640, 360)
__keystone_gui_cam = camera_create_view(0,0, KEYSTONE_BASE_W, KEYSTONE_BASE_H)
__keystone_gui_surf = noone
__keystone_mat_func = function(){}
#endregion

#region SETTERS
///@func keystone_set_mat_drawing_func(func)
///Allows you to define how your mat sprite is drawn in full screen.
///This function will be passed the window bounds as well as the dimensions the app surface is occupying.
///As such, it needs this signature: function(_window_bounds, _app_surface_bounds)
function keystone_set_mat_drawing_func(_func){
  global.__keystone_mat_func = _func;  
}
#endregion

#region GETTERS

///@func keystone_is_inherently_perfectly_scaled()
///Returns true if the app surface will scale perfectly without needing the is_perfect_scale setting.
function keystone_is_inherently_perfectly_scaled(){
  var _perfect_scale = (KEYSTONE_DISP_H div KEYSTONE_BASE_H) == (KEYSTONE_DISP_H / KEYSTONE_BASE_H)

  if(KEYSTONE_SETTINGS.is_fullscreen){
    if(_perfect_scale) return true;
    return false;
  }
  return true;
}

///@func keystone_get_max_window_scale()
///Returns the max, whole number multiple the window can be on the main display.
function keystone_get_max_window_scale(){
  if(KEYSTONE_SETTINGS.is_borderless){
    return min(KEYSTONE_DISP_W div KEYSTONE_BASE_W, KEYSTONE_DISP_H div KEYSTONE_BASE_H)
  }
  
  var _min_w = KEYSTONE_DISP_W div KEYSTONE_BASE_W;
  var _min_h = KEYSTONE_DISP_H div KEYSTONE_BASE_H;
  if(_min_h * KEYSTONE_BASE_H == KEYSTONE_DISP_H) _min_h--;
  
  return min(_min_w, _min_h);
}

///@func keystone_get_max_element_scale()
///Returns the max, whole number multiple the app surface and gui can be scaled up to based on the current window size.
function keystone_get_max_element_scale(){
  return min(KEYSTONE_WIN_W div KEYSTONE_BASE_W, KEYSTONE_WIN_H div KEYSTONE_BASE_H)
}

///@func keystone_get_mouse([device index = 0])
///If allowing for the is_perfect_scale option, you might need to use this instead of the normal mouse_x and mouse_y
function keystone_get_mouse(_device = 0){

  var _mouse_x = device_mouse_raw_x(0);
  var _mouse_y = device_mouse_raw_y(0);
  var _pos = keystone_get_app_surf_bounds();
  
  return {
    x: lerp(KEYSTONE_VIEW_X, KEYSTONE_VIEW_R, __position_between(_mouse_x, _pos.x1, _pos.x2)),
    y: lerp(KEYSTONE_VIEW_Y, KEYSTONE_VIEW_B, __position_between(_mouse_y, _pos.y1, _pos.y2))
  }
}

///@func keystone_get_mouse_gui([device index = 0])
///If allowing for the is_perfect_scale option, you might need to use this instead of the normal device_mouse_x/y_to_gui() functions
function keystone_get_mouse_gui(_device = 0){
  var _mouse_x = device_mouse_raw_x(0);
  var _mouse_y = device_mouse_raw_y(0);
  var _pos = keystone_get_app_surf_bounds();

  return {
    x: lerp(0, KEYSTONE_GUI_W, __position_between(_mouse_x, _pos.x1, _pos.x2)),
    y: lerp(0, KEYSTONE_GUI_H, __position_between(_mouse_y, _pos.y1, _pos.y2))
  }
}

///@func keyston_get_app_surf_bounds()
///Returns a KeystoneBound struct that represents the rectangle that is currently being used to position and scale the app surface.
function keystone_get_app_surf_bounds(){
  var _scale, _w, _h, _x1, _y1, _x2, _y2;
  if(KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.is_perfect_scale){
    _scale = min(KEYSTONE_WIN_W div KEYSTONE_BASE_W, KEYSTONE_WIN_H div KEYSTONE_BASE_H);
    _w = KEYSTONE_BASE_W * _scale;
    _h = KEYSTONE_BASE_H * _scale;
    _x1 = KEYSTONE_WIN_W / 2 - _w / 2;
    _y1 = KEYSTONE_WIN_H / 2 - _h / 2;
  } else {
    _scale = min(KEYSTONE_WIN_W / KEYSTONE_APP_SURF_W, KEYSTONE_WIN_H / KEYSTONE_APP_SURF_H);
    _x1 = KEYSTONE_WIN_W / 2 - KEYSTONE_APP_SURF_W * _scale * .5;
    _y1 = KEYSTONE_WIN_H / 2 - KEYSTONE_APP_SURF_H * _scale * .5;    
    _w = KEYSTONE_APP_SURF_W * _scale;
    _h = KEYSTONE_APP_SURF_H * _scale;  
  }
  
  _x2 = _x1 + _w;
  _y2 = _y1 + _h;
  return new KeystoneBounds(_x1, _y1, _x2, _y2)
}

#endregion

#region UPDATERS
///@func keystone_update_base_size(width, height)
///Allows you to change the base size. Will automatically update sizes of all related elements.
function keystone_update_base_size(_w, _h){
  KEYSTONE_SETTINGS.base_width = _w;
  KEYSTONE_SETTINGS.base_height = _h;
  keystone_update_resolution()
  keystone_update_window_scale()
  keystone_update_gui_scale()
}

///@func keystone_update_fullscreen()
///Will update the full screen state and/or window size as necessary based on the current settings
function keystone_update_fullscreen(){
  if(!KEYSTONE_SETTINGS.is_borderless)
    window_set_fullscreen(KEYSTONE_SETTINGS.is_fullscreen);  
  
  call_later(.25, time_source_units_seconds, function(){
    keystone_update_window_scale();
  })
}

///@func keystone_update_borderless()
///Will update the window's border visibility and the exclusive full screen state as necessary based on the current settings
function keystone_update_borderless(){
  window_set_showborder(!KEYSTONE_SETTINGS.is_borderless);  
  if(KEYSTONE_SETTINGS.is_fullscreen){
    if(KEYSTONE_SETTINGS.is_borderless){
      window_set_fullscreen(false);
      call_later(.25, time_source_units_seconds, function(){
        window_set_rectangle(0, 0, KEYSTONE_DISP_W, KEYSTONE_DISP_H)
      })
    } else {
      window_set_fullscreen(true); 
    }
  } else {
    keystone_update_window_scale()
  }
}

///@func keystone_update_gui_scale()
///Will resize the keystone gui surface based on the current settings.
function keystone_update_gui_scale(){
  var _scale = KEYSTONE_SETTINGS.gui_scale;
  _scale = clamp(_scale, 1, keystone_get_max_window_scale());
  if(KEYSTONE_BASE_W * _scale == KEYSTONE_GUI_W && KEYSTONE_BASE_H * _scale == KEYSTONE_GUI_H) return;

  camera_set_view_size(global.__keystone_gui_cam, KEYSTONE_BASE_W * _scale, KEYSTONE_BASE_H * _scale);
  
  if(surface_exists(global.__keystone_gui_surf)) surface_free(global.__keystone_gui_surf);
  global.__keystone_gui_surf = surface_create(KEYSTONE_GUI_W, KEYSTONE_GUI_H);
}

///@func keystone_update_resolution()
///Will resize the application surface based on the current settings
function keystone_update_resolution(){
  var _scale = KEYSTONE_SETTINGS.resolution;
  if(_scale == KEYSTONE_AUTO_MAX) 
    _scale = keystone_get_max_window_scale()
  _scale = clamp(_scale, 1, KEYSTONE_SETTINGS.resolution_max == KEYSTONE_AUTO_MAX ? infinity : KEYSTONE_SETTINGS.resolution_max);
  var _w = KEYSTONE_BASE_W * _scale;
  var _h = KEYSTONE_BASE_H * _scale;
  surface_resize(KEYSTONE_APP_SURF, _w, _h);
}

///@func keystone_update_window_scale()
///Will resize window based on current settings. May resize app and gui surfaces.
function keystone_update_window_scale(){
  if(KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.is_borderless) {
    window_set_rectangle(0, 0, KEYSTONE_DISP_W, KEYSTONE_DISP_H)
    return;
  }
  var _scale = __calculate_max_window_scale()
  window_set_size(KEYSTONE_BASE_W * _scale, KEYSTONE_BASE_H * _scale);
  keystone_update_resolution();
  keystone_update_gui_scale();
  window_center();
}
#endregion

#region Display Manager Event Functions
///@func keystone_create(Settings)
///Should be called in the create event of your Keystone Manager after initializing/loading your keystone settings.
function keystone_create(_settings){
  global.__keystone_settings = _settings
  application_surface_draw_enable(false);
  keystone_update_base_size(_settings.base_width, _settings.base_height)

  keystone_update_borderless()
  keystone_update_fullscreen()  
}

///@func keystone_draw_gui_begin()
///Should be called in the Draw Gui Begin event of your Keystone Manager
function keystone_draw_gui_begin(){
  if(!surface_exists(global.__keystone_gui_surf)){
    global.__keystone_gui_surf = surface_create(KEYSTONE_GUI_W, KEYSTONE_GUI_H);
  }

  surface_set_target(global.__keystone_gui_surf);
  draw_clear_alpha(0,0);
  camera_apply(global.__keystone_gui_cam); //NOTE: If at any time in any draw gui event you change render targets (surface_set_target), you will need to call this line again
}

///@func keystone_post_draw()
///Should be called in the Post Draw event of your Keystone Manager
function keystone_post_draw(){
  var _app_surf = keystone_get_app_surf_bounds();
  if(KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.should_show_fullscreen_mat){
    var _win = {x1: 0, y1: 0, x2: KEYSTONE_WIN_W, y2: KEYSTONE_WIN_H, width: KEYSTONE_WIN_W, height: KEYSTONE_WIN_H}
    global.__keystone_mat_func(_win, _app_surf);
  }

  if(KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.is_perfect_scale){
    draw_surface_stretched(KEYSTONE_APP_SURF, _app_surf.x1, _app_surf.y1, _app_surf.width, _app_surf.height);
  } else {
    __surface_draw_filtered(KEYSTONE_APP_SURF,KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.enable_filtering)
  }
}

///@func keystone_draw_gui_end()
///Should be called in the Draw Gui End event of your Keystone Manager
function keystone_draw_gui_end(){
  surface_reset_target();

  if(!surface_exists(global.__keystone_gui_surf)) exit;

  display_set_gui_maximize();
  if(KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.is_perfect_scale){
    var _pos = keystone_get_app_surf_bounds();
    draw_surface_stretched(global.__keystone_gui_surf, _pos.x1, _pos.y1, _pos.width, _pos.height);
  } else {
    __surface_draw_filtered(global.__keystone_gui_surf, KEYSTONE_SETTINGS.is_fullscreen && KEYSTONE_SETTINGS.enable_filtering)
  }  
}

///@func keystone_room_start()
///Should be called in the room start event of your Keystone Manager
function keystone_room_start(){
  view_enabled = true;
  view_visible[0] = true;
  camera_set_view_target(KEYSTONE_VIEW, noone);
  camera_set_view_size(KEYSTONE_VIEW, KEYSTONE_BASE_W, KEYSTONE_BASE_H);
}
#endregion

#region Internal Helpers - You shouldn't need any of these.
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
  if(KEYSTONE_SETTINGS.window_scale == KEYSTONE_AUTO_MAX) return keystone_get_max_window_scale();
  return min(KEYSTONE_SETTINGS.window_scale, keystone_get_max_window_scale());
}

#endregion