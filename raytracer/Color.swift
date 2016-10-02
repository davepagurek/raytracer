import Foundation

struct Color {
  let r, g, b: Int
}

extension Color {
  init(_ hex: Int) {
    self.init(
      r: (hex >> 16) & 0xFF,
      g: (hex >> 8) & 0xFF,
      b: hex & 0xFF
    )
  }
}

extension Collection where Iterator.Element == [Color] {
  func blend() -> [[Color]] {
    return self.map({ (row: [Color]) -> [Color] in
      return row.chunk(2).map{blendColors($0[0], $0[1])}
    }).chunk(2).map{(rows: [[Color]]) -> [Color] in
      return zip(rows[0], rows[1]).map{blendColors($0.0, $0.1)}
    }
  }
}
