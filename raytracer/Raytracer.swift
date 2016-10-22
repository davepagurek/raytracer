import Foundation

struct Raytracer {
  static let MAX_BOUNCES = 20
  
  let camera: Camera
  
  let surface: Surface
  let background: Background
  
  func rays(w: Int, h: Int, time: TimeRange) -> [[Ray]] {
    return (0..<h).map{ (y: Int) -> [Ray] in
      return (0..<w).map{ (x: Int) -> Ray in
        return camera.rayAt(
          x: Scalar(x)/Scalar(w-1),
          y: Scalar(y)/Scalar(h-1),
          time: time
        )
      }
    }
  }
  
  func rayColor(_ ray: Ray, bounce: Int = 0) -> Color {
    if bounce >= Raytracer.MAX_BOUNCES || ray.color.brightness() ~= 0 {
      return Color(0x000000)
    } else if let (bounced, reachedSource) = surface.bounce(ray) {
      if reachedSource {
        return bounced.color
      } else {
        return rayColor(bounced, bounce: bounce+1)
      }
    } else {
      return background.colorFrom(ray)
    }
  }
  
  func render(w: Int, h: Int, samples: Int = 1, time: TimeRange, callback: @escaping ([[Color]]) -> ()) {
    print("Running with \(samples) sample\(samples == 1 ? "" : "s")")
    return ([Int](1...samples)).concurrentMap(transform: { (sample: Int) -> [[Color]] in
      let image = self.rays(w: w*2, h: h*2, time: time)
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
