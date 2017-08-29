import VectorMath
import Foundation

public struct TimeRange {
  public let from, to: Scalar

  public init(from: Scalar, to: Scalar) {
    self.from = from
    self.to = to
  }
}

public struct Ray {
  public let point, direction: Vector4
  public let color: Color
  public let time: TimeRange
  
  public init(point: Vector4, direction: Vector4, color: Color, time: TimeRange = TimeRange(from:0, to:0)) {
    self.point = point
    self.direction = direction
    self.color = color
    self.time = time
  }
  
  public func pointAt(_ t: Scalar) -> Vector4 {
    return point + (direction * t)
  }
}

extension Collection where Iterator.Element == [Ray] {
  public func mapGrid<T>(_ mapFn: (Ray) -> T) -> [[T]] {
    return self.map{ (row: [Ray]) -> [T] in
      return row.map{mapFn($0)}
    }
  }
  
  public func mapGridWithIndex<T>(_ mapFn: @escaping (Ray, Int, Int) -> T) -> [[T]] {
    return self.enumerated().map{ (i: Int, row: [Ray]) -> [T] in
      return row.enumerated().map{ (j: Int, ray: Ray) -> T in
        return mapFn(ray, i, j)
      }
    }
  }
}

public struct Intersection {
  public let point: Vector4
  public let normal: Vector4
  public let material: Material
  public let ray: Ray
  public let time: TimeRange

  public init(point: Vector4, normal: Vector4, material: Material, ray: Ray, time: TimeRange) {
    self.point = point
    self.normal = normal
    self.material = material
    self.ray = ray
    self.time = time
  }
}
