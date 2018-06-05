"""
	DESCRIPTION:

	This script should create INSERT commands for PostgreSQL
	automatically, using a .sql document with all the CREATE 
	TABLE command. The .sql file must be passed as program
	argument.
"""

from collections import OrderedDict
import regex
import sys
import numpy.random as random
import rstr
from faker import Faker

"""
	Powerful python library to generate fake data
	See more: https://github.com/joke2k/faker
"""
fake=Faker(locale='pt_BR')


"""
	Put there every column name and the correspondent
	random value generation function. CHAR and VARCHAR
	without a correspondent function will receive a
	random text by default.
"""
"""
	MODEL:

	'columnName_1': {
		'table_1': genFunctionA, 
		'table_2': genFunctionB, 
		'DEFAULT': genFunctionDefault}}

	'columnName_2': genFunctionAllTables

	...

	'columnName_n': {
		'table_c': genFunctionZ,
		'table_d': genFunctionW
		}
	
"""
specialDataFuncs={
	'nome': {'equipamento': fake.name, 'DEFAULT': fake.name},
	'RG': fake.ssn,
	'nomeBanda': fake.name,
	'endereco': fake.address,
	'endereco': fake.address,
	'descricao': fake.text,
	'telefoneCsv': fake.phone_number,
}

"""
	This class hold script configuration used to generate
	the pseudo-random data of the INSERT commands.
"""
class scriptConfig:
	# Begin transaction before any INSERT command?
	BEGIN_TRANSACTION=True

	# Turn on this if you want a ROLLBACK ate the
	# end of the transaction. This flag only has
	# effect if BEGIN_TRANSACTION flag is True
	ROLLBACK_AT_END=True

	# Should the values that haven't the 'NOT NULL'
	# constraint receive NULL values?
	GEN_NULL_VALUES=True

	# Default size of a VARCHAR with non explicity
	# defined size.
	VARCHAR_DEFSIZE=10
	
	# Should columns with types CHAR and VARCHAR
	# without custom data generator function be
	# filled only with random lower case characters?
	genRandomChars=False

	# A set of extreme values
	# MAX_INT=2**(8*4)-1
	# MAX_INT=-2**(8*4)
	# MAX_BIGINT=2**(8*8)-1
	# MAX_BIGINT=-2**(8*8)
	# MIN_YEAR=1900
	# MAX_YEAR=2050
	MAX_INT=900000
	MIN_INT=100000
	MAX_BIGINT=90000000
	MIN_BIGINT=10000000
	MIN_YEAR=2000
	MAX_YEAR=2018

"""
	Read all data from the .sql source file, 
	preprocessing the data.

	-	Substitutes all blank spaces sequences 
		for a single blank space. 

	-	Remove all source /* commentaries */
"""
def readData(db):
	with open(db) as f:
		return regex.sub(r'\s+', ' ', 
			regex.sub(r'/\*[^*]*\*/', '', f.read()))

"""
	This is a pseudo-regular expression implementation
	that finds a full POSTGRESQL command, which may uses ','
	as a stop symbol but, unfortunally, it is used within a
	command too, making hard to detect using pure regex.
"""
def processCommands(text, stop=','):
	insideParenthesis=0
	result=['']

	for c in text:
		if c == '(':
			insideParenthesis += 1
		if c == ')':
			insideParenthesis -= 1
		if c == stop and insideParenthesis == 0:
			result[-1] = regex.sub('^\s*', '', result[-1])
			result.append('')				
		elif c != '\n':
			result[-1] += c

	return result

"""
	Get a base structure that links a table name with a list
	containing all its SQL commands to latter be processed
	into valid INSERT commands.
"""
def getCommands(rawDataCommands):
	structuredT = OrderedDict()
	for r in rawDataCommands:
		structuredT[r[0]] = processCommands(r[1])
	return structuredT

