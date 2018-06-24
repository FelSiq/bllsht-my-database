import collections
import operator

"""
	Generic class to keep methods that can
	be used in a very generic way.
"""
class bllshtUtils:	
	"""
		Auxiliary function to enquote a string. Helps reducing
		verbosity level through the code when managing values.
	"""
	def quotes(value):
		return '\''+str(value)+'\''

	
	def symmetricOperator(operator):
		if operator == '>=':
			return '<='
		elif operator == '<=':
			return '>='
		elif operator == '<':
			return '>'
		elif operator == '>':
			return '<'

		# Assume operator is commutative
		return operator

	def evalOperator(a, b, op):
		if not isinstance(a, collections.Iterable):
			itA = [a]
		if not isinstance(b, collections.Iterable):
			itB = [b]
		
		if len(itA) != len(itB):
			return False
		
		ops = {
			'=': operator.eq,
			'==': operator.eq,
			'>=': operator.ge,
			'=>': operator.ge,
			'>': operator.gt,
			'<=': operator.le,
			'=<': operator.le,
			'<': operator.lt
		}
		
		curOp = ops[op]
		
		for va, vb in zip(itA, itB):
			if not curOp(va, vb):
				return False
		
		return True

