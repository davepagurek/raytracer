import Foundation

let file = "test.png"

var waiting = true

let origin = Point(x: 3, y: 2, z: 3)
let focus = Point(x: 0, y: 2.5, z: -2)
let aim = Point(x: 2, y: 3, z: -2)

Raytracer(
  camera: Camera(
    from: origin,
    to: aim,
    up: Vector(x: 0, y: 1, z: 0),
    vfov: 35,
    aspect: 2,
    aperture: 0.04,
    focalDistance: (focus - origin).length
  ),
  surface: SurfaceList(surfaces: [
    
    // Moon
    Sphere(
      center: Point(x: 2, y: 5, z: -10),
      radius: 1.3,
      material: LightEmitter(tintColor: Color(0xE8E7CF), brightness: 3)
    ),

    // Buildings
    RectPrism(
      location: Point(x: 0, y: 2.5, z: -2),
      w: 1, h: 5, d: 1,
      material: Diffuse(color: Color(0x183E96), reflectivity: 0.5)
    ),
    RectPrism(
      location: Point(x: -1.5, y: 1.5, z: -2.5),
      w: 0.8, h: 3, d: 0.8,
      material: Diffuse(color: Color(0x183E96), reflectivity: 0.5)
    ),
    RectPrism(
      location: Point(x: -1, y: 2, z: -3.5),
      w: 0.8, h: 4, d: 0.8,
      material: Diffuse(color: Color(0x061C45), reflectivity: 0.5)
    ),
    RectPrism(
      location: Point(x: 2, y: 1.5, z: -3),
      w: 0.8, h: 3, d: 0.8,
      material: Diffuse(color: Color(0x061C45), reflectivity: 0.5)
    ),
    RectPrism(
      location: Point(x: 1, y: 2.5, z: -4),
      w: 1, h: 5, d: 1,
      material: Diffuse(color: Color(0x082E86), reflectivity: 0.5)
    ),
    SurfaceList(surfaces: (1...10).map{_ in
      let height = rand(2, 5)
      let width = rand(0.5, 0.8)
      return RectPrism(
        location: Point(x: rand(0.5, 8), y: height/2, z: rand(-3, -6)),
        w: width, h: height, d: width,
        material: Diffuse(
          color: lerpColor(Color(0x183E96), Color(0x061C45), rand(0,1)),
          reflectivity: 0.5
        )
      )
    }),
    
    /*TransformedSurface(
      surface: RectPrism(
        location: Point(x:0,y:0,z:0),
        w: 6, h: 1, d: 6,
        material: Diffuse(color: Color(0x333333), reflectivity: 0.5)
      ),
      transformation: Translate(x: -1, y: 0, z: -3)*RotateY(theta: Scalar(M_PI/4))
    ),
    
    TransformedSurface(
      surface: RectPrism(
        location: Point(x:0,y:0,z:0),
        w: 4, h: 0.5, d: 4,
        material: Diffuse(color: Color(0x333333), reflectivity: 0.5)
      ),
      transformation: Translate(x: 2, y: 0, z: -3)*RotateY(theta: Scalar(M_PI/6))
    ),*/
    
    // Water
    InfinitePlane(
      anchor: Point(x: 0, y: 0, z: 0),
      normal: Vector(x: 0, y: 1, z: 0),
      material: Reflective(tintColor: Color(0x428D96), fuzziness: 0.4)
    )
  ]),
  background: Sky(top: Color(0x063380), bottom: Color(0xED9B0C))
).render(
  w: 800,
  h: 400,
  samples: 16,
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
