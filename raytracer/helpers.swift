//
//  Helpers.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 10/1/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

func lerp(_ from: Scalar, _ to: Scalar, _ amount: Scalar) -> Scalar {
  return ((1-amount)*from) + (amount*to)
}

func lerpColor(_ from: Color, _ to: Color, _ amount: Scalar) -> Color {
  return Color(
    r: Int(((1-amount)*Scalar(from.r)) + (amount*Scalar(to.r))),
    g: Int(((1-amount)*Scalar(from.g)) + (amount*Scalar(to.g))),
    b: Int(((1-amount)*Scalar(from.b)) + (amount*Scalar(to.b)))
  )
}

func lerpColor(_ from: Int, _ to: Int, _ amount: Scalar) -> Color {
  let fromColor = Color(from)
  let toColor = Color(to)
  return lerpColor(fromColor, toColor, amount)
}

func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}
