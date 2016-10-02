import Foundation

let file = "test.ppm"

writePPM(
  file: file,
  pixels: Raytracer(
    width: 4,
    height: 2,
    distance: 1,
    surface: SurfaceList(surfaces: [
      Sphere(
        center: Point(x: 0, y: 0, z: -1),
        radius: 0.5,
        material: Diffuse(color: Color(0xFFFFFF), reflectivity: 0.5)
      ),
      Sphere(
        center: Point(x: 0, y: -100.5, z: -1),
        radius: 100,
        material: Diffuse(color: Color(0xFFFFFF), reflectivity: 0.5)
      )
    ]),
    background: Sky(top: Color(0x8AEBD3), bottom: Color(0xEBDC8A))
  ).render(
    w: 200,
    h: 100
  )
)

let _ = shell("open", file)

print("Done!")
