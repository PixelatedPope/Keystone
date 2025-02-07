uniform float bitmap_width;
uniform float bitmap_height;
uniform float x_scale;
uniform float y_scale;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec2 sz = vec2(bitmap_width, bitmap_height);
    vec3 step = vec3(1.0 / x_scale, 1.0 / y_scale, 0);
    vec2 tex_pixel = sz * v_vTexcoord - step.xy / 2.0;

    vec2 corner = floor(tex_pixel) + 1.0;
    vec2 frac = min((corner - tex_pixel) * vec2(x_scale, y_scale), vec2(1.0, 1.0));

    vec4 c1 = texture2D(gm_BaseTexture, (floor(tex_pixel + step.zz) + 0.5) / sz, 3.);
    vec4 c2 = texture2D(gm_BaseTexture, (floor(tex_pixel + step.xz) + 0.5) / sz, 3.);
    vec4 c3 = texture2D(gm_BaseTexture, (floor(tex_pixel + step.zy) + 0.5) / sz, 3.);
    vec4 c4 = texture2D(gm_BaseTexture, (floor(tex_pixel + step.xy) + 0.5) / sz, 3.);

    c1 *= frac.x *frac.y;
    c2 *= (1.0 - frac.x) * frac.y;
    c3 *= frac.x * (1.0 - frac.y);
    c4 *= (1.0 - frac.x) * (1.0 - frac.y);

    gl_FragColor = v_vColour * (c1 + c2 + c3 + c4);
}