function imgui_text_centered(_str,_font = undefined) {
  if _font != undefined imgui_push_font(_font)
  var _text_w = imgui_calc_text_width(_str)
  var _win_w = imgui_get_window_width()
  
  var _center_pos = (_win_w - _text_w)/2
  imgui_set_cursor_pos_x(_center_pos)
  
  imgui_text(_str)
  if _font != undefined imgui_pop_font(_font)
}





/// @func imgui_slider_percent()
/// @param {String} label The label to use for the slider.
/// @param {Real} value The input value.
/// @param {Real} from=[0] The minimum value.
/// @param {Real} to=[100] The maximum value.
/// @param {String} format=["%d"] The format string.
/// @param {Func} callback=[global ImGui callback] The callback to fire on change.
/// @param {Any} data=[undefined] The data to pass to the callback.
/// @returns {Real}
function imgui_slider_percent(_label, _value, _from = 0, _to = 100, _format = $"%d%%", _callback = function(){}, _data = undefined) {
    var _prev = _value;
    _value = (ImGui.SliderInt(_label, (_value * 100), _from, _to, _format, ImGuiSliderFlags.AlwaysClamp) / 100);
    if (_value != _prev) {
        _callback(_value, _data);
    }
    return _value;
}


function imgui_slider(_label, _value, _from, _to, _format = "%d", _callback = function(){}, _data = undefined) {
    var _prev = _value;
    _value = ImGui.SliderInt(_label, _value, _from, _to, _format, ImGuiSliderFlags.AlwaysClamp);
    if (_value != _prev) {
        _callback(_value, _data);
    }
    return _value;
}

function imgui_combo(_label, _items, _index, _flags = ImGuiComboFlags.None) {
    // Display the combo box
    if (ImGui.BeginCombo(_label, _items[_index], _flags)) {
        for (var _i = 0; _i < array_length(_items); _i++) {
            var _item = _items[_i];
            var _selected = (_i == _index);
            
            if (ImGui.Selectable(_item, _selected)) {
                _index = _i;
            }
        }
        ImGui.EndCombo();
    }
    
    return _index;
}

function imgui_button_centered(_str, _font = global.font_fredoka_big){
imgui_push_font(_font)
var _text_w = imgui_calc_text_width(_str)
var _w = imgui_get_window_width()
var _button_x = (_w - _text_w ) /2

imgui_set_cursor_pos_x(_button_x)

var _button = imgui_button(_str)
imgui_pop_font(1)
 return _button  

}


function imgui_header(_str){
  if live_call(_str) return live_result 
  imgui_push_style_var(ImGuiStyleVar.FramePadding, 4, 4)
  //var _width = imgui_get_content_region_avail_x()
  //var _text_width = imgui_calc_text_width(_str)
  //var _text_x = (_width - _text_width) * 0.5
  //imgui_set_cursor_pos_x(imgui_get_cursor_pos_x() + _text_x)
  imgui_push_style_var(ImGuiStyleVar.IndentSpacing, 0)
  imgui_tree_node_ex(_str, ImGuiTreeNodeFlags.Framed | ImGuiTreeNodeFlags.Leaf)
  imgui_pop_style_var(2)

    
  
}





function PopupModal(_name, _prompt = "", _confirm = function(){}, _cancel = function(){}) constructor{
  // Public
  
  // Private
  __confirm_callback = _confirm
  __cancel_callback  = _cancel
  
  // Events
  __name   = _name
  __prompt = _prompt
  
  
  update = function(){
    if imgui_begin_popup_modal(__name){
      
      imgui_text(__prompt)
      if imgui_button("OK")
      {
        __confirm_callback()
        imgui_close_current_popup()
      }
    
      imgui_sameline()
      if imgui_button("Cancel")
      {
        __cancel_callback()
        imgui_close_current_popup()
      }
      imgui_end_popup()
    }
  }
}