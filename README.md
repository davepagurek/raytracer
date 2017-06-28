# Raytracer

This is a Monte Carlo style 3d renderer (so the more samples you use, the closer to a perfect render it gets.) Here are some images I've rendered with it so far:

<img src="https://github.com/davepagurek/raytracer/blob/master/samples/lights_on_plane.png?raw=true" />

<img src="https://github.com/davepagurek/raytracer/blob/master/samples/motionblur.png?raw=true" />

<img src="https://github.com/davepagurek/raytracer/blob/master/samples/prisms.png?raw=true" />

<img src="https://github.com/davepagurek/raytracer/blob/master/samples/volume.png?raw=true" />

<img src="https://github.com/davepagurek/raytracer/blob/master/samples/subsurface_scattering.png?raw=true" />

## Features
- Shapes
  - Sphere
  - Plane
  - Triangle
    - Rectangle
    - Rectangular prism
  - Volumes of any other shape
- Materials
  - Diffuse
  - Reflective
  - Refractive
  - Light emitter
  - Volumes
  - Subsurface Scattering
- Lens blur
- Motion blur

### Antialiasing
Antialiasing works by first rendering an image, then applying a find edges filter, and then rerendering edge areas at a sub-pixel level.

Here is a detail of the original depth image:
<img src="https://github.com/davepagurek/raytracer/blob/master/samples/antialiasing/spheres_normal_detail.png" />

Edges are found by subtracting a blurred version from the original:
<img src="https://github.com/davepagurek/raytracer/blob/master/samples/antialiasing/spheres_edges_detail.png" />

Then, those areas are rerendered at double the pixel density to smooth the edges:
<img src="https://github.com/davepagurek/raytracer/blob/master/samples/antialiasing/sphered_antialiased_detail.png" />
