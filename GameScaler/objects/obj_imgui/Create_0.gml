/// @description
imgui_initialize()

imgui_row = function(_name, _x, _y) {
    ImGui.TableNextRow();
    ImGui.TableSetColumnIndex(0); ImGui.Text(_name);
    ImGui.TableSetColumnIndex(1); ImGui.Text(_x);
    ImGui.TableSetColumnIndex(2); ImGui.Text(_y);
};


windows = [];

debug_window = new ImguiWindow($"Test", { flags: ImGuiWindowFlags.AlwaysAutoResize})
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
      imgui_row("Window", $"{WIN_W}", $"{WIN_H}");
      imgui_row("App Surf", $"{APP_SURF_W}",$"{APP_SURF_H}");
      var _max = global.settings.resolution_max;
      if(_max == infinity){
        var _factor = min(DISP_W div BASE_W, DISP_H div BASE_H)
        imgui_row("Max App Surf", $"{BASE_W * _factor}",$"{BASE_H * _factor}");
      } else {
        imgui_row("Max App Surf", $"{BASE_W * _max}",$"{BASE_H * _max}");
      }
      imgui_row("Gui Fake", $"{GUI_W}",$"{GUI_H}");
      imgui_row("Gui Actual", $"{display_get_gui_width()}",$"{display_get_gui_height()}");
      ImGui.EndTable();
    }
    
    //Window Scale
    imgui_begin_disabled(global.settings.is_fullscreen)
    var _scales = []
    for(var _i = 0; _i < get_max_window_scale(global.settings.is_borderless); _i++)
      array_push(_scales, _i+1);
      
    var _index =  min(array_length(_scales) - 1, global.settings.window_scale - 1)
  
    var _new_index = imgui_combo($"Window Scale", _scales, _index)
    if (_index != _new_index){
      display_set_window_scale(_new_index + 1);
    }
    imgui_end_disabled()
    
    //Resolution
    var _res = ["Auto Max"]
    for(var _i = 0; _i < get_max_window_scale(false); _i++){
      array_push(_res, $"{BASE_W * (_i+1)} x {BASE_H * (_i+1)}");
    }
    var _index =  min(array_length(_res) - 1, global.settings.resolution)
  
    var _new_index = imgui_combo($"Resolution", _res, _index)
    if (_index != _new_index){
      display_set_resolution(_new_index);
    }
    
    //GUI Scale
    var _new_scale = imgui_slider_float("GUI Scale", global.settings.gui_scale, 1, display_get_current_window_scale())
    if(_new_scale != global.settings.gui_scale){
      display_set_gui_scale(_new_scale);  
    }
    
    //Fullscreen
    var _prev = global.settings.is_fullscreen
    var _checked = imgui_checkbox("Fullscreen", _prev)
    if(_prev != _checked){
      display_set_fullscreen(_checked)
    }
    
    //Borderless
    var _prev = global.settings.is_borderless
    var _checked = imgui_checkbox("Borderless", _prev)
    if(_prev != _checked){
      display_set_borderless(_checked)
    }
    
    //Perfect
    imgui_begin_disabled(!global.settings.is_fullscreen)
    var _prev = global.settings.is_perfect_scale
    var _checked = imgui_checkbox("Perfect Scaling", _prev)
    if(_prev != _checked){
      display_set_perfect_scaling(_checked)
    }
    
    //Fullscreen Mat    
    var _prev = global.settings.should_show_fullscreen_mat
    var _checked = imgui_checkbox("Fullscreen Mat", _prev)
    if(_prev != _checked){
      display_set_should_show_fullscreen_mat(_checked)
    }
    imgui_end_disabled()
    
    //Bilinear Filtering
    imgui_begin_disabled(!global.settings.is_fullscreen && !global.settings.is_perfect_scale)
    var _prev = global.settings.enable_filtering
    var _checked = imgui_checkbox("Bilinear Filter", _prev)
    if(_prev != _checked){
      display_set_filter_enabled(_checked)
    }
    imgui_end_disabled()
  })

array_push(windows, debug_window);
