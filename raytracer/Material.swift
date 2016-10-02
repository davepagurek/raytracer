//
//  Material.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/2/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

protocol Material {
  func reflectedColor(_ ray: Ray) -> Color
}

struct Diffuse: Material {
  let color: Color
  let reflectivity: Scalar
  
  func reflectedColor(_ ray: Ray) -> Color {
    return Color(
      r: reflectivity * (ray.color.r * color.r),
      g: reflectivity * (ray.color.g * color.g),
      b: reflectivity * (ray.color.b * color.b)
    )
  }
}

struct Sky: Material {
  let top, bottom: Color
  
  func reflectedColor(_ ray: Ray) -> Color {
    let t = 0.5 * (ray.direction.normalized().y + 1)
    let color = lerpColor(bottom, top, t)
    return Color(
      r: ray.color.r * color.r,
      g: ray.color.g * color.g,
      b: ray.color.b * color.b
    )
  }
}