"""
	Init a empty block of attribute information. All this
	information will be necessary to construct correct
	INSERT commands.
"""
def initColumnMetadata(attrType='', maxSize=-1):
	return {
		'TYPE': attrType, 
		'MAXSIZE': maxSize, 
		'PERMITTEDVALUES': set(),
		'PK': False, 
		'UNIQUE': 0, 
		'DEFVAL': '', 
		'NOTNULL': False, 
		'FK': '',
		'REGEX': ''
	}


"""
	Just an auxilliary function for multivalue regex matching
	(for example, a PRIMARY KEY constraint, that may have
	multiple values related to a single command).
"""
def processTokens(match, sep=','):
	return regex.sub('\s+', '', match.groups()[0]).split(sep)

"""
	Preprocess all data into a big hashtable (Python dictionary),
	transforming all writen SQL commands into information. Latter,
	all this information will be used to construct the INSERT
	commands.
"""
def processConstraints(structuredTableCommands, sep=','):

	"""
	Regular expressions used to convert SQL commands
	into information necessary to generate correct
	INSERT commands.
	"""
	reConstraintDetect=regex.compile(r'CONSTRAINT', 
		regex.IGNORECASE)
	reConstraintFK=regex.compile(
		r'FOREIGN\s+KEY\s*\(([^)]+)\)'+
		r'\s*REFERENCES\s*([^\s]+)', regex.IGNORECASE)
	reConstraintPK=regex.compile(
		r'PRIMARY\s+KEY\s*\(([^)]+)\)', regex.IGNORECASE)
	reConstraintUn=regex.compile(
		r'UNIQUE\s*\(([^)]+)\)', regex.IGNORECASE)
	reConstraintCI=regex.compile(
		r'\CHECK\s*\([^(]*\(([^)]+)\)'+
		r'\s*IN\s*\(([^)]+)\)\s*\)', regex.IGNORECASE)
	reConstraintRE=regex.compile(
		r'\CHECK\s*\(\s*([^\s]+)'+
		r"\s*~\s*'([^']+)'\s*\)", regex.IGNORECASE)
	reConstraintNN=regex.compile(
		r'([^\s]+).*NOT\s*NULL\s*', regex.IGNORECASE)
	reConstraintDF=regex.compile(
		r'\s*DEFAULT\s*([^\s]+)\s*', regex.IGNORECASE)
	reDeclareAttr=regex.compile(
		r'([^\s]+)\s+([^\s(]+)[^(]*(?:\(\s*(\d+)\s*\))?', 
		regex.IGNORECASE)

	"""
	Check out "initColumnMetadata" for the model of a
	basic column-relate information block. All the blocks
	will be linked to the correspondent table name inside
	"dbStructure" hashtable. This data structure will be
	the information core necessary to produce valid
	INSERT commands.
	"""
	dbStructure=OrderedDict()
	dbFKHandler={'PK': {}, 'FK': {}}
	errorTable={}
	errorCounter=0
	for key in structuredTableCommands:
		# Each table has its own sub-hashtable for each of its own
		# columns/attributes.
		dbStructure[key]={}
		errorTable[key]=[]
		
		# Auxilliary variables to reduce verbosity level through
		# this function.
		curList=structuredTableCommands[key]
		curTable=dbStructure[key]
		curErrorTable=errorTable[key]

		for i in range(len(curList)):
			# Another auxiliary variable to reduce verbosity level
			currentCommand=curList[i]

			checkConstraint=reConstraintDetect.search(currentCommand)
			if checkConstraint:				
				# Constraint declaration
				
				# Check UNIQUE
				matchUnique=reConstraintUn.search(currentCommand)
				if matchUnique:
					# Differently for the PRIMARY and FOREIGN KEYS,
					# keeping the original order of the UNIQUE keys
					# isn't important, as it will never be part of
					# a foreign key without being explicity declared
					# with a FOREIGN KEY constraint.
					refColumns=processTokens(matchUnique, sep)
					uniqueLevel=0
					for column in curTable:
						uniqueLevel=max(uniqueLevel, 
							curTable[column]['UNIQUE'])
					uniqueLevel+=1
					for r in refColumns:
						if r in curTable:
							curTable[r]['UNIQUE']=uniqueLevel
						else:
							curErrorTable.append(('UNIQUE:', 
								'COLUMN NOT EXISTS', currentCommand))
							errorCounter+=1

				# Check CHECK IN
				matchCheckIn=reConstraintCI.search(currentCommand)
				if matchCheckIn:
					refColumn=matchCheckIn.groups()[0]
					if refColumn in curTable:
						curTable[refColumn]['PERMITTEDVALUES']=set(
							(regex.sub('\s+|\'', '', 
							matchCheckIn.groups()[1])).split(sep))
					else:
						curErrorTable.append(('CHECK IN:', 
							'COLUMN NOT EXISTS', currentCommand))
						errorCounter+=1

				# Check PRIMARY KEY
				matchPK=reConstraintPK.search(currentCommand)
				if matchPK:
					refColumns=processTokens(matchPK, sep)
					# Keeping the primary key attributes with its
					# original order is crucial for matching
					# possible foreign keys.
					dbFKHandler['PK'][key]=refColumns
					for r in refColumns:
						if r in curTable:
							curTable[r]['PK']=True
							curTable[r]['NOTNULL']=True
							curTable[r]['UNIQUE']=1
						else:
							curErrorTable.append(('PRIMARY KEY:',
								'COLUMN NOT EXISTS', currentCommand))
							errorCounter+=1

				# Check FOREIGN KEY
				matchFK=reConstraintFK.search(currentCommand)
				if matchFK:
					refColumns=processTokens(matchFK, sep)
					# Keeping the foreign key attributes with its
					# original order is crucial for matching the
					# primary key. It's extremelly important to
					# note that a single table must contain various
					# different foreign keys, so it's necessary to
					# list then all with the referenced table.
					fkTable=matchFK.group(2)

					if key not in dbFKHandler['FK']:
						dbFKHandler['FK'][key]=[]

					dbFKHandler['FK'][key].append({
						'REFTABLE': fkTable, 
						'FKCOLS': refColumns})

					for r in refColumns:
						if r in curTable:
							curTable[r]['FK']=fkTable
							curTable[r]['NOTNULL']=True
						else:
							curErrorTable.append(('FOREIGN KEY:',
								'COLUMN NOT EXISTS', currentCommand))
							errorCounter+=1

				# check REGULAR EXPRESSION
				matchRe=reConstraintRE.search(currentCommand)
				if matchRe:
					refTable=matchRe.groups()[0]
					if refTable in curTable:
						reg=matchRe.groups()[1]
						curTable[refTable]['REGEX']=reg
					else:
						curErrorTable.append(('REGEX:',
							'COLUMN NOT EXITS', currentCommand))
						errorCounter+=1
			else:
				# Attribute/Column declaration
				match=reDeclareAttr.search(currentCommand)
				if match:
					matchData=match.groups()
					attrName=matchData[0]
					attrType=matchData[1]

					try:
						attrMaxSize=int(matchData[2])
					except:
						attrMaxSize=-1

					if attrName in curTable:
						# In case that the column is declared
						# twice in the same table
						curErrorTable.append(('COLUMN DECLARED TWITCE', 
							currentCommand))
						errorCounter+=1
					else:
						# Init current column metadata
						curTable[attrName]=initColumnMetadata(
							attrType, attrMaxSize)

						# Check if current column is NOT NULL
						notNullMatch=reConstraintNN.search(currentCommand)
						if notNullMatch:
							curTable[attrName]['NOTNULL']=True

						# Check if current column has DEFAULT VALUE
						defaultValueMatch=reConstraintDF.search(currentCommand)
						if defaultValueMatch:
							curTable[attrName]['DEFVAL']=defaultValueMatch.groups()[0]


	# Check if there is incorrect FK references
	# That structure is kinda messy and heavy, but
	# is a powerful mechanims to keep everything in
	# place.
	tablesWithFK=dbFKHandler['FK'].keys()
	primaryKeys=dbFKHandler['PK'].keys()
	for table in tablesWithFK:
		curTableAllFKMetadata=dbFKHandler['FK'][table]
		for curMetadata in curTableAllFKMetadata:
			fk=curMetadata['REFTABLE']
			if fk not in primaryKeys:
				# In this case, the FK references a non-
				# existent table.
				errorTable[table].append(('NONEXISTENT FK REFERENCE', 
					str(fk)))
				errorCounter+=1

	return dbStructure, errorCounter, errorTable, dbFKHandler

