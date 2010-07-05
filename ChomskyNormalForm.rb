require File.expand_path(File.dirname(__FILE__) + '/FreeContextGrammar.rb')

class ChomskyNormalForm < FreeContextGrammar

  def initialize(v, t, p, s)
    super(v, t, p, s)
  end
  
  class << self
    def from_fcgc(fcg)
      chomsky = ChomskyNormalForm.new(fcg.vars, fcg.terms, fcg.productions, fcg.start)

	#Imprime regras iniciais
	puts "\nEntrada"
	chomsky.imprime

	#Simplificações

	#Remove regra lambda
	chomsky.tira_lambda

	puts "\nRegra Lambda Removida"
	chomsky.imprime

	#Remove regra unitária
	chomsky.limpa_regra_unitaria

	puts "\nSem Regra Unitária"
	chomsky.imprime

	#Remove regra na forma aX
	chomsky.vars_to_the_right_in_production

	puts "\nSem Regra na forma aX"
	chomsky.imprime

	#Modifica regras com mais de 2 variáveis
	chomsky.max_last_two_vars_in_productions
	
	#Imprime regras na forma normal de Chomsky
	puts "\nForma Normal de Chomsky" #/
	chomsky.imprime

      return chomsky
    end
  end
end
