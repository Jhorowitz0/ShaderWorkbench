
//given a uv, plots the x axis 
vec3 plot(vec2 st) {    
    float pct = smoothstep(0.02, 0.0, abs(st.y - st.x));
    float y = st.x;
    vec3 color = vec3(y);
    return (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);
}

//-----------------------------------------------BASIC EXPONENTIAL EASING----------------------------------------------------------
// Original curve functions by Golan Levin and Collaborators
// http://www.flong.com/texts/code/shapers_bez/

//basic exponential curve
float expEase(float x, float n){
	return pow(x,n);
}

float easeIn(float x){
	return pow(x,4.0);
}

float easeOut(float x){
	return pow(x,0.33);
}

float easeInOut(float x){
    return smoothstep(0.1,0.9,x);
}

float easeInOutThroughPoint(float x, float a, float b){
  float A = (1.0-b)/(1.0-a) - (b/a);
  float B = (A*(a*a)-b)/a;
  float y = A*(x*x) - B*(x);
  y = min(1.0,max(0.0,y)); 
  
  return smoothstep(0.0,1.0,y);
}

//---------------------------------------------CIRCLULAR EASING------------------------------------------------------------------
// Original curve functions by Golan Levin and Collaborators
// http://www.flong.com/texts/code/shapers_bez/

//ease in with a circular arc
float circularEaseIn (float x){
  float y = 1.0 - sqrt(1.0 - x*x);
  return y;
}

//ease out with a circular arc
float circularEaseOut (float x){
  float y = sqrt(1.0 - ((1.0 - x)*(1.0-x)));
  return y;
}

//two circle arcs combining to make a gradual transition from 0-1
float circularEaseInOut(float x){
  float n = 0.5;
  float y = 0.0;
  if (x<=n){
    y = sqrt(pow(n,2.0) - pow(x-n,2.0));
  } else {
    y = 1.0 - sqrt(pow(1.0-n,2.0) - pow(x-n,2.0));
  }
  return y;
}

//two circle arcs combining to make a sharp transition from 0-1
float circularSlideInOut(float x){
  float n = 0.5;
  float y = 0.0;
  if (x<=n){
    y = n - sqrt(n*n - x*x);
  } else {
    y = n+ sqrt(pow(1.0-n,2.0) - pow(x-1.0,2.0));
  }
  return y;
}

//two circle arcs combining to make a gradual transition at n 
float circularEaseInOutAtValue(float x, float n){
  float y = 0.0;
  if (x<=n){
    y = sqrt(pow(n,2.0) - pow(x-n,2.0));
  } else {
    y = 1.0 - sqrt(pow(1.0-n,2.0) - pow(x-n,2.0));
  }
  return y;
}

//two circle arcs combining to make a sharp transition at n
float circularSlideInOutAtValue(float x, float n){
  float y = 0.0;
  if (x<=n){
    y = n - sqrt(n*n - x*x);
  } else {
    y = n+ sqrt(pow(1.0-n,2.0) - pow(x-1.0,2.0));
  }
  return y;
}

//two elliptical arcs combining to ease through point a,b
float ellipseEaseInOutThroughValue(float x, float a, float b){
  float y = 0.0;
  if (x<=a){
    y = (b/a) * sqrt(pow(a,2.0) - pow(x-a,2.0));
  } else {
    y = 1.0- ((1.0-b)/(1.0-a))*sqrt(pow(1.0-a,2.0) - pow(x-a,2.0));
  }
  return y;
}

//two elliptical arcs combining abruptly through point a,b
float ellipseSlideInOutThroughValue(float x, float a, float b){
  float y = 0.0;
  if (x<=a){
    y = b * (1.0 - (sqrt(a*a - x*x)/a));
  } else {
    y = b + ((1.0-b)/(1.0-a))*sqrt(pow(1.0-a,2.0) - pow(x-1.0,2.0));
  }
  return y;
}

