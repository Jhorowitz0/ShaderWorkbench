uniform vec2 uResolution;  // Canvas size (width,height)
uniform vec2 uMouse;       // mouse position in screen pixels
uniform float uTime;       // Time in seconds since load
uniform float uScroll; //page scroll height

//input variables
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
uniform float uValue1;
uniform float uValue2;
uniform float uValue3;
uniform float uValue4;

#define PI 3.14159265359


void main() {
	vec2 st = gl_FragCoord.xy; // I work mostly at pixel scale for web elements
	
	float edge = distCircle(st,uResolution/2.0,uValue2*min(uResolution.x,uResolution.y));
	edge = smoothstep(0.,1.0,quadraticBezier(edge,vec2(1.0,1.0)));

	float noise = perlin3D(vec3(st*0.001,uTime*0.1));
	// noise = 0.5+0.5*noise;
	noise *= 5.0;

	float mouseDistort = clamp(distCircle(st,uResolution/2.,min(uResolution.x,uResolution.y)*0.45),0.,1.);
	mouseDistort = easeOut(mouseDistort) + 1.;
	float noise2 = noise * (0.5+0.5*perlin3D(vec3(st*0.005,(30.+uTime)*0.3)));
	noise2 /= mouseDistort;
	float noise3 = noise * (0.5+0.5*perlin3D(vec3(st*0.005,(60.+uTime)*0.3)));
	noise3 *= mouseDistort;
	// float noise4 = noise * (0.5+0.5*perlin3D(vec3(st*0.005,(90.+uTime)*0.3)));
	
	// noise = 0.5+0.5*noise;

	edge *= noise;

	float mouseEffect = clamp(distCircle(st,uMouse,100.0),0.0,1.0);
	mouseEffect *= 4.;

	float pattern = cubicPulse(subDivide(noise2,2.0),0.5,clamp(edge,0.03,0.1));
	float pattern2 = cubicPulse(subDivide(noise3,2.0),0.5,clamp(edge,0.03,0.1));
	// float pattern3 = cubicPulse(subDivide(noise4,10.0),0.5,clamp(edge,0.5,0.5));

	vec3 color = mix(uColor1,uColor2,st.x/uResolution.x);
	vec3 color2 = mix(uColor2,uColor1,st.x/uResolution.x);
	color = mix(color,color2,mouseDistort-1.);
	color = mix(color,uColor3,(mouseDistort-1.)*0.5);
	color = mix(color,uColor2,pattern);
	color = mix(color,uColor1,pattern2);
	// color = vec3(mouseDistort);
	// vec3 color = vec3((pattern+pattern2)*pattern3);

	gl_FragColor = vec4(color,1.0);
}
