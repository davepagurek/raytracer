import Foundation

struct TransformedSurface: Surface {
  let surface: Surface
  let transformation: Matrix4
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
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
        time: ray.time
      )
    } else {
      return nil
    }
  }
}

struct KeyframedSurface: Surface {
  let surface: Surface
  let keyframes: TransformSteps
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
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
        time: ray.time
      )
    } else {
      return nil
    }
  }
}
