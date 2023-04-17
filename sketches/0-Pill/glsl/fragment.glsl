uniform vec2 uResolution;  // Canvas size (width,height)
uniform vec2 uMouse;       // mouse position in screen pixels
uniform float uTime;       // Time in seconds since load
uniform float uScroll;    //page scroll height

//input variables
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uValue1;
uniform float uValue2;
uniform float uValue3;
uniform float uValue4;
uniform float uValue5;

#define PI 3.14159265359

void main() {
	vec2 st = gl_FragCoord.xy; // I work mostly at pixel scale for web elements

	float rectangle = rect(st,uResolution/2.0,vec2(uValue4*600.0+100.0,uValue3*500.0),uValue5*100.);
	
	st*=0.01;
	float noise = perlin3D(vec3(st,uTime*uValue2));
	noise = 0.5+0.5*noise;
	noise = subDivide(noise,10.0);
	noise = spike(noise,0.5);
	noise = step(noise,uValue1);
	noise*=rectangle;
	noise = clamp(noise,0.0,1.0);

	vec3 color = mix(uColor1,uColor2,noise);

	gl_FragColor = vec4(color,1.0);
}
