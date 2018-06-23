from collections import OrderedDict
from .configme import *
import regex

class constraintMetadataBuilder:
	"""
		Init a empty block of attribute information. All this
		information will be necessary to construct correct
		INSERT commands.
	"""
	def initColumnMetadata(self, attrType='', maxSize=-1):
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
	def processTokens(self, match, sep=','):
		return regex.sub('\s+', '', match.groups()[0]).split(sep)

	"""
		Preprocess all data into a big hashtable (Python dictionary),
		transforming all writen SQL commands into information. Latter,
		all this information will be used to construct the INSERT
		commands.
	"""
	def processConstraints(self, structuredTableCommands, sep=','):

		"""
		Regular expressions used to convert SQL commands
		into information necessary to generate correct
		INSERT commands.
		"""
		reConstraintDetect=regex.compile(r'CONSTRAINT', 
			regex.IGNORECASE)
		reConstraintFK=regex.compile(
			r'FOREIGN\s+KEY\s*\(([^)]+)\)'+
			r'\s*REFERENCES\s*([^\s\(]+)', regex.IGNORECASE)
		reConstraintPK=regex.compile(
			r'PRIMARY\s+KEY\s*\(([^)]+)\)', regex.IGNORECASE)
		reConstraintUn=regex.compile(
			r'UNIQUE\s*\(([^)]+)\)', regex.IGNORECASE)
		reConstraintCI=regex.compile(
			r'\CHECK\s*\([^(]*\(([^)]+)\)'+
			r'\s*IN\s*\(([^)]+)\)\s*\)', regex.IGNORECASE)
		reConstraintRE=regex.compile(
			r'\CHECK\s*\(\s*([^\s]+)'+
			r"\s*(?:~|SIMILAR\s*TO)\s*'([^']+)'\s*\)", regex.IGNORECASE)
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
						refColumns=self.processTokens(matchUnique, sep)
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
						refColumns=self.processTokens(matchPK, sep)
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
						refColumns=self.processTokens(matchFK, sep)
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
							curErrorTable.append(('COLUMN DECLARED TWICE', 
								currentCommand))
							errorCounter+=1
						else:
							# Init current column metadata
							curTable[attrName]=self.initColumnMetadata(
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
		for tableName in tablesWithFK:
			curTableAllFKMetadata=dbFKHandler['FK'][tableName]
			for curMetadata in curTableAllFKMetadata:
				fk=curMetadata['REFTABLE']
				if fk not in primaryKeys:
					# In this case, the FK references a non-
					# existent table.
					errorTable[tableName].append(('NONEXISTENT FK REFERENCE', 
						str(fk)))
					errorCounter+=1

		return dbStructure, errorCounter, errorTable, dbFKHandler

