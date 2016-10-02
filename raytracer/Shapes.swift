//
//  Shapes.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/1/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

typealias Face = [Vector4]

class Mesh {
  let faces: [Face]
  let transformations: [Matrix4]
  
  init(faces: [Face], transformations: [Matrix4] = []) {
    self.faces = faces
    self.transformations = transformations
  }
}

struct Sphere {
  let center: Vector4
  let radius: Scalar
  
  func intersectsRay(_ ray: Ray) -> Bool {
    // Quadratic formula
    let toCenter = ray.point - center
    let a = ray.direction.lengthSquared
    let b = toCenter.dot(ray.direction) * 2
    let c = toCenter.lengthSquared - radius*radius
    let descriminant = b*b - 4*a*c
    return descriminant > 0
  }
}
