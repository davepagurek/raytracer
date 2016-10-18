import Foundation

let file = "test.png"

var waiting = true

let origin = Point(x: 0, y: 3, z: 0)
let focus = Point(x: 0, y: 0, z: -4)

Raytracer(
  camera: Camera(
    from: origin,
    to: focus,
    up: Vector(x: 0, y: 1, z: 0),
    vfov: 50,
    aspect: 2,
    aperture: 0.05,
    focalDistance: (Point(x: 0.9, y: 1.5, z: -3) - origin).length
  ),
  surface: SurfaceList(surfaces: [
    Sphere(
      center: Point(x: 0.9, y: 1.5, z: -3),
      radius: 0.5,
      material: Transparent(
        tintColor: Color(0xDDDDDD),
        refractionIndex: 1.5,
        fuzziness: 0
      )
    ),
    Sphere(
      center: Point(x: 1.2, y: 1.8, z: -1),
      radius: 0.5,
      material: Diffuse(color: Color(0x1F8A70), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: -1.5, y: 0.75, z: -3),
      radius: 0.5,
      material: Diffuse(color: Color(0x004358), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: -0.4, y: 0.8, z: -1.8),
      radius: 0.5,
      material: Diffuse(color: Color(0xBEDB39), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: 2, y: 0, z: -5),
      radius: 0.5,
      material: Diffuse(color: Color(0xFD7400), reflectivity: 0.5)
    ),
    Sphere(
      center: Point(x: -0.5, y: 1.75, z: -7),
      radius: 2.3,
      material: Reflective(tintColor: Color(0xCCCCDD), fuzziness: 0)
    ),
    Sphere(
      center: Point(x: 0, y: -100.5, z: -3),
      radius: 100,
      material: Diffuse(color: Color(0xE8FFFC), reflectivity: 0.5)
    )
  ]),
  background: Sky(top: Color(0xFFFFFF), bottom: Color(0x9999FF))
).render(
  w: 400,
  h: 200,
  samples: 40
) { (image: [[Color]]) in
  writePNG(
    file: file,
    pixels: image
  )
  
  let _ = shell("open", file)

  print("Done!")
  
  waiting = false
}

while waiting { }
