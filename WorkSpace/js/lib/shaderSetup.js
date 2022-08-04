(function(global) {

  var canvas, gl, program,FRAMES = 0, mousePos, scrollPos;

  glUtils.SL.init({ callback:function() { main(); } }); //load shaders 

  function main() {
    // Register Callbacks
    window.addEventListener('resize', resizer); //call resizer on window resize

    // Get canvas element and check if WebGL enabled
    canvas = document.getElementById("glcanvas");
    gl = glUtils.checkWebGL(canvas);

    //handles scroll and mouse mmovement
    document.onmousemove = handleMouseMove;
    document.onscroll = handlePageScroll;

    //import help glsl files and append onto fragment shader
    var importedGLSL = "";
    importedGLSL += glUtils.SL.Shaders.v1.easing;
    importedGLSL += glUtils.SL.Shaders.v1.perlin3D;
    importedGLSL += glUtils.SL.Shaders.v1.utils;
    var fragmentShader_SRC =  "precision mediump float; \n \n" + importedGLSL + "\n \n" + glUtils.SL.Shaders.v1.fragment;

    console.log(fragmentShader_SRC);

    // Initialize the shaders and program
    var vertexShader = glUtils.getShader(gl, gl.VERTEX_SHADER, glUtils.SL.Shaders.v1.vertex),
        fragmentShader = glUtils.getShader(gl, gl.FRAGMENT_SHADER, fragmentShader_SRC);

    program = glUtils.createProgram(gl, vertexShader, fragmentShader);

    gl.useProgram(program);

    resizer();
    animate();
  }


  //called on mouse move, sets mouse position
  function handleMouseMove(event) {
      var dot, eventDoc, doc, body, pageX, pageY;

      event = event || window.event; // IE-ism

      // If pageX/Y aren't available and clientX/Y are,
      // calculate pageX/Y - logic taken from jQuery.
      // (This is to support old IE)
      if (event.pageX == null && event.clientX != null) {
          eventDoc = (event.target && event.target.ownerDocument) || document;
          doc = eventDoc.documentElement;
          body = eventDoc.body;

          event.pageX = event.clientX +
            (doc && doc.scrollLeft || body && body.scrollLeft || 0) -
            (doc && doc.clientLeft || body && body.clientLeft || 0);
          event.pageY = event.clientY +
            (doc && doc.scrollTop  || body && body.scrollTop  || 0) -
            (doc && doc.clientTop  || body && body.clientTop  || 0 );
      }


      mousePos = {
          x: event.pageX,
          y: event.clientY
      };
  }

  //called on page scroll
  function handlePageScroll(event){
    scrollPos = window.pageYOffset;
    // console.log(scrollPos,);
    const limit = Math.max(
      document.body.scrollHeight,
      document.body.offsetHeight,
      document.documentElement.clientHeight,
      document.documentElement.scrollHeight,
      document.documentElement.offsetHeight
    );
    scrollPos = window.pageYOffset/(limit-window.innerHeight);
  }

  //returns mouse pos
  function getMousePos(){
    if(mousePos) return mousePos;
    else return [0,0];
  }

  //updates frame value and draws shaders
  function animate() {
    tick = function() {
      draw();
      FRAMES++;
      req = requestAnimationFrame(tick);
    };
    tick();
  }

  // draw!
  function draw() {
    // Write the positions of vertices to a vertex shader
    var n = initBuffers(gl);
    if (n < 0) {
      console.log('Failed to set the positions of the vertices');
      return;
    }

    // Specify the color for clearing <canvas>
    gl.clearColor(1, 0, 1, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);


    setUniformVariables();

    // Draw the shader out across the canvas
    gl.drawArrays(gl.TRIANGLES, 0, n);
  }

//initializes the vertex points
  function initBuffers() {
    var vertices = new Float32Array([
      -1, -1,
      -1, +1,
      +1, +1,
      +1,  +1,
      +1, -1,
      -1, -1
    ]);
    // The number of vertices
    var n = 6;

    // Create a buffer object
    var vertexBuffer = gl.createBuffer();
    if (!vertexBuffer) {
      console.log('Failed to create the buffer object');
      return -1;
    }

    // Bind the buffer object to target
    // target: ARRAY_BUFFER, ELEMENT_ARRAY_BUFFER
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    // Write date into the buffer object
    // target, size
    // usage: STATIC_DRAW, STREAM_DRAW, DYNAMIC_DRAW
    gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);

    var aPosition = gl.getAttribLocation(program, 'aPosition');
    if (aPosition < 0) {
      console.log('Failed to get the storage location of aPosition');
      return -1;
    }

    gl.vertexAttribPointer(aPosition, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(aPosition);

    return n;
  }

  function HEXtoRGB(hex) {
    hex = hex.replace(/#/g, '');
    if (hex.length === 3) {
        hex = hex.split('').map(function (hex) {
            return hex + hex;
        }).join('');
    }
  // validate hex format
    var result = /^([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})[\da-z]{0,0}$/i.exec(hex);
    if (result) {
        var red = parseInt(result[1], 16);
        var green = parseInt(result[2], 16);
        var blue = parseInt(result[3], 16);

        return [red/255, green/255, blue/255];
    } else {
      // invalid color
        return null;
    }
  }

  //sets canvas size to window
  function resizer() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
    draw();
  }

  //sets uniform variables in fragment shader
  function setUniformVariables(){
    //pass in height and width
    glUtils.uniformFloat2(gl,program,"uResolution",canvas.width,canvas.height);
    //pass in time
    glUtils.uniformFloat1(gl,program,"uTime",FRAMES/100);
    //pass in page scroll normalized
    glUtils.uniformFloat1(gl,program,"uScroll",scrollPos);
    //pass in mousepos
    glUtils.uniformFloat2(gl,program,"uMouse",getMousePos().x,canvas.height-(getMousePos().y));

    var color1 = HEXtoRGB(document.getElementById("color1").value);
    glUtils.uniformFloat3(gl,program,"uColor1",color1[0],color1[1],color1[2]);

    var color2 = HEXtoRGB(document.getElementById("color2").value);
    glUtils.uniformFloat3(gl,program,"uColor2",color2[0],color2[1],color2[2]);

    var color3 = HEXtoRGB(document.getElementById("color3").value);
    glUtils.uniformFloat3(gl,program,"uColor3",color3[0],color3[1],color3[2]);

    var color4 = HEXtoRGB(document.getElementById("color4").value);
    glUtils.uniformFloat3(gl,program,"uColor4",color4[0],color4[1],color4[2]);

    glUtils.uniformFloat1(gl,program,"uValue1",document.getElementById('v1').value/100);
    glUtils.uniformFloat1(gl,program,"uValue2",document.getElementById('v2').value/100);
    glUtils.uniformFloat1(gl,program,"uValue3",document.getElementById('v3').value/100);
    glUtils.uniformFloat1(gl,program,"uValue4",document.getElementById('v4').value/100);
    
  }

})(window || this);
