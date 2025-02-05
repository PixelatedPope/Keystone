#macro AUTO_RES 0
global.settings = {
  window_scale: 30,
  is_borderless: true,
  is_fullscreen: false,
  is_perfect_scale: false,
  resolution: AUTO_RES,
  resolution_max: infinity, 
  should_show_fullscreen_mat: false,
  enable_filtering: true,
  gui_scale: 1
}

global.display_data = {
  gui_cam: camera_create_view(0,0, BASE_W, BASE_H),
  gui_surf: noone
}

#macro BASE_W 256
#macro BASE_H 222
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

#macro GUI_W camera_get_view_width(global.display_data.gui_cam)
#macro GUI_H camera_get_view_height(global.display_data.gui_cam)

function get_max_window_scale(){
  if(global.settings.is_borderless){
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

function display_set_fullscreen(_is_fullscreen){
  global.settings.is_fullscreen = _is_fullscreen;
  if(!global.settings.is_borderless)
    window_set_fullscreen(_is_fullscreen);  
  
  call_later(.25, time_source_units_seconds, function(){
    display_set_window_scale();
  })
}

function display_get_mouse_x(){
  var _pos;
  if(global.settings.is_fullscreen && global.settings.is_perfect_scale)
    _pos = __display_calculate_app_surf_perfect_render_position();
  else
    _pos = __display_calculate_app_surf_position();
  var _mouse_x = window_mouse_get_x();
  return lerp(VIEW_X, VIEW_R, __position_between(_mouse_x, _pos.x1, _pos.x2));
}

function display_get_mouse_y(){
  var _pos;
  if(global.settings.is_fullscreen && global.settings.is_perfect_scale)
    _pos = __display_calculate_app_surf_perfect_render_position();
  else
    _pos = __display_calculate_app_surf_position();
  var _mouse_y = window_mouse_get_y();
  return lerp(VIEW_Y, VIEW_B, __position_between(_mouse_y, _pos.y1, _pos.y2));
}

function display_set_perfect_scaling(_is_perfect){
  global.settings.is_perfect_scale = _is_perfect;
}
function display_set_should_show_fullscreen_mat(_should_show){
  global.settings.should_show_fullscreen_mat = _should_show;  
}
function display_set_filter_enabled(_should_filter){
  global.settings.enable_filtering = _should_filter;  
}

function display_set_borderless(_is_borderless){
  window_set_showborder(!_is_borderless);  
  global.settings.is_borderless = _is_borderless;
  if(global.settings.is_fullscreen){
    if(_is_borderless){
      window_set_fullscreen(false);
      call_later(.25, time_source_units_seconds, function(){
        window_set_rectangle(0, 0, DISP_W, DISP_H)
      })
    } else {
      window_set_fullscreen(true); 
    }
  } else {
    display_set_window_scale()
  }
}

function display_set_gui_scale(_scale = global.settings.gui_scale){
  _scale = clamp(_scale, 1, display_get_current_window_scale());
  if(BASE_W * _scale == GUI_W && BASE_H * _scale == GUI_H) return;
  global.settings.gui_scale = _scale;
  camera_set_view_size(global.display_data.gui_cam, BASE_W * _scale, BASE_H * _scale);
  if(surface_exists(global.display_data.gui_surf)) surface_free(global.display_data.gui_surf);
  
  global.display_data.gui_surf = surface_create(GUI_W, GUI_H);
}

function display_set_resolution(_scale = global.settings.resolution){
  global.settings.resolution = _scale;
  if(_scale == 0) _scale = display_get_current_window_scale()
  _scale = clamp(_scale, 1, global.settings.resolution_max);
  var _w = BASE_W * _scale;
  var _h = BASE_H * _scale;
  surface_resize(APP_SURF, _w, _h);
}

function display_set_window_scale(_scale = global.settings.window_scale){
  if(global.settings.is_fullscreen && global.settings.is_borderless) {
    window_set_rectangle(0, 0, DISP_W, DISP_H)
    return;
  }
    
  global.settings.window_scale = min(_scale, get_max_window_scale(global.settings.is_borderless));  
  window_set_size(BASE_W * global.settings.window_scale, BASE_H * global.settings.window_scale);
  display_set_resolution();
  display_set_gui_scale();
  window_center();
}

#region Event Functions
function display_create(){
  var _settings = global.settings;
  window_set_showborder(!_settings.is_borderless)
  var _scale;
  if(_settings.is_fullscreen && !_settings.is_borderless){
    window_set_fullscreen(true);
  } else {
    _scale = min(get_max_window_scale(_settings.is_borderless), _settings.window_scale)
    window_set_size(BASE_W * _scale, BASE_H * _scale);
    window_center();
  }
  display_set_window_scale()
  application_surface_draw_enable(false);  
}

function display_draw_gui_begin(){
  
  if(!surface_exists(global.display_data.gui_surf)){
    global.display_data.gui_surf = surface_create(GUI_W, GUI_H);
  }

  surface_set_target(global.display_data.gui_surf);
  draw_clear_alpha(0,0);
  camera_apply(global.display_data.gui_cam); //NOTE: If at any time in any draw gui event you change render targets (surface_set_target), you will need to call this line again
}


function display_post_draw(){
  var _settings = global.settings;

  if(_settings.is_fullscreen && _settings.should_show_fullscreen_mat){
    var _scale = WIN_W / sprite_get_width(spr_fullscreen_mat)
    draw_sprite_ext(spr_fullscreen_mat, 0, WIN_W / 2, WIN_H / 2, _scale, 1, 0, c_white, 1);  
  }

  if(_settings.is_fullscreen && _settings.is_perfect_scale){
    var _pos = __display_calculate_app_surf_perfect_render_position();
    draw_surface_stretched(APP_SURF, _pos.x1, _pos.y1, _pos.w, _pos.h);
  } else {
    //draw surface with bilinear shader
    surface_draw_filtered(APP_SURF,_settings.is_fullscreen && _settings.enable_filtering)
  }
}

function display_draw_gui_end(){
  surface_reset_target();

  if(!surface_exists(global.display_data.gui_surf)) exit;

  display_set_gui_maximize();
  
  var _settings = global.settings;
  if(_settings.is_fullscreen && _settings.is_perfect_scale){
    var _pos = __display_calculate_app_surf_perfect_render_position();
    draw_surface_stretched(global.display_data.gui_surf, _pos.x1, _pos.y1, _pos.w, _pos.h);
  } else {
    surface_draw_filtered(global.display_data.gui_surf, _settings.is_fullscreen && _settings.enable_filtering)
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
    var _surfWidth = surface_get_width(APP_SURF), 
      _surfHeight = surface_get_height(APP_SURF), 
      _winWidth = window_get_width(), 
      _winHeight = window_get_height(); 
  var _scale = min(_winWidth / _surfWidth, _winHeight / _surfHeight);
  
  var _x = _winWidth / 2 - _surfWidth * _scale * .5;
  var _y = _winHeight / 2 - _surfHeight * _scale * .5;  
  var _x2 = _x + _surfWidth * _scale;
  var _y2 = _y + _surfHeight * _scale;
  return {
    x1: _x,
    y1: _y,
    x2: _x2,
    y2: _y2,
    w: _surfWidth* _scale,
    h: _surfHeight* _scale,
    scale: _scale 
  }
}

function __position_between(_val, _low, _up){
  //normalize values
  _up -= _low
  _val -= _low
  return _val / _up;
}
#endregion