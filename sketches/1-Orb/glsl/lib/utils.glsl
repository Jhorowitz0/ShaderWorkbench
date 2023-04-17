
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

