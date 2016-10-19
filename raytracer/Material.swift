//
//  Material.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/2/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

protocol Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

protocol Absorber: Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

extension Absorber {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(ray, intersection), false)
  }
}

protocol Emitter: Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool)
}

extension Emitter {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> (Ray, Bool) {
    return (scatter(ray, intersection), true)
  }
}

struct Diffuse: Absorber {
  let color: Color
  let reflectivity: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal + randomVector(),
      color: Color(
        r: reflectivity * (ray.color.r * color.r),
        g: reflectivity * (ray.color.g * color.g),
        b: reflectivity * (ray.color.b * color.b)
      )
    )
  }
}

struct Reflective: Absorber {
  let tintColor: Color
  let fuzziness: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (
        ray.direction.reflectAround(intersection.normal)
          + (randomVector() * fuzziness)
        ).normalized(),
      color: Color(
        r: tintColor.r * ray.color.r,
        g: tintColor.g * ray.color.g,
        b: tintColor.b * ray.color.b
      )
    )
  }
}

struct Transparent: Absorber {
  let tintColor: Color
  let refractionIndex: Scalar
  let fuzziness: Scalar
  
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
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    let i = ray.direction.normalized()
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
      color: Color(
        r: tintColor.r * ray.color.r,
        g: tintColor.g * ray.color.g,
        b: tintColor.b * ray.color.b
      )
    )
  }
}

struct LightEmitter: Emitter {
  let tintColor: Color
  let brightness: Scalar
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: intersection.normal,
      color: Color(
        r: tintColor.r * ray.color.r * brightness,
        g: tintColor.g * ray.color.g * brightness,
        b: tintColor.b * ray.color.b * brightness
      )
    )
  }
}
