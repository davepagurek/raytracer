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
      r: Int(reflectivity * Scalar(ray.color.r * color.r) / 255),
      g: Int(reflectivity * Scalar(ray.color.g * color.g) / 255),
      b: Int(reflectivity * Scalar(ray.color.b * color.b) / 255)
    )
  }
}

struct Sky: Material {
  let top, bottom: Color
  
  func reflectedColor(_ ray: Ray) -> Color {
    let t = 0.5 * (ray.direction.normalized().y + 1)
    let color = lerpColor(top, bottom, t)
    return Color(
      r: Int(Scalar(ray.color.r * color.r) / 255),
      g: Int(Scalar(ray.color.g * color.g) / 255),
      b: Int(Scalar(ray.color.b * color.b) / 255)
    )
  }
}
