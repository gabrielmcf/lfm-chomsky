require File.expand_path(File.dirname(__FILE__) + '/FreeContextGrammar.rb')
require File.expand_path(File.dirname(__FILE__) + '/ChomskyNormalForm.rb')

class GreibachNormalForm < ChomskyNormalForm
  def initialize(v, t, p, s)
    super(v, t, p, s)
  end

  class << self
    def from_fcgg(fcg)
      greibach = GreibachNormalForm.new(fcg.vars, fcg.terms, fcg.productions, fcg.start)
      
      greibach.to_cnf
      greibach.gera_gnf
    end
  end
end
