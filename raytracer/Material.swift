//
//  Material.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/2/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

protocol Material {
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray
}

struct Diffuse: Material {
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

struct Reflective: Material {
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

struct Transparent: Material {
  let tintColor: Color
  let refractionIndex: Scalar
  let fuzziness: Scalar
  
  private func refract(_ i: Vector4, _ n: Vector4, _ ratio: Scalar) -> Vector4? {
    let descriminant = 1 - (pow(ratio, 2) * (1 - pow(i.dot(n), 2)))
    if descriminant > 0 {
      return i*ratio + n*(-sqrt(descriminant) - i.dot(n)*ratio)
      //return (v - (n * v.dot(n))) * ratio - (n * sqrt(descriminant))
    } else {
      return nil
    }
  }
  
  /*private func schlick(_ cosine: Scalar) -> Scalar {
    let r0 = pow((1 - refractionIndex) / (1 + refractionIndex), 2)
    return (1 - r0)*pow(1 - cosine, 5) + r0
  }*/
  
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
  
  /*
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    let outwardNormal: Vector4
    let ratio: Scalar
    let cosine: Scalar
    if ray.direction.dot(intersection.normal) > 0 {
      outwardNormal = intersection.normal * -1
      ratio = refractionIndex
      cosine = refractionIndex * ray.direction.cosBetween(intersection.normal) * ray.direction.length
    } else {
      outwardNormal = intersection.normal
      ratio = 1/refractionIndex
      cosine = -1 * ray.direction.cosBetween(intersection.normal) * ray.direction.length
    }
    
    let scattered = refract(ray.direction, outwardNormal, ratio)
    let probability: Scalar
    if scattered != nil {
      probability = schlick(cosine)
    } else {
      probability = 1
    }
    
    if rand(0,1) < probability {
      return Ray(
        point: intersection.point,
        direction: (ray.direction
          - (intersection.normal * 2 * ray.direction.dot(intersection.normal)))
          + (randomVector() * fuzziness),
        color: Color(
          r: tintColor.r * ray.color.r,
          g: tintColor.g * ray.color.g,
          b: tintColor.b * ray.color.b
        )
      )
    } else {
      return Ray(
        point: intersection.point,
        direction: scattered! + (randomVector() * fuzziness),
        color: Color(
          r: tintColor.r * ray.color.r,
          g: tintColor.g * ray.color.g,
          b: tintColor.b * ray.color.b
        )
      )
    }
      /*  ?? (ray.direction
        - (intersection.normal * 2 * ray.direction.dot(intersection.normal)))
    return Ray(
      point: intersection.point,
      direction: scattered + (randomVector() * fuzziness),
      color: Color(
        r: tintColor.r * ray.color.r,
        g: tintColor.g * ray.color.g,
        b: tintColor.b * ray.color.b
      )
    ) */
  }*/
}
