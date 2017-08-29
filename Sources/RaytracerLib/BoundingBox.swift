import VectorMath
import Foundation

public struct BoundingBox {
  let minCorner, maxCorner: Vector4
  
  public init(minCorner: Vector4, maxCorner: Vector4) {
    self.minCorner = minCorner
    self.maxCorner = maxCorner
  }
  
  public init(from: [BoundingBox]) {
    minCorner = Point(
      x: from.map{$0.minCorner.x}.min() ?? 0,
      y: from.map{$0.minCorner.y}.min() ?? 0,
      z: from.map{$0.minCorner.z}.min() ?? 0
    )
    maxCorner = Point(
      x: from.map{$0.maxCorner.x}.max() ?? 0,
      y: from.map{$0.maxCorner.y}.max() ?? 0,
      z: from.map{$0.maxCorner.z}.max() ?? 0
    )
  }
  
  public func boundingSphere() -> BoundingSphere {
    return BoundingSphere(
      center: minCorner + (maxCorner - minCorner)*0.5,
      radius: (maxCorner - minCorner).length / 2
    )
  }
}

public struct BoundingSphere {
  let center: Vector4
  let radius: Scalar

  public init(center: Vector4, radius: Scalar) {
    self.center = center
    self.radius = radius
  }
  
  public func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Bool {
    // Quadratic formula
    let toCenter = ray.point - center
    let a = ray.direction.lengthSquared
    let b = toCenter.dot(ray.direction) * 2
    let c = toCenter.lengthSquared - radius*radius
    let descriminant = b*b - 4*a*c
    if (descriminant < 0) {
      return false
    } else {
      let t = (-b - sqrt(descriminant)) / (2*a)
      
      return t >= min && t <= max
    }
  }
}
