#version 300 es
// https://github.com/hyprwm/Hyprland/blob/v0.57.2/example/screenShader.frag
// Example blue light filter shader.

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

void main() {

    vec4 pixColor = texture(tex, v_texcoord);

    pixColor[2] *= 0.8;

    fragColor = pixColor;
}
