
"""
	Generic class to keep methods that can
	be used in a very generic way.
"""
class bllshtUtils:	
	"""
		Auxiliary function to enquote a string. Helps reducing
		verbosity level through the code when managing values.
	"""
	def quotes(string):
		return '\''+string+'\''

	
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
