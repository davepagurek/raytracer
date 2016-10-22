import Foundation

let file = "test.png"

var waiting = true

let origin = Point(x: 0, y: 3, z: 3)
let focus = Point(x: 2, y: 1, z: -3)
let aim = Point(x: 0, y: 1.3, z: -2)

Raytracer(
  camera: Camera(
    from: origin,
    to: aim,
    up: Vector(x: 0, y: 1, z: 0),
    vfov: 50,
    aspect: 2,
    aperture: 0.03,
    focalDistance: (focus - origin).length
  ),
  surface: SurfaceList(surfaces: [

    // Bouncing ball
    KeyframedSurface(
      surface: Sphere(
        center: Point(x: -1.4, y: 1, z: -2),
        radius: 1,
        material: Diffuse(color: Color(0x911146), reflectivity: 0.7)
      ),
      keyframes: TransformSteps(
        frames: [
          0: Translate(x: 0.2, y: 1.3, z: 0),
          0.7: Translate(x: 0, y: 0, z: 0),
          1: Translate(x: -0.15, y: 0.5, z: 0)
        ]
      )
    ),
    // Midair ball
    KeyframedSurface(
      surface: Sphere(
        center: Point(x: 1, y: 2, z: -4),
        radius: 1,
        material: Diffuse(color: Color(0xCF4A30), reflectivity: 0.7)
      ),
      keyframes: TransformSteps(
        frames: [
          0: Translate(x: -0.1, y: 0, z: 0),
          1: Translate(x: 0, y: 0.1, z: 0)
        ]
      )
    ),
    // Still ball
    KeyframedSurface(
      surface: Sphere(
        center: Point(x: 2, y: 1, z: -2.2),
        radius: 1,
        material: Diffuse(color: Color(0xED8C2B), reflectivity: 0.7)
      ),
      keyframes: TransformSteps(
        frames: [
          0: Translate(x: 0, y: 0, z: 0)
        ]
      )
    ),
    // Table
    InfinitePlane(
      anchor: Point(x: 0, y: 0, z: 0),
      normal: Vector(x: 0, y: 1, z: 0),
      material: Diffuse(color: Color(0xA6CFCE), reflectivity: 0.5)
    )
  ]),
  background: Sky(top: Color(0xFFFFFF), bottom: Color(0xA6D4E3))
).render(
  w: 800,
  h: 400,
  samples: 36,
  time: TimeRange(from: 0, to: 1)
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
