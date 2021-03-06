import VectorMath
import RaytracerLib
import Foundation

public struct TransformedSurface: Surface {
  let surface: Surface
  let transformation: Matrix4
  
  public func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    if let intersection = surface.intersectsRay(
      Ray(
        point: transformation.inverse * ray.point,
        direction: transformation.inverse * ray.direction,
        color: ray.color
      ),
      min: min,
      max: max
    ) {
      return Intersection(
        point: transformation * intersection.point,
        normal: transformation * intersection.normal,
        material: intersection.material,
        ray: ray,
        time: ray.time
      )
    } else {
      return nil
    }
  }
}

public struct KeyframedSurface: Surface {
  let surface: Surface
  let keyframes: TransformSteps
  
  public func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    let transformation = keyframes.at(rand(ray.time.from, ray.time.to))
    if let intersection = surface.intersectsRay(
      Ray(
        point: transformation.inverse * ray.point,
        direction: transformation.inverse * ray.direction,
        color: ray.color
      ),
      min: min,
      max: max
      ) {
      return Intersection(
        point: transformation * intersection.point,
        normal: transformation * intersection.normal,
        material: intersection.material,
        ray: ray,
        time: ray.time
      )
    } else {
      return nil
    }
  }
}
