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
  
  private func randomVector() -> Vector4 {
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
  
  func bounce(_ ray: Ray) -> Ray {
    return Ray(
      point: point,
      direction: normal + randomVector(),
      color: material.reflectedColor(ray)
    )
  }
}
