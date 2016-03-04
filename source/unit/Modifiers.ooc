/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

import Constraints

ExpectModifier: abstract class {
	parent: This = null
	child: This = null
	init: func ~parent (=parent)
	free: override func {
		if (this child) {
			if (this child parent == this)
				this child parent = null
			this child free()
		}
		if (this parent) {
			if (this parent child == this)
				this parent child = null
			this parent free()
		}
		super()
	}
	verify: func ~parent (value: Object, _child: This = null) -> Bool {
		this child = _child
		this parent != null ? this parent verify(value, this): this test(value)
	}
	test: virtual func (value: Object) -> Bool { this testChild(value) }
	testChild: func (value: Object) -> Bool { this child != null && this child test(value) }
}

EqualModifier: class extends ExpectModifier {
	comparisonType: ComparisonType
	withinType: ComparisonType
	init: func ~parent (parent: ExpectModifier, type := ComparisonType Equal) {
		super(parent)
		this comparisonType = type
		this withinType = type == ComparisonType Equal ? ComparisonType Within : ComparisonType NotWithin
	}
	to: func ~object (correct: Object) -> CompareConstraint {
		f := func (value, c: Object) -> Bool {
			match c {
				case s: String => s == value as String
				case => c == value
			}
		}
		CompareConstraint new(this, correct, f, this comparisonType)
	}
	to: func ~char (correct: Char) -> CompareConstraint {
		f := func (value, c: Cell<Char>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Char> new(correct), f, this comparisonType)
	}
	to: func ~text (correct: Text) -> CompareConstraint {
		f := func (value, c: Cell<Text>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Text> new(correct), f, this comparisonType)
	}
	to: func ~boolean (correct: Bool) -> CompareConstraint {
		f := func (value, c: Cell<Bool>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Bool> new(correct), f, this comparisonType)
	}
	to: func ~int (correct: Int) -> CompareConstraint {
		f := func (value, c: Cell<Int>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Int> new(correct), f, this comparisonType)
	}
	to: func ~uint (correct: UInt) -> CompareConstraint {
		f := func (value, c: Cell<UInt>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<UInt> new(correct), f, this comparisonType)
	}
	to: func ~uint8 (correct: Byte) -> CompareConstraint {
		f := func (value, c: Cell<Byte>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Byte> new(correct), f, this comparisonType)
	}
	to: func ~long (correct: Long) -> CompareConstraint {
		f := func (value, c: Cell<Long>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<Long> new(correct), f, this comparisonType)
	}
	to: func ~ulong (correct: ULong) -> CompareConstraint {
		f := func (value, c: Cell<ULong>) -> Bool { value get() == c get() }
		CompareConstraint new(this, Cell<ULong> new(correct), f, this comparisonType)
	}
	to: func ~float (correct: Float) -> CompareWithinConstraint {
		f := func (value, c: Cell<Float>) -> Bool { value get() equals(c get()) }
		CompareWithinConstraint new(this, Cell<Float> new(correct), f, this withinType)
	}
	to: func ~double (correct: Double) -> CompareWithinConstraint {
		f := func (value, c: Cell<Double>) -> Bool { value get() equals(c get()) }
		CompareWithinConstraint new(this, Cell<Double> new(correct), f, this withinType)
	}
	to: func ~ldouble (correct: LDouble) -> CompareWithinConstraint {
		f := func (value, c: Cell<LDouble>) -> Bool { value get() equals(c get()) }
		CompareWithinConstraint new(this, Cell<LDouble> new(correct), f, this withinType)
	}
	to: func ~llong (correct: LLong) -> CompareWithinConstraint {
		f := func (value, c: Cell<LLong>) -> Bool { value get() == c get() }
		CompareWithinConstraint new(this, Cell<LLong> new(correct), f, this withinType)
	}
	to: func ~ullong (correct: ULLong) -> CompareWithinConstraint {
		f := func (value, c: Cell<ULLong>) -> Bool { value get() == c get() }
		CompareWithinConstraint new(this, Cell<ULLong> new(correct), f, this withinType)
	}
}

