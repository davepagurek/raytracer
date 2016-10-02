import Foundation

struct Color {
  let r, g, b: Scalar
}

extension Color {
  init(_ hex: Int) {
    self.init(
      r: Scalar((hex >> 16) & 0xFF)/255,
      g: Scalar((hex >> 8) & 0xFF)/255,
      b: Scalar(hex & 0xFF)/255
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
  
  func mapColors(_ mapFn: (Color) -> Color) -> [[Color]] {
    return self.map{ (row: [Color]) -> [Color] in
      return row.map{ (color: Color) -> Color in
        return mapFn(color)
      }
    }
  }
  
  func adjustGamma(_ gamma: Float) -> [[Color]] {
    return self.mapColors{ (color: Color) in
      return Color(
        r: pow(color.r, gamma),
        g: pow(color.g, gamma),
        b: pow(color.b, gamma)
      )
    }
  }
  
  func addColorsFrom(_ image: [[Color]]) -> [[Color]] {
    return zip(self, image).map{ rows -> [Color] in
     let (row1, row2) = rows
      return zip(row1, row2).map{ colors -> Color in
        let (c1, c2) = colors
        return Color(
          r: c1.r + c2.r,
          g: c1.g + c2.g,
          b: c1.b + c2.b
        )
      }
    }
  }
}

extension Collection where Iterator.Element == [[Color]] {
  func average() -> [[Color]] {
    let empty = self.first!.mapColors{_ in
      return Color(0x000000)
    }
    
    return self.reduce(empty, { (image, next: [[Color]]) -> [[Color]] in
      return image.addColorsFrom(next.mapColors{(color: Color) -> Color in
        return Color(
          r: color.r/Scalar(self.count.toIntMax()),
          g: color.g/Scalar(self.count.toIntMax()),
          b: color.b/Scalar(self.count.toIntMax())
        )
      })
    })
  }
}
