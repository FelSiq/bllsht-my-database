import numpy.random as random
from numpy import array
from numpy import inf
from .configme import *
from .bllshtUtils import bllshtUtils
from faker import Faker
import regex
import rstr
import collections

class valueGenerator:
	"""
	Generate a random SQL DATE value.
	"""
	def _randDATE(self, maxDate=None, minDate=None):
		"""
			maxDate = (year, month, day)
			minDate = (year, month, day)
		"""
		# Don't generate day 31' for simplicity.
		# Natural limit values
		maxDay=30
		minDay=1
		maxMonth=12
		minMonth=1
		maxYear=scriptConfig.MAX_YEAR
		minYear=scriptConfig.MIN_YEAR

		# Extern limit values
		if isinstance(maxDate, collections.Iterable):
			try:
				maxYear, maxMonth, maxDay = maxDate	
				maxYear=min(maxYear, scriptConfig.MAX_YEAR)
				maxMonth=min(maxMonth, 12)
				maxDay=min(maxDay, 30)
			except:
				pass

		if isinstance(minDate, collections.Iterable):
			try:
				minYear, minMonth, minDay = minDate	
				minYear=max(minYear, scriptConfig.MIN_YEAR)
				minMonth=max(minMonth, 1)
				minDay=max(minDay, 1)
			except:
				pass

		m=random.randint(minMonth, maxMonth+1)
		d=random.randint(minDay, maxDay-(m%2+(m==2))+1)
		y=random.randint(minYear, maxYear+1)

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
	def _randTIME(self, maxTime=None, minTime=None):
		"""
			maxTime = (hour, minutes, seconds)
			minTime = (hour, minutes, seconds)
		"""
		# Natural limit values
		maxHour=23
		minHour=0
		maxMin=59
		minMin=0
		maxSec=59
		minSec=0

		# Extern limit values
		if isinstance(maxTime, collections.Iterable):
			try:
				maxHour, maxMin, maxSec = maxTime
				maxHour=min(maxHour, 23)
				maxMin=min(maxMin, 59)
				maxSec=min(maxSec, 59)
			except:
				pass

		if isinstance(minTime, collections.Iterable):
			try:
				minHour, minMin, minSec = minTime
				minHour=max(minHour, 0)
				minMin=max(minMin, 0)
				minSec=max(minSec, 0)
			except:
				pass

		h=str(random.randint(minHour, maxHour+1))
		m=str(random.randint(minMin, maxMin+1))
		s=str(random.randint(minSec, maxSec+1))
		return ':'.join([
			('0' if len(h)==1 else '')+h,
			('0' if len(m)==1 else '')+m,
			('0' if len(s)==1 else '')+s
		])

	def _toDate(self, date):
		if type(date) is not type(''):
			date = '-'.join(date)

		return 'to_date (' +\
			bllshtUtils.quotes(date) +\
			', ' + bllshtUtils.quotes('YYYY-MM-DD') + ')'

	def _toTimestamp(self, date, time):
		if type(date) is not type(''):
			date = '-'.join(date)
		if type(time) is not type(''):
			time = ':'.join(time)

		return 'to_timestamp (' +\
			bllshtUtils.quotes(date + ' ' + time) + ', ' +\
			bllshtUtils.quotes('YYYY-MM-DD HH24:MI:SS') + ')'

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
		regexPat='',
		minValue=-inf,
		maxValue=+inf):

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
					regexPat,
					minValue,
					maxValue))

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
			# This is probably due to bad user configuration.
			return 'NULL'

		elif regexPat != '':
			return bllshtUtils.quotes(rstr.xeger(regexPat))

		# If exists a constraint of a set of permitted
		# values, then just sample a random value from
		# this set
		elif permittedValues is not None and len(permittedValues) > 0:
			enquote=True
			uniformProb=False

			if canonicalVT in ('INT', 'INT2', 'INT4', 'INT8', \
				'SMALLINT', 'INTEGER', 'BIGINT'):
				enquote=False
				castedPV=map(int, permittedValues)
					
			elif canonicalVT in ('FLOAT8', 'REAL', 'MONEY'):
				enquote=False
				castedPV=map(float, permittedValues)

			elif canonicalVT in ('BIT', 'VARBIT'):
				castedPV=[int(pv, 2) for pv in permittedValues]
			else:
				uniformProb=True
				castedPV=permittedValues

			sizePV=len(permittedValues)
			pVec=array([1.0] * sizePV)
			if not uniformProb:
				for i in range(sizePV):
					pVec[i]=int(minValue <= castedPV[i] <= maxValue)

			pVec /= sum(pVec)
			smpVal = random.choice(list(permittedValues), p=pVec)
			smpVal = bllshtUtils.quotes(smpVal) if enquote else smpVal
			return ('B' if canonicalVT in ('BIT', 'VARBIT') else '') + smpVal 

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
			return str(random.randint(
				max(scriptConfig.MIN_SMALLINT, minValue), 
				min(scriptConfig.MAX_SMALLINT, maxValue)+1))

		elif canonicalVT in ('REAL', 'FLOAT8'):
			val=random.random()
			val*=(min(scriptConfig.MAX_REAL, maxValue)-\
				max(scriptConfig.MIN_REAL, minValue))
			val+=max(minValue, scriptConfig.MIN_REAL)
			val=round(val, scriptConfig.PRECISION_REAL)
			return str(val)

		elif canonicalVT in ('INTEGER', 'INT', 'INT4'):
			return str(random.randint(
				max(minValue, scriptConfig.MIN_INT), 
				min(maxValue, scriptConfig.MAX_INT)+1))

		elif canonicalVT in ('BIGINT', 'INT8'):
			return str(random.randint(
				max(minValue, scriptConfig.MIN_BIGINT), 
				min(maxValue, scriptConfig.MAX_BIGINT)+1))

		elif canonicalVT == 'DATE':
			value=self._randDATE(maxValue, minValue)
			return self._toDate(value)

		elif canonicalVT in ('BOOLEAN', 'BOOL'):
			return random.choice(['TRUE', 'FALSE'])

		elif canonicalVT == 'MONEY':
			val=random.random()
			val*=(min(maxValue, scriptConfig.MAX_MONEY)-\
				max(minValue, scriptConfig.MIN_MONEY))
			val+=max(minValue, scriptConfig.MIN_MONEY)
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
			return bllshtUtils.quotes(self._randTIME(maxValue, minValue))

		elif canonicalVT == 'TIMESTAMP':
			# Unpack
			maxDate, maxTime = maxValue if \
				isinstance(maxValue, collections.Iterable) else (None, None)
			minDate, minTime = minValue if \
				isinstance(minValue, collections.Iterable) else (None, None)

			date=self._randDATE(maxDate, minDate)
			time=self._randTIME(maxTime, minTime)

			return self._toTimestamp(date, time)

		elif canonicalVT == 'INET':
			ipAddress=fake.ipv6() if scriptConfig.INET_DATATYPE_IPV6 else fake.ipv4()
			return bllshtUtils.quotes(ipAddress)

		return None
	
	"""
		Function dedicated to evaluate CHECK constraints
		based on comparison (>, <, =, !=, <>, <=, >=).

		This is a very naive solution, but should
		work.
	"""
	def checkConstraintsIntervals(self, expressions, dataType):
		"""
		Assuming "expressions" is in the form
		expressions = [
			(operator_0, value_0),
			(operator_1, value_1),
			...,
			(operator_n, value_n)
		]

		Currently supporting this time of verification only
		with the following data types:
		- INTEGERS (of any type)
		- REAL VALUES (of any time)
		- DATE, TIME and TIMESTAMPS
		"""
		minValidVal=None
		maxValidVal=None
		forbiddenVals=set()
		possible=True
		canonicalDT = dataType.upper()
		for e in expressions:
			op, compValue = e
			
			if op == '=':
				if minValidVal is None:
					minValidVal = compValue
				else:
					possible &= minValidVal == compValue

				if maxValidVal is None:
					maxValidVal = compValue
				else:
					possible &= minValidVal == compValue

			elif op == '<>' or op == '!=':
				if canonicalDT == 'DATE':
					forbVal = self._toDate(compValue)
				elif canonicalDT == 'TIMESTAMP':
					forbVal = self._toTimestamp(compValue[0], compValue[1])
				else:
					forbVal = str(compValue)

				forbiddenVals.union({forbVal})
				if maxValidVal is not None and maxValidVal == minValidVal:
					possible &= (maxValidVal != compValue)

			elif op == '>=':
				minValidVal = compValue

			elif op == '>':
				if canonicalDT == 'TIME':
					minValidVal = list(compValue)
					# minValidVal = (hour, minute, second)
					# Increment a second
					minValidVal[2] += 1
					minute = minValidVal[2] // 60
					minValidVal[1] += minute
					hour = minValidVal[1] // 60
					minValidVal[0] += hour
					if minValidVal[0] // 24:
						possible = False

				elif canonicalDT == 'DATE':
					minValidVal = list(compValue)
					# minValidVal = (year, month, day)
					# Increment a day
					minValidVal[2] += 1
					month = minValidVal[2] // 28
					minValidVal[1] += month
					year = minValidVal[1] // 365
					minValidVal[0] += year

				elif canonicalDT == 'TIMESTAMP':
					minValidVal = list(map(list, compValue))
					# minValidVal = ((year, month, day), (hour, minute, second))
					# Increment a second
					minValidVal[1][2] += 1
					minute = minValidVal // 60
					minValidVal[1][1] += minute
					hour = minValidVal[1] // 60
					minValidVal[1][0] += hour
					day = hour // 24
					minValidVal[0][2] += hour
					month = minValidVal // 28
					minValidVal[0][1] += month
					year = minValidVal[1] // 365
					minValidVal[0][0] += year
					
				else:
					minValidVal = compValue + 1

			elif op == '<=':
				maxValidVal = compValue

			elif op == '<':
				# HERE Testing only...
				if canonicalDT in ('DATE', 'TIME', 'TIMESTAMP'):
					maxValidVal = compValue
				else:
					maxValidVal = compValue - 1

			if not possible:
				break 

		if minValidVal is None:
			minValidVal = -inf
		if maxValidVal is None:
			maxValidVal = +inf

		return minValidVal, maxValidVal, forbiddenVals, possible

	"""

	"""
	def genCanonicalValue(
		self,
		tableName,
		column, 
		varType, 
		maxSize, 
		permittedVals, 
		forbiddenVals,
		compLogicalExp,
		regex):

		validValue=False
		while not validValue:
			minC, maxC, forbC, possible=self.checkConstraintsIntervals(compLogicalExp, varType)

			# Check if given comparison constraints are
			# fair enough to gen a valid value
			if not possible:
				return None	

			value=str(self.genValue(
				tableName,
				column,
				varType, 
				maxSize,
				permittedVals,
				regex,
				minC,
				maxC
				))

			# POSTGRESQL want single quotes around the
			# very first curly brackets set
			if varType.find('[') != -1:
				# Single-quotes within a array must be
				# converted to double-quotes.
				value=value.replace("'", '"')
				# Then, finally, single-quotes the entire array.
				value=bllshtUtils.quotes(value)

			# Check if the generated value is not in the
			# set of forbidden values (CHECK NOT IN constraints)
			validValue = value not in set.union(forbiddenVals, forbC)

		return value
