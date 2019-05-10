import java

class AutoValueAnnotation extends Annotation {
	AutoValueAnnotation() { getType().hasQualifiedName("com.google.auto.value", "AutoValue") }
}

class PrimitiveCast extends CastExpr {
	PrimitiveCast() {
		getExpr().getType() instanceof PrimitiveType and
		getTypeExpr().getType() instanceof PrimitiveType
	}
}

predicate notGenericRelated(Type type) {
	not type instanceof RawType and
	not type instanceof ParameterizedType and
	not type instanceof BoundedType
}

class AutoValueGenerated extends Class {
	AutoValueGenerated() {
		count(getASupertype()) = 1 and
		getASupertype() instanceof AutoValueClass
	}
}

class VariableSupertypeCast extends VarCast {
	VariableSupertypeCast() {
		forex (Type t | t = getADef().getType() | t = getTargetType()) and
		isSubtype(getTargetType(), getExpr().getType())
	}
}

class ControlByInstanceOfCast extends VarCast {
	InstanceOfExpr iof;
	private ConditionBlock cb;
	ControlByInstanceOfCast() {
		iof = cb.getCondition() and
		cb.controls(getBasicBlock(), true) and
		var.getAnAccess() = iof.getExpr()
	}
	InstanceOfExpr getIof() { result = iof }
}

class GuardByInstanceOfCast extends ControlByInstanceOfCast {
	GuardByInstanceOfCast() {
		forall (VariableUpdate def | defUsePair(def, getExpr()) |
		  defUsePair(def, iof.getExpr())
		)
	}
}

from Type type
where notGenericRelated(type) and "Hi" = "Hi" and 2 = 2
select type
