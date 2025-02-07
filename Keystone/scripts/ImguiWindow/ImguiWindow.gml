enum WinType {
  window,
  child,
  popup,
  modal,
  tooltip,
  context
}

function ImguiWindow(_name, _config = {}) constructor {
  var _self = self
  
  // Public
  static set_name = function(_name){
    __.name = _name
    return self
  }
  static get_name = function(){
    return __.name
  }
  static set_name_dynamic = function(_func){
    __.dynamic_name = _func
    return self
  }
  
  static set_open = function(_open) {
    __.open = _open
    
    if is_open() __.open_callback() 
    else __.close_callback() 
      
    return self
  }
  
  static set_style = function(_style_func = undefined) {
    __.style = _style_func
    return self
  }
  
  static toggle_open = function(){
    set_open(!is_open())
    return self
  }
  
  static is_open = function() {
    if __.window_type = WinType.popup or __.window_type = WinType.modal
      return imgui_is_popup_open(get_name())
    return __.open
  }
  
  static get_x = function(){
    return __.x
  }
  static get_y = function(){
      return __.y
  }
  static get_width = function(){
      return __.w
  }
  static get_height = function(){
      return __.h
  }
  
  static set_pos = function(_x, _y){
    __.x = _x
    __.y = _y
    __.update_pos = true
    
    return self
  }
  
  static set_size = function(_w, _h){
    __.w = _w
    __.h = _h
    __.update_size = true
    
    return self
  }
  
  static set_constraints = function(_min_w, _min_h, _max_w, _max_h){
    __.min_w = _min_w
    __.max_w = _max_w
    __.min_h = _min_h
    __.max_h = _max_h
    __.update_constraints = true
    return self
  }
  
  // Private
  __ = {}
  with __ {
    name = _name
    dynamic_name = undefined
    
    window_type = _config[$ "window_type"] ?? WinType.window
    
    open  = _config[$ "open"] ?? true
    flags = _config[$ "flags"] ?? ImGuiWindowFlags.AlwaysAutoResize
    
    style = undefined
    
    x = _config[$ "x"] ?? 0
    y = _config[$ "y"] ?? 0
    w = _config[$ "w"] ?? 50
    h = _config[$ "h"] ?? 50
    
    min_w = undefined
    max_w = undefined
    min_h = undefined
    max_h = undefined
    
    update_pos = true
    update_size = true
    update_constraints = false
     

    // Event Callbacks
    update_callback = function(){}
    open_callback = function(){}
    close_callback = function(){}
    
    static __update_xywh = function(){
      __.x = imgui_get_window_x()	
      __.y = imgui_get_window_y()
      __.w = imgui_get_window_width()	
      __.h = imgui_get_window_height()
    }

  }
  
  // Events
  update = function(){  
    if !is_open() exit
      
    if __.update_pos {
      imgui_set_next_window_pos(get_x(), get_y())
      __.update_pos = false
    }
    
    if __.update_size {
      imgui_set_next_window_size(get_width(), get_height())
      __.update_size = false
    }
    if __.update_constraints  {
      imgui_set_next_window_size_constraints(__.min_w, __.min_h, __.max_w, __.max_h)
    }
    
    // ImGui Window 
    var _name = get_name()
    if __.dynamic_name != undefined
      _name = __.dynamic_name()
    
    if __.style != undefined 
      __.style()
    
    switch __.window_type {
      case WinType.window:
        if imgui_begin(_name,undefined, __.flags) {
          __update_xywh()
    
          
          __.update_callback()
          
          imgui_end()
        }
      break
      
      case WinType.modal: 
        if imgui_begin_popup_modal(_name){
          __update_xywh()
          imgui_text("Test")
          if imgui_button("OK")
          {
            //__confirm_callback()
            imgui_close_current_popup()
          }
        
          imgui_sameline()
          if imgui_button("Cancel")
          {
            //__cancel_callback()
            imgui_close_current_popup()
          }
          imgui_end_popup()
        }
      break
    }
  }
  
  on_update = function(_callback){
    __.update_callback = _callback
    return self
  }
  
  on_open = function(_callback){
    __.open_callback = _callback
    return self
  }
  
  on_close = function(_callback){
    __.close_callback(_callback)
    return self
  }

}


