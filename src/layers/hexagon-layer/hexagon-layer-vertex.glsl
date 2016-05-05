// Copyright (c) 2015 Uber Technologies, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/* fragment shader for the hexagon-layer */
#define SHADER_NAME hexagon-layer-vs

uniform float mercatorZoom;
uniform vec2 mercatorCenter;
uniform vec4 viewport; // viewport: [x, y, width, height]
#pragma glslify: mercatorProject = require(../../shaderlib/mercator-project)
#pragma glslify: mercatorProjectViewport = require(../../shaderlib/mercator-project-viewport)

attribute vec3 vertices;
attribute vec3 positions;
attribute vec3 colors;
attribute vec3 pickingColors;

uniform mat4 projectionMatrix;
uniform mat4 worldMatrix;

uniform float radius;
uniform float opacity;
uniform float angle;

uniform float renderPickingBuffer;
uniform vec3 selected;
varying vec4 vColor;

void main(void) {
  mat2 rotationMatrix = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
  vec3 rotatedVertices = vec3(rotationMatrix * vertices.xy * radius, vertices.z);
  vec4 verticesPositions = worldMatrix * vec4(rotatedVertices, 1.0);

  // vec2 pos = mercatorProjectViewport(positions.xy, mercatorZoom, mercatorCenter, viewport);
  vec2 pos = mercatorProject(positions.xy, mercatorZoom);

  vec4 centroidPositions = worldMatrix * vec4(pos.xy, positions.z, 0.0);
  vec3 p = centroidPositions.xyz + verticesPositions.xyz;
  gl_Position = projectionMatrix * vec4(p, 1.0);

  float alpha = pickingColors == selected ? 0.5 : opacity;
  vColor = vec4(mix(colors / 255., pickingColors / 255., renderPickingBuffer), alpha);
}