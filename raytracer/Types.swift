//
//  Point.swift
//  raytracer
//
//  Created by David Pagurek van Mossel on 9/30/16.
//  Copyright © 2016 David Pagurek van Mossel. All rights reserved.
//

import Foundation

typealias Face = [Vector4]

typealias Mesh = [Face]

func Point(x: Scalar, y: Scalar, z: Scalar) -> Vector4 {
  return Vector4(x, y, z, 1)
}

func Vector(x: Scalar, y: Scalar, z: Scalar) -> Vector4 {
  return Vector4(x, y, z, 0)
}

func Translate(x: Scalar, y: Scalar, z: Scalar) -> Matrix4 {
  return Matrix4(
    1, 0, 0, x,
    0, 1, 0, y,
    0, 0, 1, z,
    0, 0, 0, 1
  )
}

func ScaleOrigin(x: Scalar, y: Scalar, z: Scalar) -> Matrix4 {
  return Matrix4(
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  )
}

func RotateX(theta: Scalar) -> Matrix4 {
  return Matrix4(
    1, 0, 0, 0,
    0, cos(theta), -sin(theta), 0,
    0, sin(theta), cos(theta), 0,
    0, 0, 0, 1
  )
}

func RotateY(theta: Scalar) -> Matrix4 {
  return Matrix4(
    cos(theta), 0, sin(theta), 0,
    0, 1, 0, 0,
    -sin(theta), 0, cos(theta), 0,
    0, 0, 0, 1
  )
}

func RotateZ(theta: Scalar) -> Matrix4 {
  return Matrix4(
    cos(theta), -sin(theta), 0, 0,
    sin(theta), cos(theta), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  )
}