LessModifier: class extends ExpectModifier {
	allowEquality: Bool
	typeToPass: ComparisonType
	init: func ~parent (parent: ExpectModifier, allowEquals := false) {
		super(parent)
		this allowEquality = allowEquals
		this typeToPass = allowEquals ? ComparisonType LessOrEqual : ComparisonType LessThan
	}
	than: func ~object (right: Object) -> CompareConstraint {
		f := func (value, c: Object) -> Bool { this allowEquality ? value <= c : value < c }
		CompareConstraint new(this, right, f, this typeToPass)
	}
	than: func ~float (right: Float) -> CompareConstraint {
		f := func (value, c: Cell<Float>) -> Bool { this allowEquality ? value get() lessOrEqual(c get()) : value get() lessThan(c get()) }
		CompareConstraint new(this, Cell<Float> new(right), f, this typeToPass)
	}
	than: func ~double (right: Double) -> CompareConstraint {
		f := func (value, c: Cell<Double>) -> Bool { this allowEquality ? value get() lessOrEqual(c get()) : value get() lessThan(c get()) }
		CompareConstraint new(this, Cell<Double> new(right), f, this typeToPass)
	}
	than: func ~ldouble (right: LDouble) -> CompareConstraint {
		f := func (value, c: Cell<LDouble>) -> Bool { this allowEquality ? value get() lessOrEqual(c get()) : value get() lessThan(c get()) }
		CompareConstraint new(this, Cell<LDouble> new(right), f, this typeToPass)
	}
	than: func ~int (right: Int) -> CompareConstraint {
		f := func (value, c: Cell<Int>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<Int> new(right), f, this typeToPass)
	}
	than: func ~uint (right: UInt) -> CompareConstraint {
		f := func (value, c: Cell<UInt>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<UInt> new(right), f, this typeToPass)
	}
	than: func ~long (right: Long) -> CompareConstraint {
		f := func (value, c: Cell<Long>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<Long> new(right), f, this typeToPass)
	}
	than: func ~ulong (right: ULong) -> CompareConstraint {
		f := func (value, c: Cell<ULong>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<ULong> new(right), f, this typeToPass)
	}
	than: func ~llong (right: LLong) -> CompareConstraint {
		f := func (value, c: Cell<LLong>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<LLong> new(right), f, this typeToPass)
	}
	than: func ~ullong (right: ULLong) -> CompareConstraint {
		f := func (value, c: Cell<ULLong>) -> Bool { this allowEquality ? value get() <= c get() : value get() < c get() }
		CompareConstraint new(this, Cell<ULLong> new(right), f, this typeToPass)
	}
}

GreaterModifier: class extends ExpectModifier {
	allowEquality: Bool
	typeToPass: ComparisonType
	init: func ~parent (parent: ExpectModifier, allowEquals := false) {
		super(parent)
		this allowEquality = allowEquals
		this typeToPass = allowEquals ? ComparisonType GreaterOrEqual : ComparisonType GreaterThan
	}
	than: func ~object (right: Object) -> CompareConstraint {
		f := func (value, c: Object) -> Bool { this allowEquality ? value >= c : value > c }
		CompareConstraint new(this, right, f, this typeToPass)
	}
	than: func ~float (right: Float) -> CompareConstraint {
		f := func (value, c: Cell<Float>) -> Bool { this allowEquality ? value get() greaterOrEqual(c get()) : value get() greaterThan(c get()) }
		CompareConstraint new(this, Cell<Float> new(right), f, this typeToPass)
	}
	than: func ~double (right: Double) -> CompareConstraint {
		f := func (value, c: Cell<Double>) -> Bool { this allowEquality ? value get() greaterOrEqual(c get()) : value get() greaterThan(c get()) }
		CompareConstraint new(this, Cell<Double> new(right), f, this typeToPass)
	}
	than: func ~ldouble (right: LDouble) -> CompareConstraint {
		f := func (value, c: Cell<LDouble>) -> Bool { this allowEquality ? value get() greaterOrEqual(c get()) : value get() greaterThan(c get()) }
		CompareConstraint new(this, Cell<LDouble> new(right), f, this typeToPass)
	}
	than: func ~int (right: Int) -> CompareConstraint {
		f := func (value, c: Cell<Int>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<Int> new(right), f, this typeToPass)
	}
	than: func ~uint (right: UInt) -> CompareConstraint {
		f := func (value, c: Cell<UInt>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<UInt> new(right), f, this typeToPass)
	}
	than: func ~long (right: Long) -> CompareConstraint {
		f := func (value, c: Cell<Long>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<Long> new(right), f, this typeToPass)
	}
	than: func ~ulong (right: ULong) -> CompareConstraint {
		f := func (value, c: Cell<ULong>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<ULong> new(right), f, this typeToPass)
	}
	than: func ~llong (right: LLong) -> CompareConstraint {
		f := func (value, c: Cell<LLong>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<LLong> new(right), f, this typeToPass)
	}
	than: func ~ullong (right: ULLong) -> CompareConstraint {
		f := func (value, c: Cell<ULLong>) -> Bool { this allowEquality ? value get() >= c get() : value get() > c get() }
		CompareConstraint new(this, Cell<ULLong> new(right), f, this typeToPass)
	}
}