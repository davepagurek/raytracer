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
            y: lerp(height/2, -height/2, Scalar(y)/Scalar(h)),
            z: -distance
          ) - center)
        )
      }
    }
  }
  
  typealias Intersection = (object: Sphere, point: Vector4)
  func firstIntersection(_ ray: Ray) -> Intersection? {
    return objects.reduce(nil) { (prev: Intersection?, next: Sphere) -> Intersection? in
      if prev != nil {
        return prev
      } else if let intersection = next.intersectsRay(ray) {
        return (object: next, point: intersection)
      } else {
        return nil
      }
    }
  }
  
  func render(w: Int, h: Int) -> [[Color]] {
    return rays(w: w, h: h).mapGrid{ (ray: Ray) -> Color in
      if let intersection = firstIntersection(ray) {
        let normal = intersection.object.normalAt(intersection.point)
        return Color(
          r: Int(128 * (normal.x + 1)),
          g: Int(128 * (normal.y + 1)),
          b: Int(128 * (normal.z + 1))
        )
      } else {
        return ray.background()
      }
    }
  }
}
