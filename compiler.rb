# 																								#
# 	Nombre: 		Jesus Hector Gonzalez Vidaurri		#
# 	Materia: 		Lenguajes de Programacion					#
# 																								#

require 'fileutils'

class Lexical

	# class variables
	@@ReservWords = ['suma',	'resta',	'multiplica',	'divide',	'guardalo',		'definir',	'dejalo',
										'mas',	'menos',	'por',				'entre',	'en',					'como'].freeze
	@@fileName = 'code.txt'.freeze


	def readFile(fileName = @@fileName)
		'''
			Read the file and return an array with the content of the file
			splitted by words.

			Lines starting with double hashtag (##) are ignored.
		'''
		@fileName = fileName
		@words = Array.new()
		file = File.open(@fileName, "r") # "r" stands for read

		counter = 0
		file.each_line do |line|
			if(line[0] == "#" && line[1] == "#")
				next
			end
			for word in line.split(" ")

				if(word.include?(','))
					@words[counter] = ","
					counter += 1
					word.delete!(',')
				end

				@words[counter] = word
				counter += 1
			end
		end
		
		return @words

	end # end function


	def classifyWord(word)
		'''
			Return the classification of the word.

			Note: Identifiers can only contain lower letters.

			Example on C:
				int (keyword), value (identifier), = (operator), 100 (constant) and ; (symbol).
		'''
		@word = word
		@Classif = ['keyword', 				# 0
								'identifier', 		# 1
								'constant', 			# 2 not used
								'symbol',					# 3
								'long',						# 4
								'double',					# 5
								'string'].freeze	# 6

		if(@word[0] =~ /[a-z]/)
			if(@@ReservWords.include?(@word))
				return @Classif[0]	# keyword
			else
					@word.split("").each do |letter|
						if(!(letter =~ /[a-z]/))
							errorMessage(@word)
						end
					end
				return @Classif[1]	# identifier
			end	

		elsif(@word[0] =~ /[0-9]/)
			dot = 0
			if(@word[-1] == ".")
				errorMessage(@word)
			end
			@word.split("").each do |letter|
				if(letter == '.')
					dot += 1
				end
				if(!(letter =~ /[0-9]/ || letter == ".") || (dot == 2))
					errorMessage(@word)
				end
			end
			if(dot == 1)
				return @Classif[5]	# constant
			else
				return @Classif[4]	# constant
			end
			
		elsif(@word[0] == ',')
			return @Classif[3]	# symbol
		else
			errorMessage(@word)
		end

	end # end function
	

	def classifyAsHash
		'''
			Return a hash where the *key is the word and *value is the classification
		'''
		fileContent = Array.new()
		fileContent = readFile()
		result = Hash.new()

		for word in fileContent
			if(!result.has_value?(word))
				result[word] = classifyWord(word).to_s()
			end
		end

		return result

	end # end function


	def getLine(word = '', fileName = @@fileName)
		'''
			Return the number of the line where the word is found.
		'''
		@fileName = fileName
		@word = word
		file = File.open(@fileName, "r") # "r" stands for read

		counter = 1
		file.each_line do |line|
			if(line.include?(@word))
				return counter
			end
			counter += 1
		end

	end # end function


	def startLexicalAnalysis
		'''
			Start lexical analysis
		'''
		return classifyAsHash

	end # end function


	def errorMessage(word)
		'''
			Prints an error message.
		'''
		@word = word
		Kernel.abort("Lexical error on: '" + @word + "', at line: " + getLine(@word).to_s + "\n")

	end # end function


	# access controls
	private :classifyWord, :readFile, :getLine, :classifyAsHash, :errorMessage
	public :startLexicalAnalysis

end # end class


'''
	Start - Testing Area
'''

a = Lexical.new()
words = a.startLexicalAnalysis
puts(words)

'''
	Ends - Testing Area
'''
