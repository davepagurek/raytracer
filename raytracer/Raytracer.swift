//
//  Raytracer.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 9/30/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

struct Raytracer {
  let width: Scalar
  let height: Scalar
  let distance: Scalar
  let center: Vector4 = Point(x: 0, y: 0, z: 0)
  
  let objects: [Sphere]
  
  func rays(w: Int, h: Int) -> [[Ray]] {
    return (0..<h).map{ (y: Int) -> [Ray] in
      return (0..<w).map{ (x: Int) -> Ray in
        return Ray(
          point: center,
          direction: (Point(
            x: lerp(-width/2, width/2, Scalar(x)/Scalar(w)),
            y: lerp(-height/2, height/2, Scalar(y)/Scalar(h)),
            z: -distance
          ) - center)
        )
      }
    }
  }
  
  func render(w: Int, h: Int) -> [[Color]] {
    return rays(w: w, h: h).mapGrid{ (ray: Ray) -> Color in
      if objects.contains(where: { $0.intersectsRay(ray) }) {
        return Color(0x000000)
      } else {
        return ray.background()
      }
    }
  }
}
