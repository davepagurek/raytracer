import VectorMath
import Foundation
import Cocoa

public func writePPM(file: String, pixels: [[Color]]) {
  try! ("P3\n" +
    "\(pixels.first?.count ?? 0) \(pixels.count)\n" +
    "255\n" +
    pixels.map { (row: [Color]) -> String in
      return row.map { (c: Color) -> String in
        return "\(Int(clip(c.r*255, 0, 255))) \(Int(clip(c.g*255, 0, 255))) \(Int(clip(c.b*255, 0, 255)))"
        }.joined(separator: "\n")
      }.joined(separator: "\n")
    ).write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
}

public struct PixelData {
  let a:UInt8 = 255
  let r, g, b: UInt8
}
public func writePNG(file: String, pixels: [[Color]]) {
  let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
  let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
  
  let bitsPerComponent:UInt = 8
  let bitsPerPixel:UInt = 32
  
  let width = pixels.first!.count
  let height = pixels.count
  var data = pixels.joined().map{PixelData(
    r: UInt8(clip($0.r*255, 0, 255)),
    g: UInt8(clip($0.g*255, 0, 255)),
    b: UInt8(clip($0.b*255, 0, 255))
  )}
  
  let providerRef = CGDataProvider(
    data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)
  )!
  
  let cgim = CGImage(
    width: width,
    height: height,
    bitsPerComponent: Int(bitsPerComponent),
    bitsPerPixel: Int(bitsPerPixel),
    bytesPerRow: width * Int(MemoryLayout<PixelData>.size),
    space: rgbColorSpace,
    bitmapInfo: bitmapInfo,
    provider: providerRef,
    decode: nil,
    shouldInterpolate: true,
    intent: CGColorRenderingIntent.defaultIntent
  )
  
  let image = NSImage(cgImage: cgim!, size: NSSize(width: width, height: height))
  (NSBitmapImageRep(data: image.tiffRepresentation!)!
    .representation(using: NSBitmapImageFileType.PNG, properties: [:])!
   as NSData).write(toFile: file, atomically: true)
}

public func rand(_ low: Scalar, _ high: Scalar) -> Scalar {
  return low + (high-low)*(Float(arc4random()) / Float(UINT32_MAX))
}

public func lerp(_ from: Scalar, _ to: Scalar, _ amount: Scalar) -> Scalar {
  return ((1-amount)*from) + (amount*to)
}

public func lerpColor(_ from: Color, _ to: Color, _ amount: Scalar) -> Color {
  return Color(
    r: ((1-amount)*from.r) + (amount*to.r),
    g: ((1-amount)*from.g) + (amount*to.g),
    b: ((1-amount)*from.b) + (amount*to.b)
  )
}

public func blendColors(_ from: Color, _ to: Color) -> Color {
  return lerpColor(from, to, 0.5)
}

public func lerpColor(_ from: Int, _ to: Int, _ amount: Scalar) -> Color {
  let fromColor = Color(from)
  let toColor = Color(to)
  return lerpColor(fromColor, toColor, amount)
}

public func clip(_ n: Scalar, _ low: Scalar, _ high: Scalar) -> Scalar {
  if (n < low) {
    return low
  }
  if (n > high) {
    return high
  }
  return n
}

public func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

extension Array {
  public func chunk(_ chunkSize: Int) -> Array<Array<Element>> {
    return stride(from: 0, to: self.count, by: chunkSize).map {
      Array(self[$0..<($0 + chunkSize)])
    }
  }
  
  public func concurrentMap<U>(transform: @escaping (Element) -> U, callback: @escaping (Array<U>) -> ()) {
    let queue = DispatchQueue(label: "concurrentMap", attributes: .concurrent)
    let group = DispatchGroup()
    
    let sync = DispatchQueue(label: "concurrentMapSync")

    var results = Array<U?>(repeating:nil, count: self.count)
    
    for (index, item) in enumerated() {
      queue.async(group: group) {
        let r = transform(item as Element)
        sync.sync() {
          results[index] = r
        }
      }
    }
    
    group.wait()
    callback(results.map{$0!})
  }
}

extension Vector4 {
  public func cosBetween(_ other: Vector4) -> Scalar {
    return Scalar(self.dot(other) / self.lengthSquared)
  }
  
  public func angleBetween(_ other: Vector4) -> Scalar {
    return Scalar(acos(Double(cosBetween(other))))
  }
  
  public func reflectAround(_ normal: Vector4) -> Vector4 {
    return self - (normal * 2 * self.dot(normal))
  }
}

public func randomVector() -> Vector4 {
  let vec = Vector(
    x: rand(-1, 1),
    y: rand(-1, 1),
    z: rand(-1, 1)
  )
  
  // Make sure it is in the unit sphere
  if vec.lengthSquared < 1 {
    return vec
  } else {
    return randomVector()
  }
}

public func randomVectorInDisc() -> Vector4 {
  let r = rand(0, 1)
  let theta = rand(0, Scalar(M_PI*2))
  return Vector(x: r*cos(theta), y: r*sin(theta), z: 0)
}

public func capHigh(_ n: Scalar, _ cap: Scalar) -> Scalar {
  return n > cap ? cap : n
}

public func capHigh(_ n: Int, _ cap: Int) -> Int {
  return n > cap ? cap : n
}

public func capLow(_ n: Scalar, _ cap: Scalar) -> Scalar {
  return n < cap ? cap : n
}

public func capLow(_ n: Int, _ cap: Int) -> Int {
  return n < cap ? cap : n
}
