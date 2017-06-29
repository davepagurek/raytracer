import Foundation

struct TimeRange {
  let from, to: Scalar
}

struct Ray {
  let point, direction: Vector4
  let color: Color
  let time: TimeRange
  
  init(point: Vector4, direction: Vector4, color: Color, time: TimeRange = TimeRange(from:0, to:0)) {
    self.point = point
    self.direction = direction
    self.color = color
    self.time = time
  }
  
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
  
  func mapGridWithIndex<T>(_ mapFn: @escaping (Ray, Int, Int) -> T) -> [[T]] {
    return self.enumerated().map{ (i: Int, row: [Ray]) -> [T] in
      return row.enumerated().map{ (j: Int, ray: Ray) -> T in
        return mapFn(ray, i, j)
      }
    }
  }
}

struct Intersection {
  let point: Vector4
  let normal: Vector4
  let material: Material
  let ray: Ray
  let time: TimeRange
}
