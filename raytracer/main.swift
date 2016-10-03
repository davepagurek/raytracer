import Foundation

let file = "test.ppm"

var waiting = true

Raytracer(
  width: 4,
  height: 2,
  distance: 1,
  surface: SurfaceList(surfaces: [
    Sphere(
      center: Point(x: -0.5, y: 0.75, z: -2),
      radius: 0.75,
      material: Diffuse(color: Color(0x3E97CF), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: 2, y: 0, z: -3),
      radius: 0.5,
      material: Diffuse(color: Color(0xD45F5F), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: 0, y: -100.5, z: -1),
      radius: 100,
      material: Diffuse(color: Color(0xFFFFFF), reflectivity: 0.5)
    )
  ]),
  background: Sky(top: Color(0xFFFFFF), bottom: Color(0x9999FF))
).render(
  w: 400,
  h: 200,
  samples: 20
) { (image: [[Color]]) in
  writePPM(
    file: file,
    pixels: image
  )
  
  let _ = shell("open", file)

  print("Done!")
  
  waiting = false
}

while waiting { }
