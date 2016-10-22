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
        material: intersection.material
      )
    } else {
      return nil
    }
  }
}

struct BlurTransformedSurface: Surface {
  let surface: Surface
  let from, to: Matrix4
  
  func intersectsRay(_ ray: Ray, min: Scalar, max: Scalar) -> Intersection? {
    let transformation = from.blend(to, rand(0, 1))
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
        material: intersection.material
      )
    } else {
      return nil
    }
  }
}
