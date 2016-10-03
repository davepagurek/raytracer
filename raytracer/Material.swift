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
  
  private func randomVector() -> Vector4 {
    let vec = Vector(
      x: rand(-1, 1),
      y: rand(-1, 1),
      z: rand(-1, 1)
    )
    
    // Make sure it is in the unit sphere
    if vec.lengthSquared < 1 {
      return vec
    } else {
      return randomVector()
    }
  }
  
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
  
  func scatter(_ ray: Ray, _ intersection: Intersection) -> Ray {
    return Ray(
      point: intersection.point,
      direction: (ray.direction - intersection.normal * 2 * ray.direction.dot(intersection.normal)).normalized(),
      color: Color(
        r: tintColor.r * ray.color.r,
        g: tintColor.g * ray.color.g,
        b: tintColor.b * ray.color.b
      )
    )
  }
}
