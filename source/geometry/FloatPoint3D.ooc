/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016-2017 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

import IntPoint3D
import IntVector3D
import FloatPoint2D
import FloatVector2D
import FloatVector3D
use base
use math

FloatPoint3D: cover {
	x, y, z: Float

	norm ::= (this x squared + this y squared + this z squared) sqrt()
	squaredNorm ::= (this x squared + this y squared + this z squared)
	isZero ::= this norm equals(0.0f)
	normalized ::= this isZero ? (this as This) : (this / this norm)
	azimuth ::= this y atan2(this x)
	absolute ::= This new(this x absolute, this y absolute, this z absolute)
	sign ::= This new(this x sign, this y sign, this z sign)
	isValid ::= (this x isNumber && this y isNumber && this z isNumber)
	elevation: Float { get {
		r := this norm
		if (r != 0.0f)
			r = (this z / r) clamp(-1.0f, 1.0f) acos()
		r
	}}

	init: func@ (=x, =y, =z)
	init: func@ ~cube (length: Float) { this x = this y = this z = length }
	init: func@ ~default { this init(0.0f, 0.0f, 0.0f) }
	init: func@ ~fromPoint2D (point: FloatPoint2D, z := 0.0f) { this init(point x, point y, z) }
	init: func@ ~fromVector2D (point: FloatVector2D, z := 0.0f) { this init(point x, point y, z) }
	pNorm: func (p: Float) -> Float {
		(this x abs() pow(p) + this y abs() pow(p) + this z abs() pow(p)) pow(1.0f / p)
	}
	scalarProduct: func (other: This) -> Float { this x * other x + this y * other y + this z * other z }
	vectorProduct: func (other: This) -> This { This new(this y * other z - other y * this z, -(this x * other z - other x * this z), this x * other y - other x * this y) }
	angle: func (other: This) -> Float {
		(this scalarProduct(other) / (this norm * other norm)) clamp(-1, 1) acos() * (this x * other y - this y * other x < 0 ? -1 : 1)
	}
	distance: func (other: This) -> Float { (this - other) norm }
	round: func -> This { This new(this x round(), this y round(), this z round()) }
	ceiling: func -> This { This new(this x ceil(), this y ceil(), this z ceil()) }
	floor: func -> This { This new(this x floor(), this y floor(), this z floor()) }
	minimum: func (ceiling: This) -> This { This new(this x minimum(ceiling x), this y minimum(ceiling y), this z minimum(ceiling z)) }
	maximum: func (floor: This) -> This { This new(this x maximum(floor x), this y maximum(floor y), this z maximum(floor z)) }
	clamp: func ~point (floor, ceiling: This) -> This { This new(this x clamp(floor x, ceiling x), this y clamp(floor y, ceiling y), this z clamp(floor z, ceiling z)) }
	clamp: func ~float (floor, ceiling: Float) -> This { This new(this x clamp(floor, ceiling), this y clamp(floor, ceiling), this z clamp(floor, ceiling)) }
	toIntPoint3D: func -> IntPoint3D { IntPoint3D new(this x as Int, this y as Int, this z as Int) }
	toIntVector3D: func -> IntVector3D { IntVector3D new(this x as Int, this y as Int, this z as Int) }
	toFloatVector3D: func -> FloatVector3D { FloatVector3D new(this x, this y, this z) }
	toString: func (decimals := 8) -> String { this x toString(decimals) >> ", " & this y toString(decimals) >> ", " & this z toString(decimals) }

	operator - -> This { This new(-this x, -this y, -this z) }
	operator + (other: This) -> This { This new(this x + other x, this y + other y, this z + other z) }
	operator - (other: This) -> This { This new(this x - other x, this y - other y, this z - other z) }
	operator * (other: This) -> This { This new(this x * other x, this y * other y, this z * other z) }
	operator / (other: This) -> This { This new(this x / other x, this y / other y, this z / other z) }
	operator < (other: This) -> Bool { this x < other x && this y < other y && this z < other z }
	operator > (other: This) -> Bool { this x > other x && this y > other y && this z > other z }
	operator <= (other: This) -> Bool { this x <= other x && this y <= other y && this z <= other z }
	operator >= (other: This) -> Bool { this x >= other x && this y >= other y && this z >= other z }
	operator == (other: This) -> Bool { this x equals(other x) && this y equals(other y) && this z equals(other z) }
	operator != (other: This) -> Bool { !(this == other) }
	operator + (other: FloatVector3D) -> This { This new(this x + other x, this y + other y, this z + other z) }
	operator - (other: FloatVector3D) -> This { This new(this x - other x, this y - other y, this z - other z) }
	operator * (other: FloatVector3D) -> This { This new(this x * other x, this y * other y, this z * other z) }
	operator / (other: FloatVector3D) -> This { This new(this x / other x, this y / other y, this z / other z) }
	operator * (other: Float) -> This { This new(this x * other, this y * other, this z * other) }
	operator / (other: Float) -> This { This new(this x / other, this y / other, this z / other) }

	spherical: static func (radius, azimuth, elevation: Float) -> This {
		This new(radius * (azimuth cos()) * (elevation sin()), radius * (azimuth sin()) * (elevation sin()), radius * (elevation cos()))
	}
	parse: static func (input: String) -> This {
		parts := input split(',')
		result := This new(parts[0] toFloat(), parts[1] toFloat(), parts[2] toFloat())
		parts free()
		result
	}
	mix: static func (a, b: This, ratio: Float) -> This {
		This new(Float mix(a x, b x, ratio), Float mix(a y, b y, ratio), Float mix(a z, b z, ratio))
	}
}
operator - (left: Float, right: FloatPoint3D) -> FloatPoint3D { FloatPoint3D new(left - right x, left - right y, left - right z) }
operator * (left: Float, right: FloatPoint3D) -> FloatPoint3D { FloatPoint3D new(left * right x, left * right y, left * right z) }
operator / (left: Float, right: FloatPoint3D) -> FloatPoint3D { FloatPoint3D new(left / right x, left / right y, left / right z) }
operator * (left: Int, right: FloatPoint3D) -> FloatPoint3D { FloatPoint3D new(left * right x, left * right y, left * right z) }
operator / (left: Int, right: FloatPoint3D) -> FloatPoint3D { FloatPoint3D new(left / right x, left / right y, left / right z) }

extend Cell<FloatPoint3D> {
	toString: func ~floatpoint3d -> String { (this val as FloatPoint3D) toString() }
}
