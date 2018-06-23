from collections import OrderedDict
import numpy.random as random
from .valueGenerator import valueGenerator
from .bllshtUtils import bllshtUtils
from .configme import *

class insertGenerator:
	def __init__(self):
		self.generator=valueGenerator()
	"""
		Remove all SMALLSERIAL/SERIAL/BIGSERIAL column types,
		because they're not needed to build up a
		valid INSERT command.
	"""
	def removeSerial(self, keys, types):
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
		self,
		generatedValues, 
		tableName, 
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
		curGenValues=generatedValues[tableName]

		command='INSERT INTO '+ tableName + ' ( ' +\
			', '.join(nonSerialColumn)+ ' )\n\tVALUES ( '

		counter=0
		for column in nonSerialColumn:
			# Auxiliary variables to help reducing verbosity
			# level through the function
			curColumn=curTable[column]
			curFK=curColumn['FK']

			counter+=1
			curEnd=', ' if counter < len(nonSerialColumn) else ''

			if curFK in generatedValues or (column != genNullAt and curTable[column]['UNIQUE']):
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

					value=self.generator.genCanonicalValue( 
						tableName,
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

		# Command blocked, remove generate values
		for column in nonSerialColumn:
			if len(curGenValues[column]):
				curGenValues[column].pop()
		return None

	"""

	"""
	def getFKValues(self, tableName, dbFKHandler, generatedValues, curTable, instNum):
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

			# SMALLSERIAL/SERIAL/BIGSERIAL column types should
			# not be a problem
			for column in curTable:
				curColumn=curTable[column]
				if curColumn['TYPE'].find('SERIAL') != -1:
					validArray[curColumn['UNIQUE']]=True
						

			# Treat UNIQUE values that has FOREIGN
			# KEY constraints
			if tableName in dbFKHandler['FK']:
				for dic in dbFKHandler['FK'][tableName]:
					fkTable=dic['REFTABLE']

					# For simplicity, do not consider the NULL values instances
					# at the tableName corresponding to the FOREIGN KEYS
					sampleInst[fkTable]=random.randint(0, instNum, 
						size=defSize)

					for curTableCol, refTableCol in zip(dic['FKCOLS'],
						dbFKHandler['PK'][fkTable]):
						if generatedValues[fkTable][refTableCol][sampleInst[fkTable][i]] \
							not in predefValues[curTableCol]:
							validArray[curTable[curTableCol]['UNIQUE']]=True	

			# Treat the UNIQUE values that are not part of
			# FOREIGN KEY constraints
			auxVals={}
			for column in predefValues:
				curColumn=curTable[column]
				if curColumn['FK']=='' and curColumn['UNIQUE']:
					auxVals[column]=self.generator.genCanonicalValue(
							tableName,
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
				if tableName in dbFKHandler['FK']:
					for dic in dbFKHandler['FK'][tableName]:
						fkTable=dic['REFTABLE']
						for curTableCol, fkTableCol in zip(dic['FKCOLS'],
							dbFKHandler['PK'][fkTable]):
							predefValues[curTableCol].append(\
								generatedValues[fkTable][fkTableCol][sampleInst[fkTable][i]])
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
	def genInsertCommands(self, dbStructure, dbFKHandler, instNum=5):
		# Structure used to keep track of all inserted values
		# to prevent UNIQUE duplication and generate correct
		# inserts of FOREIGN KEYS.
		generatedValues=OrderedDict()

		tableNumTotal=0
		for tableName in dbStructure:
			tableNumTotal+=1
			print('/* TABLE', tableName, '*/')
			tableErrorTries=scriptConfig.TABLE_ERROR_TRIES
			while tableErrorTries > 0:
				try:
					tableCommands=[]

					# Auxiliary variable to help reducing verbosity
					# inside this function.
					curTable=dbStructure[tableName]

					# Remove autoincrementable (SMALLSERIAL or SERIAL or BIGSERIAL)
					# columns.
					nonSerialColumn=self.removeSerial(list(curTable.keys()),
						[curTable[column]['TYPE'] for column in curTable])

					generatedValues[tableName]={}
					for column in curTable.keys():
						generatedValues[tableName][column]=[]

					# Get the PRIMARY KEY values of the tables referenced 
					# by the current tableName FOREIGN keys
					curInsertFKValues=self.getFKValues(tableName, 
						dbFKHandler, generatedValues, curTable, instNum)

					# Generate common instances (with non null values)
					for i in range(instNum):
						command=self.printCommand(
							generatedValues, 
							tableName, 
							curTable, 
							nonSerialColumn,
							curInsertFKValues,
							'')

						if command:
							tableCommands.append(command)
						else:
							tableCommands.append('/* COMMAND BLOCKED ' +\
								'(CAN\'T SOLVE FK). */')

					# If configured, the program will generate additional 
					# instances each one with a NULL value for each possible 
					# column that hasn't a 'NOT NULL' constraint and, obviously,
					# is neither a PRIMARY KEY.
					if scriptConfig.GEN_NULL_VALUES:
						for i in range(len(nonSerialColumn)):
							curNSColumn=nonSerialColumn[i]
							if not curTable[curNSColumn]['NOTNULL']:
								command=self.printCommand(
									generatedValues, 
									tableName, 
									curTable, 
									nonSerialColumn,
									curInsertFKValues,
									curNSColumn)
								if command:
									tableCommands.append('/* NULL INSERTION FOR ATTRIBUTE ' +\
										curNSColumn + ' AT TABLE ' + tableName + ' */\n' + command)
									
					# Finally, print commands
					while len(tableCommands):
						print(tableCommands.pop())

					# NEW LINE, to keep INSERT commands of each tableName
					# nicely separated between each other.
					print()

					tableErrorTries=0
					# Finished current table.
				except:
					tableErrorTries-=1

		print('/* TABLE NUMBER TOTAL:', tableNumTotal, '*/')

