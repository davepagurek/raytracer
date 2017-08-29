import VectorMath
import Foundation

public struct Raytracer {
  static let MAX_BOUNCES = 20
  
  let camera: Camera
  let surface: Surface
  let background: Background

  public init(camera: Camera, surface: Surface, background: Background) {
    self.camera = camera
    self.surface = surface
    self.background = background
  }
  
  public func rays(w: Int, h: Int, time: TimeRange) -> [[Ray]] {
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
  
  public func rayColor(_ ray: Ray, bounce: Int = 0) -> Color {
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
  
  public func render(w: Int, h: Int, samples: Int = 1, time: TimeRange, callback: @escaping ([[Color]]) -> ()) {
    print("Running with \(samples) sample\(samples == 1 ? "" : "s")")
    return ([Int](1...samples)).concurrentMap(transform: { (sample: Int) -> [[Color]] in
      let image = self.rays(w: w, h: h, time: time)
        .mapGrid{ self.rayColor($0) }
      
      let edges = image
        .gaussianBlurred()
        .addColorsFrom(image.mapColors{$0.scale(-1)})
        .mapColors({$0.scale(5).clipped()})
      
      let antialiased = self.rays(w: w*2, h: h*2, time: time)
        .mapGridWithIndex { (ray: Ray, y: Int, x: Int) -> Color in
          let sourceX = (x/2) // Ints round down by default
          let sourceY = (y/2)
          
          if edges[sourceY][sourceX].brightness() < 0.2 {
            return image[sourceY][sourceX]
          } else {
            return self.rayColor(ray)
          }
        }
        .blend()
      
      let thread = Thread.current
      let threadNumber = thread.value(forKeyPath: "private.seqNum") ?? 0
      print("Finished sample \(sample) in thread \(threadNumber)")
      
      return antialiased
      
    }, callback: { (images: [[[Color]]]) in
        callback(images.average().adjustGamma(0.5))
    })
  }
}
