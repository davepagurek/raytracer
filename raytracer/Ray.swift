import Foundation

struct Ray {
  let point, direction: Vector4
  
  func pointAt(_ t: Scalar) -> Vector4 {
    return point + (direction * t)
  }
  
  func background() -> Color {
    let t = 0.5 * (direction.normalized().y + 1)
    return lerpColor(0x8AEBD3, 0xEBDC8A, t);
  }
}

extension Collection where Iterator.Element == [Ray] {
  func mapGrid<T>(_ mapFn: (Ray) -> T) -> [[T]] {
    return self.map{ (row: [Ray]) -> [T] in
      return row.map{mapFn($0)}
    }
  }
}
