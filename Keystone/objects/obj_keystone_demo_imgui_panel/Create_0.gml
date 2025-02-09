/// @description
imgui_initialize()

windows = [];

imgui_row = function(_name, _x, _y) {
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(0); ImGui.Text(_name);
    ImGui.TableSetColumnIndex(1); ImGui.Text(_x);
    ImGui.TableSetColumnIndex(2); ImGui.Text(_y);
};

debug_window = new ImguiWindow($"Keystone Control Panel", { flags: ImGuiWindowFlags.AlwaysAutoResize})
  .set_open(true)
  .set_constraints(300, 400, 300, 1000)
  .set_name_dynamic(function(){
    return debug_window.get_name() + $" (FPS: {fps})###test"
  })
  .on_update(function(){
    imgui_push_item_width(100)
    if (ImGui.BeginTable("Data", 3, ImGuiTableFlags.Borders)) {    
      ImGui.TableSetupColumn("");
      ImGui.TableSetupColumn("Width   ");
      ImGui.TableSetupColumn("Height");
      ImGui.TableHeadersRow();
      imgui_row("Window", $"{KEYSTONE_WIN_W}", $"{KEYSTONE_WIN_H}");
      imgui_row("App Surf", $"{KEYSTONE_APP_SURF_W}",$"{KEYSTONE_APP_SURF_H}");
      var _max = KEYSTONE_SETTINGS.resolution_max == KEYSTONE_AUTO_MAX ? keystone_get_max_element_scale() : KEYSTONE_SETTINGS.resolution_max;
      if(_max == infinity){
        var _factor = min(KEYSTONE_DISP_W div KEYSTONE_BASE_W, KEYSTONE_DISP_H div KEYSTONE_BASE_H)
        imgui_row("Max App Surf", $"{KEYSTONE_BASE_W * _factor}",$"{KEYSTONE_BASE_H * _factor}");
      } else {
        imgui_row("Max App Surf", $"{KEYSTONE_BASE_W * _max}",$"{KEYSTONE_BASE_H * _max}");
      }
      imgui_row("Gui Fake", $"{KEYSTONE_GUI_W}",$"{KEYSTONE_GUI_H}");
      imgui_row("Gui Actual", $"{display_get_gui_width()}",$"{display_get_gui_height()}");
      ImGui.EndTable();
    }
    imgui_text($"Is Exclusive Fullscreen: {window_get_fullscreen() ? "True" : "False"}")
    //Window Scale
    imgui_begin_disabled(KEYSTONE_SETTINGS.is_fullscreen)
    var _scales = ["Auto Max"]
    for(var _i = 1; _i <= keystone_get_max_window_scale(); _i++)
      array_push(_scales, _i);
      
    var _index =  min(array_length(_scales) - 1, KEYSTONE_SETTINGS.window_scale)
  
    var _new_index = imgui_combo($"Window Scale", _scales, _index)
    if (_index != _new_index){
      KEYSTONE_SETTINGS.window_scale = _new_index;
      keystone_update_window_scale();
    }
    imgui_end_disabled()
    
    //Resolution
    var _res = ["Auto Max"]
    for(var _i = 0; _i < keystone_get_max_element_scale(); _i++){
      array_push(_res, $"{KEYSTONE_BASE_W * (_i+1)} x {KEYSTONE_BASE_H * (_i+1)}");
    }
    var _index =  min(array_length(_res) - 1, KEYSTONE_SETTINGS.resolution)
  
    var _new_index = imgui_combo($"Resolution", _res, _index)
    if (_index != _new_index){
      KEYSTONE_SETTINGS.resolution = _new_index
      keystone_update_resolution();
    }
    
    //GUI Scale
    var _new_scale = imgui_slider_float("GUI Scale", min(KEYSTONE_SETTINGS.gui_scale,  keystone_get_max_element_scale()), 1, keystone_get_max_element_scale())
    if(_new_scale != KEYSTONE_SETTINGS.gui_scale){
      KEYSTONE_SETTINGS.gui_scale = _new_scale
      keystone_update_gui_scale();  
    }
    
    //Fullscreen
    var _prev = KEYSTONE_SETTINGS.is_fullscreen
    var _checked = imgui_checkbox("Fullscreen", _prev)
    if(_prev != _checked){
      KEYSTONE_SETTINGS.is_fullscreen = _checked;
      keystone_update_fullscreen()
    }
    
    //Borderless
    var _prev = KEYSTONE_SETTINGS.is_borderless
    var _checked = imgui_checkbox("Borderless", _prev)
    if(_prev != _checked){
      KEYSTONE_SETTINGS.is_borderless = _checked;
      window_set_showborder(!_checked)
      keystone_update_borderless();
    }
    
    //Perfect
    imgui_begin_disabled(keystone_is_inherently_perfectly_scaled())
    var _prev = KEYSTONE_SETTINGS.is_perfect_scale
    var _checked = imgui_checkbox("Perfect Scaling", _prev)
    if(_prev != _checked){
      KEYSTONE_SETTINGS.is_perfect_scale = _checked;
    }
    imgui_end_disabled()
    
    //Fullscreen Mat    
    var _prev = KEYSTONE_SETTINGS.should_show_fullscreen_mat
    var _checked = imgui_checkbox("Fullscreen Mat", _prev)
    if(_prev != _checked){
      KEYSTONE_SETTINGS.should_show_fullscreen_mat = _checked;
    }
    
    //Bilinear Filtering
    imgui_begin_disabled(keystone_is_inherently_perfectly_scaled() || KEYSTONE_SETTINGS.is_perfect_scale)
    var _prev = KEYSTONE_SETTINGS.enable_filtering
    var _checked = imgui_checkbox("Bilinear Filter", _prev)
    if(_prev != _checked){
      KEYSTONE_SETTINGS.enable_filtering = _checked;
    }
    imgui_end_disabled()
  })

array_push(windows, debug_window);
