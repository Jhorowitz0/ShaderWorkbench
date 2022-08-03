uniform vec2 uResolution;  // Canvas size (width,height)
uniform vec2 uMouse;       // mouse position in screen pixels
uniform float uTime;       // Time in seconds since load
uniform float uScroll;

#define PI 3.14159265359

void main() {
	vec2 st = gl_FragCoord.xy/uResolution; //Normalize the fragcoord between 0 and 1

	vec3 color = vec3(0.5,0.0,1.0);
 
	gl_FragColor = vec4(color,1.0); 
}
