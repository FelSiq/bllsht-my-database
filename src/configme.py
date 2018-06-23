"""
	This module keeps all user-configurable classes
	in the same place.
"""

from faker import Faker

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
	VARCHAR_DEFSIZE=32
	
	# Should columns with types CHAR and VARCHAR
	# without custom data generator function be
	# filled only with random lower case characters?
	GEN_RANDOM_CHARS=False

	# Max and Min values configuration
	MAX_INT=2**(8*4-1)-1
	MIN_INT=-2**(8*4-1)
	MAX_BIGINT=2**(8*8-1)-1
	MIN_BIGINT=-2**(8*8-1)
	MAX_SMALLINT=2**(8*2-1)-1
	MIN_SMALLINT=-2**(8*2-1)
	MAX_YEAR=2050
	MIN_YEAR=1900
	MAX_REAL=1.0e+5-1
	MIN_REAL=-1.0e+5
	PRECISION_REAL=2
	MAX_MONEY=1.0e+5-1
	MIN_MONEY=0
	PRECISION_MONEY=2

	# How many tries should the script perform
	# while trying to solve a FOREIGN KEY before
	# give up?
	TABLE_ERROR_TRIES=128	

class fakeDataHandler:
	"""
		Powerful python library to generate fake data
		See more: https://github.com/joke2k/faker
	"""
	fake=Faker(locale='pt_BR')

	"""
		Specify every column name and the correspondent
		random value generation function. CHAR, CHARACTER, 
		VARCHAR or VARCHAR2 without a correspondent func-
		tion will receive a random latin text by default.

		MODEL: -----------------------------------

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

		NOTE: ------------------------------------
		THIS SCRIPT IS CASE-SENSITIVE! THE FUNCTION
		NAME SHOULD BE EXACTLY THE SAME IN YOUR CREATE 
		TABLE COMMANDS!
		
	"""
	specialDataFuncs={
		'nome': {'equipamento': fake.name, 'DEFAULT': fake.name},
		'RG': fake.ssn,
		'nomeBanda': fake.name,
		'endereco': fake.address,
		'endereco': fake.address,
		'descricao': fake.text,
		'telefone': fake.phone_number,
	}
