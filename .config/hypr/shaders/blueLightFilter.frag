// https://github.com/hyprwm/Hyprland/blob/7b020ffa84e64d0734709b2489e1da5463689e61/example/screenShader.frag
// Example blue light filter shader.

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {

    vec4 pixColor = texture2D(tex, v_texcoord);

    pixColor[2] *= 0.8;

    gl_FragColor = pixColor;
}
