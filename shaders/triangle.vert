#version 330
attribute vec3 coord2d;
attribute float Move_Cam_X;
attribute float Move_Cam_Y;
attribute float Move_Cam_Z;

void main (void) {
  gl_Position = vec4 (coord2d, 2.0);
  gl_Position[0] = gl_Position[0] + Move_Cam_X;
  gl_Position[1] = gl_Position[1] + Move_Cam_Y;
  gl_Position[2] = gl_Position[2] + Move_Cam_Z;
}
