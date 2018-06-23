from collections import OrderedDict
import regex

class preprocessor:
	"""
		Read all data from the .sql source file, 
		preprocessing the data.

		-	Substitutes all blank spaces sequences 
			for a single blank space. 

		-	Remove all source /* commentaries1 */ and -- commentaries2
	"""
	def readData(self, db):
		data = None
		with open(db) as f:
			data= regex.sub(r'\s+', ' ', 
				regex.sub(r'/\*[^*]*\*/|--[^\n]*\n', '', f.read()))

		# Regular expression that get a TABLE from the source file.
		reGetTable=regex.compile(
			r'\s*CREATE\s*TABLE\s*([^\s(]+)\s*\(([^;]*)\);', 
			regex.IGNORECASE | regex.MULTILINE)

		# Extract all tables from .sql file 
		# (with CREATE TABLE commands)
		rawTableCommands=reGetTable.findall(data) 
	
		return rawTableCommands


	"""
		This is a pseudo-regular expression implementation
		that finds a full POSTGRESQL command, which may uses ','
		as a stop symbol but, unfortunally, it is used within a
		command too, making hard to detect using pure regex.
	"""
	def processCommands(self, text, stop=','):
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
	def getCommands(self, sqlFilepath):
		rawDataCommands = self.readData(sqlFilepath)
		structuredT = OrderedDict()
		for r in rawDataCommands:
			structuredT[r[0]] = self.processCommands(r[1])
		return structuredT

