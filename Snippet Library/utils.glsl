
//given a linear gradient x, divides it into n  smaller gradients 
float subDivide(float x, float n){
	float y = mod(x,1.0/n);
	y *= n;
	return y;
}

//---------------------------------SHAPES----------------------
//draw a circle with size r at pos
float circle(vec2 st,vec2 pos,float r){
    float dist = 1.0-distance(st,pos);
    float result = dist;
    result -= 1.0-r;
    result *= (1.0/r);
    return step(0.0,result);
}

//draw a white linear falloff at pos to r
float distCircle(vec2 st, vec2 pos, float r){
    float dist = 1.0-distance(st,pos);
    float result = dist;
    result -= 1.0-r;
    result *= (1.0/r);
    return result;
}

// draw rectangle frame with rounded edges
float rect(vec2 st, vec2 pos, vec2 size, float radius)
{
  radius = min(min(size.x,size.y),radius);
  float d = 1.0-length(max(abs(st - pos),size) - size);
  vec2 rectpos = abs(st-pos);
  if(rectpos.x > size.x-radius && rectpos.y > size.y-radius) d = 0.0;
  d += circle(st,(pos+size-vec2(radius)),radius);
  d += circle(st,(pos-size+vec2(radius)),radius);
  d += circle(st,vec2((pos.x-size.x+radius),(pos.y+size.y-radius)),radius);
  d += circle(st,vec2((pos.x+size.x-radius),(pos.y-size.y+radius)),radius);
  return clamp(0.0,1.0,d);
}

//------------------------------Common Noise Functions----------------------

// Modulo 7 without a division
vec3 mod7(vec3 x) {
  return x - floor(x * (1.0 / 7.0)) * 7.0;
}

// Modulo 7 without a division
vec4 mod7(vec4 x) {
  return x - floor(x * (1.0 / 7.0)) * 7.0;
}

float mod289(float x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0; 
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 mod289(vec3 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float permute(float x) {
     return mod289(((x*34.0)+10.0)*x);
}

// Permutation polynomial: (34x^2 + 6x) mod 289
vec3 permute(vec3 x) {
  return mod289((34.0 * x + 10.0) * x);
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+10.0)*x);
}

float taylorInvSqrt(float r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec3 fade(vec3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

vec4 grad4(float j, vec4 ip){
  const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
  vec4 p,s;

  p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
  p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
  s = vec4(lessThan(p, vec4(0.0)));
  p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

  return p;
}

