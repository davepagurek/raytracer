import Foundation

struct Ray {
  let point, direction: Vector4
  let color: Color
  
  func pointAt(_ t: Scalar) -> Vector4 {
    return point + (direction * t)
  }
}

extension Collection where Iterator.Element == [Ray] {
  func mapGrid<T>(_ mapFn: (Ray) -> T) -> [[T]] {
    return self.map{ (row: [Ray]) -> [T] in
      return row.map{mapFn($0)}
    }
  }
}

struct Intersection {
  let point: Vector4
  let normal: Vector4
  let material: Material
  let time: Scalar = 0
}