"""
	Generate a random SQL DATE value.
"""
def _randDATE():
	m=random.randint(1, 12)
	d=random.randint(1, 31-(m%2+(m==2)))
	y=random.randint(scriptConfig.MIN_YEAR, 
		scriptConfig.MAX_YEAR+1)
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
def _randTIME():
	h=str(random.randint(0, 23))
	m=str(random.randint(0, 59))
	s=str(random.randint(0, 59))
	return ':'.join([
		('0' if len(h)==1 else '')+h,
		('0' if len(m)==1 else '')+m,
		('0' if len(s)==1 else '')+s
	])

"""
	Auxiliary function to enquote a string. Helps reducing
	verbority level through the code when managing values.
"""
def quotes(string):
	return '\''+string+'\''


"""
	Generate a random value, based on various constraints
	specified on the CREATE TABLE commands.
"""
def genValue(
	tableName,
	columnName,
	valType, 
	valMaxSize, 
	permittedValues,
	regexPat=''):

	"""
	POSTGRESQL DATATYPES:
	
	INTEGER: 4B
	BIGINT: 8B
	DATE: 'YYYY-MI-DD'
	SERIAL: 4B (autoincrementable)
	BIGSERIAL: 8B (autoincrementable) 
	TYPE[N] (VECTOR) 
	BOOLEAN: TRUE/FALSE
	VARCHAR 
	CHAR 
	TIME: 'HH24:MI:SS'
	TIMESTAMP: 'YYYY-MM-DD HH24:MI:SS'
	"""

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
			partialRes.append(genValue(
				tableName,
				columnName,
				valType+additionalDims, 
				valMaxSize, 
				permittedValues, 
				regexPat))

		return '{' + ', '.join(partialRes) + '}'

	# Check if current column don't have a custom
	# value generator
	elif columnName in specialDataFuncs:
		genObject=specialDataFuncs[columnName]
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
			return quotes(processed)

		# In case everything goes wrong.
		# This is probably due to bad user configurarion.
		return 'NULL'

	elif regexPat != '':
		return quotes(rstr.xeger(regexPat))

	# If exists a constraint of a set of permitted
	# values, then just sample a random value from
	# this set
	elif permittedValues is not None and len(permittedValues) > 0:
		smpVal=random.choice(list(permittedValues))
		if canonicalVT == 'INTEGER' or canonicalVT == 'BIGINT':
			return smpVal
		return quotes(smpVal)

	elif canonicalVT == 'INTEGER':
		return str(random.randint(scriptConfig.MIN_INT, 
			scriptConfig.MAX_INT))

	elif canonicalVT == 'BIGINT':
		return str(random.randint(scriptConfig.MIN_BIGINT, 
			scriptConfig.MAX_BIGINT))

	elif canonicalVT == 'DATE':
		return 'to_date (' + quotes(_randDATE()) +\
			', '+ quotes('YYYY-MM-DD') + ')'

	elif canonicalVT == 'BOOLEAN':
		return random.choice(['TRUE', 'FALSE'])

	elif canonicalVT == 'VARCHAR' or canonicalVT == 'CHAR':
		
		size=valMaxSize 
		if canonicalVT == 'VARCHAR':
			size=random.randint(valMaxSize//2, valMaxSize) \
				if valMaxSize != -1 else scriptConfig.VARCHAR_DEFSIZE
		if scriptConfig.genRandomChars:
			# In case the script was configured to generate
			# random lower case characters on a column with
			# type CHAR or VARCHAR w/o a custom data generator
			# function.
			data=''
			for i in range(size):
				data += chr(random.randint(ord('a'), ord('z')))
		else:
			# Generate "true" words otherwise.
			data=regex.sub(r"['\n\t]", '', fake.text()[:size])

		return quotes(data)

	elif canonicalVT == 'TIME':
		return quotes(_randTIME())

	elif canonicalVT == 'TIMESTAMP':
		return 'to_timestamp (' + quotes( _randDATE() +\
			' ' + _randTIME()) + ', ' +\
			quotes('YYYY-MM-DD HH24:MI:SS') +')'

	return None

def genCanonicalValue(
	tableName,
	column, 
	varType, 
	maxSize, 
	permittedVals, 
	regex):

	value=str(genValue(
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
		# converted to double-quotes.
		value=value.replace("'", '"')
		# Then, finally, single-quotes the entire
		# array.
		value=quotes(value)
	return value

"""
	Remove all SERIAL/BIGSERIAL column types,
	because they're not needed to build up a
	valid INSERT command.
"""
def removeSerial(keys, types):
	rmIndexes=[]

	for i in range(len(keys)):
		if types[i].find('SERIAL') != -1:
			rmIndexes.append(i)

	for i in sorted(rmIndexes, reverse=True):
		keys.pop(i)

	return keys

"""
	Creates a entire valid INSERT command
"""
def printCommand(
	genValues, 
	table, 
	curTable, 
	nonSerialColumn, 
	curTableFKValues,
	genNullAt=''):

	# FLAG variable to block invalid INSERT commands
	# mainly to the fact that this program does not
	# support composite key checking.
	blockCommand=False

	# Auxiliary variable that helps reducing verbosity
	# level through this function
	curGenValues=genValues[table]

	command='INSERT INTO '+ table + ' ( ' +\
		', '.join(nonSerialColumn)+ ' )\n\tVALUES ( '

	counter=0
	for column in nonSerialColumn:
		# Auxiliary variables to help reducing verbosity
		# level through the function
		curColumn=curTable[column]
		curFK=curColumn['FK']

		counter+=1
		curEnd=', ' if counter < len(nonSerialColumn) else ''

		if curFK in genValues or (column != genNullAt and curTable[column]['UNIQUE']):
			# The current column has a valid foreign key.
			# Just insert the given value		
			value=''
			if len(curTableFKValues[column]):
				value=curTableFKValues[column].pop()
			else:
				blockCommand=True

		elif column != genNullAt:
			# From now, it is important to use the previous
			# created values in order to keep UNIQUE values,
			# unique. For now, each UNIQUE value is treated
			# separatelly, which means that a composite key
			# with n attributes is viewed a set of different
			# keys up to n. This makes codification simplier
			# and should not be a big problem for now.

			validValue=False
			while not validValue:

				value=genCanonicalValue( 
					table,
					column,
					curColumn['TYPE'], 
					curColumn['MAXSIZE'],
					curColumn['PERMITTEDVALUES'],
					curColumn['REGEX']
					)

				# Desconsidering the FOREIGN KEY constraint,
				# a not UNIQUE value is automatically a valid value.
				# Otherwise, it must not be one of the previously
				# generated values.

				validValue = (not curColumn['UNIQUE']) \
					or (value not in curGenValues[column])

				# 'None' will be used as a bugged 'valid' type,
				# because is probably caused by:
				# -	Bad SQL input code
				# -	Unsupported column type by this script
				validValue |= (value == 'None')

		else:
			# The specified column was solicited to assume a NULL
			# value
			value='NULL'

		# Keep track of each generated value, to check
		# for UNIQUE and FOREIGN KES constraints
		curGenValues[column].append(value)

		command+=str(value)+curEnd
	command+=' );'

	if not blockCommand:
		for column in curGenValues.keys():
			if column not in nonSerialColumn:
				curId=1
				if len(curGenValues[column]):
					curId=max(curGenValues[column])+1
				curGenValues[column].append(curId)
		return command
	return None

"""

"""
def getFKValues(table, dbFKHandler, genValues, curTable, instNum):
	# 
	maxUniqueLevel=0
	for column in curTable:
		maxUniqueLevel=max(maxUniqueLevel, 
			curTable[column]['UNIQUE'])

	predefValues={}
	for column in curTable:
		predefValues[column]=[]

	# 
	nullInstCount=0
	for col in curTable:
		nullInstCount+=(not curTable[col]['NOTNULL'])

	sampleInst={}

	i=0
	secCount=0
	defSize=nullInstCount+instNum
	while i < defSize:
		#
		validArray=[False]*(1+maxUniqueLevel)

		# SERIAL/BIGSERIAL column types should
		# not be a problem
		for column in curTable:
			curColumn=curTable[column]
			if curColumn['TYPE'].find('SERIAL') != -1:
				validArray[curColumn['UNIQUE']]=True
					

		# Treat UNIQUE values that has FOREIGN
		# KEY constraints
		if table in dbFKHandler['FK']:
			for dic in dbFKHandler['FK'][table]:
				fkTable=dic['REFTABLE']

				# For simplicity, do not consider the NULL values instances
				# at the table corresponding to the FOREIGN KEYS
				sampleInst[fkTable]=random.randint(0, instNum, 
					size=defSize)

				for curTableCol, refTableCol in zip(dic['FKCOLS'],
					dbFKHandler['PK'][fkTable]):
					if genValues[fkTable][refTableCol][sampleInst[fkTable][i]] \
						not in predefValues[curTableCol]:
						validArray[curTable[curTableCol]['UNIQUE']]=True	

		# Treat the UNIQUE values that are not part of
		# FOREIGN KEY constraints
		auxVals={}
		for column in predefValues:
			curColumn=curTable[column]
			if curColumn['FK']=='' and curColumn['UNIQUE']:
				auxVals[column]=genCanonicalValue(
						table,
						column,
						curColumn['TYPE'], 
						curColumn['MAXSIZE'],
						curColumn['PERMITTEDVALUES'],
						curColumn['REGEX']
						)
	
				if auxVals[column] not in predefValues[column]:
					validArray[curTable[column]['UNIQUE']]=True
	
		# Test if the combination is valid
		if sum(validArray[1:])==maxUniqueLevel:
			if table in dbFKHandler['FK']:
				for dic in dbFKHandler['FK'][table]:
					fkTable=dic['REFTABLE']
					for curTableCol, fkTableCol in zip(dic['FKCOLS'],
						dbFKHandler['PK'][fkTable]):
						predefValues[curTableCol].append(\
							genValues[fkTable][fkTableCol][sampleInst[fkTable][i]])
			for column in predefValues:
				if column in auxVals:
					predefValues[column].append(auxVals[column])
			i+=1
			secCount=0
		else:
			secCount+=1
			if secCount > instNum*5:
				# Can't generate valid combinations
				i+=1
				secCount=0

	return predefValues

"""
	Generate the SQL INSERT commands.
	This is the very last step of this program.
"""
def genInsertCommands(dbStructure, dbFKHandler, numInst=5):
	# Structure used to keep track of all inserted values
	# to prevent UNIQUE duplication and generate correct
	# inserts of FOREIGN KEYS.
	genValues=OrderedDict()

	tableNumTotal=0
	for table in dbStructure:
		tableNumTotal+=1

		# Auxiliary variable to help reducing verbosity
		# inside this function.
		curTable=dbStructure[table]

		# Remove autoincrementable (SERIAL or BIGSERIAL)
		# columns.
		nonSerialColumn=removeSerial(list(curTable.keys()),
			[curTable[column]['TYPE'] for column in curTable])

		print('/* TABLE', table, '*/')
		genValues[table]={}
		for column in curTable.keys():
			genValues[table][column]=[]

		# Get the PRIMARY KEY values of the tables referenced 
		# by the current table FOREIGN keys
		curInsertFKValues=getFKValues(table, 
			dbFKHandler, genValues, curTable, instNum)

		# Generate common instances (with non null values)
		for i in range(numInst):
			command=printCommand(
				genValues, 
				table, 
				curTable, 
				nonSerialColumn,
				curInsertFKValues,
				'')
			print(command)

		# If configured, the program will generate additional 
		# instances each one with a NULL value for each possible 
		# column that hasn't a 'NOT NULL' constraint and, obviously,
		# is neither a PRIMARY KEY.
		if scriptConfig.GEN_NULL_VALUES:
			for i in range(len(nonSerialColumn)):
				curNSColumn=nonSerialColumn[i]
				if not curTable[curNSColumn]['NOTNULL']:
					command=printCommand(
						genValues, 
						table, 
						curTable, 
						nonSerialColumn,
						curInsertFKValues,
						curNSColumn)
					if command:
						print('/* NULL INSERTION FOR ATTRIBUTE', 
							curNSColumn, 'AT TABLE', table, ' */\n', command)
						
		# NEW LINE, to keep INSERT commands of each table
		# nicely separated between each other.
		print()

	print('/* TABLE NUMBER TOTAL:', tableNumTotal, '*/')

if __name__ == '__main__':
	if len(sys.argv) < 2:
		print('usage:', sys.argv[0], 
			'< .sql file with CREATE TABLE commands >',
			'[# of valid w/o NULL values instances for each table (default to 5)]')
		exit(1)

	instNum=5
	if len(sys.argv) >= 3:
		try:
			instNum=int(sys.argv[2])
			if instNum <= 0:
				raise Exception;
		except:
			print('Incorrent parameter type/value (\'' + 
				sys.argv[2] + '\').',
				'Must be a positive integer value.',
				'Setting to default value (5).')
			instNum=5

	# Get the file content	
	data=readData(sys.argv[1])

	# Regular expression that get a TABLE from the source file.
	reGetTable=regex.compile(
		r'\s*CREATE\s*TABLE\s*([^\s(]+)\s*\(([^;]*)\);', 
		regex.IGNORECASE | regex.MULTILINE)

	# Extract all tables from .sql file 
	# (with CREATE TABLE commands)
	rawTableCommands=reGetTable.findall(data) 

	# First preprocessing of the data:
	# Links table name with each one of its creation commands
	# in the form of character strings separated inside a Python list.
	structuredTableCommands=getCommands(rawTableCommands)

	# Final preprocessing stage, where all data is converted
	# into true TABLE information, heavily structured into a
	# hashtable that links the table name with a dictionary of
	# "all possible" POSTGRES constraints and information needed to
	# construct valid INSERT commands.
	dbStructure, errorCounter, errorTable, dbFKHandler=processConstraints(structuredTableCommands)

	# DEBUG purposes
	print('/* TOTAL OF', errorCounter, 
		'ERRORS WHILE BUILDING METADATA STRUCTURE. */')
	if errorCounter:
		print('SHOWING ERRORS FOR EACH TABLE:')
		for table in errorTable:
			if len(errorTable[table]):
				print('SHOWING ERROR IN TABLE', table)	
				for error in errorTable[table]:
					print('\tERROR TYPE:', error[0], '\n\tCOMMAND:', error[1])
				print('END ERROR SECTION OF TABLE', table, '\n\n')	
		print('DONE WITH ERRORS. FIX THEN IN',
			'ORDER TO USED THE PROGRAM.')

	else:
		# If everything was correct til now...
		# Finally, produce INSERT commands now
		if scriptConfig.BEGIN_TRANSACTION:
			print('BEGIN TRANSACTION;')
		genInsertCommands(dbStructure, dbFKHandler, instNum)
		if scriptConfig.BEGIN_TRANSACTION:
			print('ROLLBACK;' if scriptConfig.ROLLBACK_AT_END \
			else 'END TRANSACTION;')

