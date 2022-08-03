uniform vec2 uResolution;  // Canvas size (width,height)
uniform vec2 uMouse;       // mouse position in screen pixels
uniform float uTime;       // Time in seconds since load
uniform float uScroll;

#define PI 3.14159265359

void main() {
	vec2 st = gl_FragCoord.xy/uResolution;

	gl_FragColor = vec4(0.5,0.0,1.0,1.0);
}
