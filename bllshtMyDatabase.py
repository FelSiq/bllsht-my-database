"""
	DESCRIPTION:

	This script should create INSERT commands for PostgreSQL
	automatically, using a .sql document with all the CREATE 
	TABLE command. The .sql file must be passed as program
	argument.
"""

from src.constraintMetadataBuilder import *
from src.insertGenerator import *
from src.preprocessor import *
import sys

def bllshtMyDatabase(sqlFilepath, instNum):
	# First preprocessing of the data:
	# Links table name with each one of its creation commands
	# in the form of character strings separated inside a Python list.
	structuredTableCommands=preprocessor().getCommands(sqlFilepath)

	# Final preprocessing stage, where all data is converted
	# into true TABLE information, heavily structured into a
	# hashtable that links the table name with a dictionary of
	# "all possible" POSTGRES constraints and information needed to
	# construct valid INSERT commands.
	dbStructure, errorCounter, errorTable, dbFKHandler=\
		constraintMetadataBuilder().processConstraints(structuredTableCommands)

	# Error checking
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
		insertGenerator().genInsertCommands(dbStructure, dbFKHandler, instNum)
		if scriptConfig.BEGIN_TRANSACTION:
			print('ROLLBACK;' if scriptConfig.ROLLBACK_AT_END \
			else 'END TRANSACTION;')

"""
	Program driver.
"""
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

	bllshtMyDatabase(sys.argv[1], instNum)

