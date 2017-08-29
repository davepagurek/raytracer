import VectorMath
import RaytracerLib

public struct Diffuse: Absorber {
  let color: Color
  let reflectivity: Scalar

  public init(color: Color, reflectivity: Scalar) {
    self.color = color
    self.reflectivity = reflectivity
  }
  
  public func scatter(_ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal + randomVector(),
      color: Color(
        r: reflectivity * (intersection.ray.color.r * color.r),
        g: reflectivity * (intersection.ray.color.g * color.g),
        b: reflectivity * (intersection.ray.color.b * color.b)
      ),
      time: intersection.ray.time
    )
  }
}
