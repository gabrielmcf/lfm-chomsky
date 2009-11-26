require File.expand_path(File.dirname(__FILE__) + '/ChomskyNormalForm.rb')
require File.expand_path(File.dirname(__FILE__) + '/FreeContextGrammar.rb')

class ChomskyNormalFormTest

      fcg = FreeContextGrammar.new(
#Teste 1
#        ['E'],
#        ['+', '*','(',')','t'],
#        { 'E' => ["E+E", "E*E", "(E)","t"]},
#        'E'

#Teste 2
#	['A','B','C','S'],
#	['a','b','c'],
#	{'S' => ["AB","BCCcabb"], 'A' => ["BAC","abbb"], 'B' => ["CAC","BbA"], 'C' => ["AB","aC","c"]},

#Teste 3
        ['A','B','C','P'],
        ['a','b','c'],
        { 'P' => ["APB","C"],'A' => ["AaaA","&"],'B' => ["BBb","C"],'C' => ["cC","&"]},
        'P'

#Teste 4
#        ['L','S','E'],
#        ['a','(',')'],
#        { 'L' => ["(S)"],'S' => ["SE","&"],'E' => ["a","L"]},
#        'L'

      )

      cnf = fcg.to_cnf
end