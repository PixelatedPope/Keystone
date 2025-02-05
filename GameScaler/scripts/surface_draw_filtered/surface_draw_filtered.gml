///@func surface_draw_filtered(surface)
function surface_draw_filtered(_surface = application_surface, _enable_filtering = true){
  
  var _surfWidth = surface_get_width(_surface), 
      _surfHeight = surface_get_height(_surface), 
      _winWidth = window_get_width(), 
      _winHeight = window_get_height(); 
  var _scale = min(_winWidth / _surfWidth, _winHeight / _surfHeight);
  
  var _x = _winWidth / 2 - _surfWidth * _scale * .5;
  var _y = _winHeight / 2 - _surfHeight * _scale * .5;
  
  
  if(_enable_filtering){
      if(_scale != 1){
        shader_set(sh_better_scaling_bilinear);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_bilinear, "bitmap_width"), _surfWidth);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_bilinear, "bitmap_height"), _surfHeight);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_bilinear, "x_scale"), _scale)
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_bilinear, "y_scale"), _scale); 
      }
  
      draw_surface_ext(_surface, _x, _y, _scale, _scale, 0, c_white, 1);
  
      if (_scale != 1) {
        shader_reset();
      }  
  } else{
    draw_surface_ext(_surface,  _x,  _y, _scale, _scale, 0, c_white, 1)
  }
}