import VectorMath
import RaytracerLib

public struct RandomScatterer: Absorber {
  let color: Color
  let reflectivity: Scalar
  
  public func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: randomVector(),
      color: Color(
        r: reflectivity * (intersection.ray.color.r * color.r),
        g: reflectivity * (intersection.ray.color.g * color.g),
        b: reflectivity * (intersection.ray.color.b * color.b)
      ),
      time: intersection.ray.time
    )
  }
}
