/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016-2017 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

import GLQuad

GLRenderer: abstract class {
	_quad: GLQuad
	drawQuad: abstract func
	drawLines: abstract func (positions: Float*, count: Int, dimensions: Int, lineWidth: Float)
	drawPoints: abstract func (positions: Float*, count: Int, dimensions: Int)
}
