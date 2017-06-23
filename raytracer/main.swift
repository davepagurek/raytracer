import Foundation

let file = "test.png"

let origin = Point(x: 3, y: 0.3, z: -1)
let focus = Point(x: 3, y: 1.5, z: -3)
let aim = Point(x: 2, y: 1.5, z: -4)

Raytracer(
  camera: Camera(
    from: origin,
    to: aim,
    up: Vector(x: 0, y: 1, z: 0),
    vfov: 50,
    aspect: 2,
    aperture: 0.04,
    focalDistance: (focus - origin).length
  ),
  surface: UnboundedSurfaceList(surfaces: [
    
    UnboundedSurfaceList(surfaces: [
      Sphere(
        center: Point(x: 0, y: 0.5, z: -3),
        radius: 0.5,
        material: Transparent(
          tintColor: Color(0xDDDDDD),
          refractionIndex: 1.5,
          fuzziness: 0
        )
      ),
//      Sphere(
//        center: Point(x: -1, y: 1.8, z: -3),
//        radius: 0.3,
//        material: LightEmitter(tintColor: Color(0xFFE02A), brightness: 3)
//      ),
//      Sphere(
//        center: Point(x: 1, y: 0.3, z: -3),
//        radius: 0.3,
//        material: LightEmitter(tintColor: Color(0xFFE02A), brightness: 3)
//      ),
      Volume(
        surface: Sphere(
          center: Point(x: 3, y: 0.75, z: -3),
          radius: 0.7,
          material: Blurrer(tintColor: Color(0x824105), fuzziness: 1)
        ),
        density: 1.7,
        skin: Skin(
          material: Diffuse(color: Color(0xffe9dd), reflectivity: 0.6),
          probability: 0.8
        )
      ),
      Sphere(
        center: Point(x: -0.4, y: 0.8, z: -1.8),
        radius: 0.5,
        material: Diffuse(color: Color(0xBEDB39), reflectivity: 0.5)
      ),
      Sphere(
        center: Point(x: 2, y: 0.5, z: -5),
        radius: 0.5,
        material: Diffuse(color: Color(0x1F8A70), reflectivity: 0.5)
      ),
      Sphere(
        center: Point(x: -0.5, y: 2.3, z: -7),
        radius: 2.3,
        material: Reflective(tintColor: Color(0xCCCCDD), fuzziness: 0)
      )
    ]),
    
    InfinitePlane(
      anchor: Point(x: 0, y: 0, z: 0),
      normal: Vector(x: 0, y: 1, z: 0),
      material: Diffuse(color: Color(0xBBBBBB), reflectivity: 0.5)
    )
  ]),
  background: Sky(top: Color(r: 2, g: 1.5, b: 1.5), bottom: Color(r: 1, g: 0.9, b: 0.9))
).render(
  w: 400,
  h: 200,
  samples: 24,
  time: TimeRange(from: 0, to: 1)
) { (image: [[Color]]) in
  writePNG(
    file: file,
    pixels: image
  )
  
  let _ = shell("open", file)

  print("Done!")
}
