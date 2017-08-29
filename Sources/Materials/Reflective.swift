import VectorMath
import RaytracerLib

public struct Reflective: Absorber {
  let tintColor: Color
  let fuzziness: Scalar

  public init(tintColor: Color, fuzziness: Scalar) {
    self.tintColor = tintColor
    self.fuzziness = fuzziness
  }
  
  public func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (
        intersection.ray.direction.reflectAround(intersection.normal)
          + (randomVector() * fuzziness)
        ).normalized(),
      color: tintColor.multiply(intersection.ray.color),
      time: intersection.ray.time
    )
  }
}