//----------------------------------------------BEZIER CURVES-------------------------------------------------
float quadraticBezier (float x, vec2 a){
  // adapted from BEZMATH.PS (1993)
  // by Don Lancaster, SYNERGETICS Inc. 
  // http://www.tinaja.com/text/bezmath.html

  float epsilon = 0.00001;
  a.x = clamp(a.x,0.0,1.0); 
  a.y = clamp(a.y,0.0,1.0); 
  if (a.x == 0.5){
    a += epsilon;
  }
  
  // solve t from x (an inverse operation)
  float om2a = 1.0 - 2.0 * a.x;
  float t = (sqrt(a.x*a.x + om2a*x) - a.x)/om2a;
  float y = (1.0-2.0*a.y)*(t*t) + (2.0*a.y)*t;
  return y;
}

// Helper functions:
float slopeFromT (float t, float A, float B, float C){
  float dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C); 
  return dtdx;
}
float xFromT (float t, float A, float B, float C, float D){
  float x = A*(t*t*t) + B*(t*t) + C*t + D;
  return x;
}
float yFromT (float t, float E, float F, float G, float H){
  float y = E*(t*t*t) + F*(t*t) + G*t + H;
  return y;
}
float B0 (float t){
  return (1.0-t)*(1.0-t)*(1.0-t);
}
float B1 (float t){
  return  3.0*t*(1.0-t)*(1.0-t);
}
float B2 (float t){
  return 3.0*t*t* (1.0-t);
}
float B3 (float t){
  return t*t*t;
}
float  findx (float t, float x0, float x1, float x2, float x3){
  return x0*B0(t) + x1*B1(t) + x2*B2(t) + x3*B3(t);
}
float  findy (float t, float y0, float y1, float y2, float y3){
  return y0*B0(t) + y1*B1(t) + y2*B2(t) + y3*B3(t);
}

float cubicBezier(float x, vec2 a, vec2 b){
  float y0a = 0.0; // initial y
  float x0a = 0.0; // initial x 
  float y1a = a.y;    // 1st influence y   
  float x1a = a.x;    // 1st influence x 
  float y2a = b.y;    // 2nd influence y
  float x2a = b.x;    // 2nd influence x
  float y3a = 1.0; // final y 
  float x3a = 1.0; // final x 

  float A =   x3a - 3.0*x2a + 3.0*x1a - x0a;
  float B = 3.0*x2a - 6.0*x1a + 3.0*x0a;
  float C = 3.0*x1a - 3.0*x0a;   
  float D =   x0a;

  float E =   y3a - 3.0*y2a + 3.0*y1a - y0a;    
  float F = 3.0*y2a - 6.0*y1a + 3.0*y0a;             
  float G = 3.0*y1a - 3.0*y0a;             
  float H =   y0a;

  // Solve for t given x (using Newton-Raphelson), then solve for y given t.
  // Assume for the first guess that t = x.
  float currentt = x;
  for (int i=0; i < 5; i++){
    float currentx = xFromT (currentt, A,B,C,D); 
    float currentslope = slopeFromT (currentt, A,B,C);
    currentt -= (currentx - x)*(currentslope);
  	currentt = clamp(currentt,0.0,1.0); 
  } 

  float y = yFromT (currentt,  E,F,G,H);
  return y;
}


