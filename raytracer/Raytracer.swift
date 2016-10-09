import Foundation

struct Raytracer {
  static let MAX_BOUNCES = 20
  
  let width: Scalar
  let height: Scalar
  let distance: Scalar
  let center: Vector4 = Point(x: 0, y: 0, z: 0)
  
  let surface: Surface
  let background: Source
  
  func rays(w: Int, h: Int) -> [[Ray]] {
    return (0..<h).map{ (y: Int) -> [Ray] in
      return (0..<w).map{ (x: Int) -> Ray in
        return Ray(
          point: center,
          direction: (Point(
            x: lerp(-width/2, width/2, Scalar(x)/Scalar(w)),
            y: lerp(height/2, -height/2, Scalar(y)/Scalar(h)),
            z: -distance
            ) - center),
          color: Color(0xFFFFFF)
        )
      }
    }
  }
  
  func rayColor(_ ray: Ray, bounce: Int = 0) -> Color {
    if ray.color.brightness() ~= 0 {
      return ray.color
    } else if bounce < Raytracer.MAX_BOUNCES, let bounced = surface.bounce(ray) {
      return rayColor(bounced, bounce: bounce+1)
    } else {
      return background.colorFrom(ray)
    }
  }
  
  func render(w: Int, h: Int, samples: Int = 1, callback: @escaping ([[Color]]) -> ()) {
    print("Running with \(samples) sample\(samples == 1 ? "" : "s")")
    return ([Int](1...samples)).concurrentMap(transform: { (sample: Int) -> [[Color]] in
      let image = self.rays(w: w*2, h: h*2)
        .mapGrid{ self.rayColor($0) }
        .blend()
      
      let thread = Thread.current
      let threadNumber = thread.value(forKeyPath: "private.seqNum") ?? 0
      print("Finished sample \(sample) in thread \(threadNumber)")
      
      return image
      
    }, callback: { (images: [[[Color]]]) in
        callback(images.average().adjustGamma(0.5))
    })
  }
}
