import VectorMath
import RaytracerLib
import Foundation

public struct Transparent: Absorber {
  let tintColor: Color
  let refractionIndex: Scalar
  let fuzziness: Scalar

  public init(tintColor: Color, refractionIndex: Scalar, fuzziness: Scalar) {
    self.tintColor = tintColor
    self.refractionIndex = refractionIndex
    self.fuzziness = fuzziness
  }
  
  private func refract(_ i: Vector4, _ n: Vector4, _ ratio: Scalar) -> Vector4? {
    let descriminant = 1 - (pow(ratio, 2) * (1 - pow(i.dot(n), 2)))
    if descriminant > 0 && shouldRefract(i, n, ratio) {
      return i*ratio + n*(-sqrt(descriminant) - i.dot(n)*ratio)
    } else {
      return nil
    }
  }
  
  private func shouldRefract(_ i: Vector4, _ n: Vector4, _ ratio: Scalar) -> Bool {
    let n1, n2: Scalar
    if ratio == refractionIndex {
      (n1, n2) = (refractionIndex, 1)
    } else {
      (n1, n2) = (1, refractionIndex)
    }
    let cosTheta = -n.dot(i)
    let r0 = pow((n1-n2)/(n1+n2), 2)
    let probability = r0 + (1-r0)*pow(1 - cosTheta, 5)
    return rand(0,1) >= probability
  }
  
  public func scatter(_ intersection: Intersection) -> Ray {
    let i = intersection.ray.direction.normalized()
    let normal = intersection.normal.normalized()
    
    let ratio: Scalar
    let n: Vector4
    
    // If the ray is exiting the object
    if i.dot(normal) > 0 {
      n = normal * -1
      ratio = refractionIndex // n / n_0
    } else {
      n = normal
      ratio = 1/refractionIndex // n_0 / n
    }
    
    let bounced = refract(i, n, ratio) ?? i.reflectAround(n)
    return Ray(
      point: intersection.point,
      direction: bounced
        + (randomVector() * fuzziness),
      color: intersection.ray.color.multiply(tintColor),
      time: intersection.ray.time
    )
  }
}
