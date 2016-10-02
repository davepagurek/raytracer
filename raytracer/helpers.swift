import Foundation

func writePPM(file: String, pixels: [[Color]]) {
  try! ("P3\n" +
    "\(pixels.first?.count ?? 0) \(pixels.count)\n" +
    "255\n" +
    pixels.map { (row: [Color]) -> String in
      return row.map { (c: Color) -> String in
        return "\(Int(c.r*255)) \(Int(c.g*255)) \(Int(c.b*255))"
        }.joined(separator: "\n")
      }.joined(separator: "\n")
    ).write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
}

func rand(_ low: Scalar, _ high: Scalar) -> Scalar {
  return low + (high-low)*(Float(arc4random()) / Float(UINT32_MAX))
}

func lerp(_ from: Scalar, _ to: Scalar, _ amount: Scalar) -> Scalar {
  return ((1-amount)*from) + (amount*to)
}

func lerpColor(_ from: Color, _ to: Color, _ amount: Scalar) -> Color {
  return Color(
    r: ((1-amount)*from.r) + (amount*to.r),
    g: ((1-amount)*from.g) + (amount*to.g),
    b: ((1-amount)*from.b) + (amount*to.b)
  )
}

func blendColors(_ from: Color, _ to: Color) -> Color {
  return lerpColor(from, to, 0.5)
}

func lerpColor(_ from: Int, _ to: Int, _ amount: Scalar) -> Color {
  let fromColor = Color(from)
  let toColor = Color(to)
  return lerpColor(fromColor, toColor, amount)
}

func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

extension Array {
  func chunk(_ chunkSize: Int) -> Array<Array<Element>> {
    return stride(from: 0, to: self.count, by: chunkSize).map {
      Array(self[$0..<($0 + chunkSize)])
    }
  }
}
