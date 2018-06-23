import numpy.random as random
from .configme import *
from .bllshtUtils import bllshtUtils
from faker import Faker
import regex
import rstr

class valueGenerator:
	"""
	Generate a random SQL DATE value.
	"""
	def _randDATE(self):
		m=random.randint(1, 13)

		# Don't generate day 31' for simplicity.
		d=random.randint(1, 31-(m%2+(m==2)))
		y=random.randint(scriptConfig.MIN_YEAR, 
			scriptConfig.MAX_YEAR+1)

		# Do not check leap years for simplicity.
		# (avoid 29 of february)
		if m==2:
			d%=29

		m=str(m)
		d=str(d)
		y=str(y)

		# Make sure that the year is 'yyyy' (four digits)
		# because it is based on a user-controlled config.
		while len(y) < 4:
			y='0'+y
		
		return '-'.join([y[:4],
			('0' if len(m)==1 else '')+m,
			('0' if len(d)==1 else '')+d])

	"""
		Generate a random SQL TIME value.
	"""
	def _randTIME(self):
		h=str(random.randint(0, 24))
		m=str(random.randint(0, 60))
		s=str(random.randint(0, 60))
		return ':'.join([
			('0' if len(h)==1 else '')+h,
			('0' if len(m)==1 else '')+m,
			('0' if len(s)==1 else '')+s
		])


	"""
		Generate a random value, based on various constraints
		specified on the CREATE TABLE commands.
	"""
	def genValue(
		self,
		tableName,
		columnName,
		valType, 
		valMaxSize, 
		permittedValues,
		regexPat=''):

		# Regex used to find CHARACTER-type attributes
		reCheckChar=regex.compile(r'CHAR(ACTER)?|VARCHAR2?|TEXT')

		# Regex used to find for array-type attributes
		reCheckArray=regex.compile(r'(\w+)\s*\[(\d+)\](.*)')

		# Canonical (UPPERCASE) attribute type
		canonicalVT = valType.upper()

		# Check for array-type attribute
		arrayMatch=reCheckArray.search(canonicalVT)
		if arrayMatch:
			valType=arrayMatch.groups()[0]
			arraySize=int(arrayMatch.groups()[1])
			additionalDims=arrayMatch.groups()[2]

			partialRes=[]
			for i in range(arraySize):
				partialRes.append(self.genValue(
					tableName,
					columnName,
					valType+additionalDims, 
					valMaxSize, 
					permittedValues, 
					regexPat))

			return '{' + ', '.join(partialRes) + '}'

		# Check if current column don't have a custom
		# value generator
		elif columnName in fakeDataHandler.specialDataFuncs:
			genObject=fakeDataHandler.specialDataFuncs[columnName]
			if type(genObject) == type({}):
				# Nested custom generator configuration
				if tableName in genObject:
					genObject=genObject[tableName]
				elif 'DEFAULT' in genObject:
					genObject=genObject['DEFAULT']
				else:
					genObject=None

			if genObject:
				text=genObject()
				text=str(text)[:valMaxSize]
				processed=regex.sub(r"[\n']", ' ', text)
				return bllshtUtils.quotes(processed)

			# In case everything goes wrong.
			# This is probably due to bad user configurarion.
			return 'NULL'

		elif regexPat != '':
			return bllshtUtils.quotes(rstr.xeger(regexPat))

		# If exists a constraint of a set of permitted
		# values, then just sample a random value from
		# this set
		elif permittedValues is not None and len(permittedValues) > 0:
			smpVal=random.choice(list(permittedValues))
			if canonicalVT in ('MONEY', 'REAL', 'FLOAT8', 'INT', 'INT2', \
				'INT4', 'INT8', 'SMALLINT', 'INTEGER', 'BIGINT'):
				return smpVal
			return ('B' if canonicalVT in ('BIT', 'VARBIT') else '') + bllshtUtils.quotes(smpVal)

		elif reCheckChar.search(canonicalVT):
			
			size=valMaxSize 
			if canonicalVT in ('VARCHAR', 'VARCHAR2', 'TEXT'):
				size=random.randint(valMaxSize//2, valMaxSize+1) \
					if valMaxSize != -1 else scriptConfig.VARCHAR_DEFSIZE
			if scriptConfig.GEN_RANDOM_CHARS:
				# In case the script was configured to generate
				# random lower case characters on a column with
				# type CHAR or VARCHAR w/o a custom data generator
				# function.
				data=''
				for i in range(size):
					data += chr(random.randint(ord('a'), ord('z')))
			else:
				# Generate "true" words otherwise.
				data=regex.sub(r"['\n\t]", '', fakeDataHandler.fake.text(size)[:size])

			return bllshtUtils.quotes(data)

		elif canonicalVT in ('SMALLINT', 'INT2'):
			return str(random.randint(scriptConfig.MIN_SMALLINT, 
				scriptConfig.MAX_SMALLINT+1))

		elif canonicalVT in ('REAL', 'FLOAT8'):
			val=random.random()
			val*=(scriptConfig.MAX_REAL-scriptConfig.MIN_REAL)
			val+=scriptConfig.MIN_REAL
			val=round(val, scriptConfig.PRECISION_REAL)
			return str(val)

		elif canonicalVT in ('INTEGER', 'INT', 'INT4'):
			return str(random.randint(scriptConfig.MIN_INT, 
				scriptConfig.MAX_INT+1))

		elif canonicalVT in ('BIGINT', 'INT8'):
			return str(random.randint(scriptConfig.MIN_BIGINT, 
				scriptConfig.MAX_BIGINT+1))

		elif canonicalVT == 'DATE':
			return 'to_date (' + bllshtUtils.quotes(self._randDATE()) +\
				', '+ bllshtUtils.quotes('YYYY-MM-DD') + ')'

		elif canonicalVT in ('BOOLEAN', 'BOOL'):
			return random.choice(['TRUE', 'FALSE'])

		elif canonicalVT == 'MONEY':
			val=random.random()
			val*=(scriptConfig.MAX_MONEY-scriptConfig.MIN_MONEY)
			val+=scriptConfig.MIN_MONEY
			val=round(val, scriptConfig.PRECISION_MONEY)
			return str(val)

		elif canonicalVT in ('BIT', 'VARBIT'):
			bitSeq=''
			size=valMaxSize
			if canonicalVT == 'VARBIT':
				size=random.randint(valMaxSize//2, valMaxSize+1) \
					if valMaxSize != -1 else scriptConfig.VARCHAR_DEFSIZE
			for i in range(size):
				bitSeq += str(random.randint(2))
			return 'B' + bllshtUtils.quotes(bitSeq)

		elif canonicalVT == 'TIME':
			return bllshtUtils.quotes(self._randTIME())

		elif canonicalVT == 'TIMESTAMP':
			return 'to_timestamp (' + bllshtUtils.quotes( self._randDATE() +\
				' ' + self._randTIME()) + ', ' +\
				bllshtUtils.quotes('YYYY-MM-DD HH24:MI:SS') +')'

		elif canonicalVT == 'INET':
			ipAddress=fake.ipv6() if scriptConfig.INET_DATATYPE_IPV6 else fake.ipv4()
			return bllshtUtils.quotes(ipAddress)

		return None

	"""

	"""
	def genCanonicalValue(
		self,
		tableName,
		column, 
		varType, 
		maxSize, 
		permittedVals, 
		regex):

		value=str(self.genValue(
			tableName,
			column,
			varType, 
			maxSize,
			permittedVals,
			regex
			))

		# POSTGRESQL want single quotes around thw
		# very first curly brackets set
		if varType.find('[') != -1:
			# Single-quotes within a array must be
			# converted to double-bllshtUtils.quotes.
			value=value.replace("'", '"')
			# Then, finally, single-quotes the entire
			# array.
			value=bllshtUtils.quotes(value)
		return value