float cubicBezierNearlyThroughTwoPoints(float x, vec2 a, vec2 b){

  float y = 0.0;
  float epsilon = 0.00001;
  float min_param_a = 0.0 + epsilon;
  float max_param_a = 1.0 - epsilon;
  float min_param_b = 0.0 + epsilon;
  float max_param_b = 1.0 - epsilon;
  a.x = max(min_param_a, min(max_param_a, a.x));
  a.y = max(min_param_b, min(max_param_b, a.y));

  float x0 = 0.0;  
  float y0 = 0.0;
  float x4 = a.x;  
  float y4 = a.y;
  float x5 = b.x;  
  float y5 = b.y;
  float x3 = 1.0;  
  float y3 = 1.0;
  float x1,y1,x2,y2; // to be solved.

  // arbitrary but reasonable 
  // t-values for interior control points
  float t1 = 0.3;
  float t2 = 0.7;

  float B0t1 = B0(t1);
  float B1t1 = B1(t1);
  float B2t1 = B2(t1);
  float B3t1 = B3(t1);
  float B0t2 = B0(t2);
  float B1t2 = B1(t2);
  float B2t2 = B2(t2);
  float B3t2 = B3(t2);

  float ccx = x4 - x0*B0t1 - x3*B3t1;
  float ccy = y4 - y0*B0t1 - y3*B3t1;
  float ffx = x5 - x0*B0t2 - x3*B3t2;
  float ffy = y5 - y0*B0t2 - y3*B3t2;

  x2 = (ccx - (ffx*B1t1)/B1t2) / (B2t1 - (B1t1*B2t2)/B1t2);
  y2 = (ccy - (ffy*B1t1)/B1t2) / (B2t1 - (B1t1*B2t2)/B1t2);
  x1 = (ccx - x2*B2t1) / B1t1;
  y1 = (ccy - y2*B2t1) / B1t1;

  x1 = max(0.0+epsilon, min(1.0-epsilon, x1));
  x2 = max(0.0+epsilon, min(1.0-epsilon, x2));

  y = cubicBezier (x, vec2(x1,y1), vec2(x2,y2));
  y = max(0.0, min(1.0, y));
  return y;
}

//---------------------------------------------EXPANDING AND CONTRACTING------------------------------------------

//takes a curve and contracts the center, 0 = linear, 1 = almost step()
float condenseCurve(float x, float a){
  a = max(0.1,pow(10.0*a,2.0));
  float A = 1.0 / (1.0 + exp(0.0 -((x-0.5)*a*2.0)));
  float B = 1.0 / (1.0 + exp(a));
  float C = 1.0 / (1.0 + exp(0.0-a)); 
  float y = (A-B)/(C-B);
  return y;
}

//takes a curve and expands the center, 0 = linear, 1 = 0.5
float expandCurve(float x, float n){
  float a = 0.5;
  float b = 0.5;
  n = pow(n*2.0,2.0);
  float p = 2.0*n + 1.0;
  float y = 0.0;
  if (x <= a){
    y = b - b*pow(1.0-x/a, p);
  } else {
    y = b + (1.0-b)*pow((x-a)/(1.0-a), p);
  }
  return y;
}

//takes a curve and expands the center, 0 = linear, 1 = 0.5
float expandCurveThroughPoint(float x, float a, float b, float n){
  n = pow(n*2.0,2.0);
  float p = 2.0*n + 1.0;
  float y = 0.0;
  if (x <= a){
    y = b - b*pow(1.0-x/a, p);
  } else {
    y = b + (1.0-b)*pow((x-a)/(1.0-a), p);
  }
  return y;
}

//---------------------------------------------------Iñigo Quiles Collection--------------------------------------------------------------
//  Functions modified from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm

// creates a short pulse, n is how fast it fades with 0 bing quickly and 1 being slowly
float impulse(float x, float n){
	float k = 10.-n*5.;
    float h = k*x;
    return h*exp(1.0-h);
}

//a pulse leaning towards 1. a=0 is a narrower pulse, a=1 is wider. 
float pulseCurve( float x, float a){
	float b = 1.;
	a = 3. + (1.-a)*10.0;
    float k = pow(a+b,a+b) / (pow(a,a)*pow(b,b));
    return k * pow( x, a ) * pow( 1.0-x, b );
}

// creates a pulse at x with a width w
float cubicPulse( float c, float x, float w ){
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

//creates a parabola with a width w. 0 being narrow, 1 being wide and v being the center
float parabola( float x, float w, float v){
	v = 1.-v;
	v-= 0.5;
	x+=v;
	w = 1.0-w;
	float k = 0.2 + pow(w*2.0,10.0);
    return pow( 4.0*x*(1.0-x), k );
}

//------------------------------------------------Misc-----------------------------------------
//creates a linear spike up to 1 at n
float spike(float x, float n){
	float y = 0.0;
	if(x<=n) y = (1.0/n) * x;
	else y = (1.0/(1.0-n)) * (1.0-x);
	return y;
}



