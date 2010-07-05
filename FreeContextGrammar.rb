class FreeContextGrammar
  attr_accessor :terms, :productions, :start

  def initialize(v, t, p, s)
    vars = v # ['E'], é descartado pois conhece-as dinamicamente com base em productions
    @terms = t # ['+', '*','(',')','t']
    @productions = p # { 'E' => ["E+E", "E*E", "(E)","t"]}
    @start = s # 'E'
  end

  def imprime
    puts start + " => " + productions[start].sort{|x,y| y <=> x }.join(' | ')
    productions.each_pair do |a,b|
      puts "#{a} => #{b.join(' | ')}" unless a == start
    end
  end
    
  def tira_lambda
    list = []
    tamf = 1
    #Cria lista de anuláveis
    while tamf != 0
      tam1 = list.size
      each_rule_with_var do |var,rule|
        if ( rule == empty || esta_no_array?(list,rule) ) && !list.include?(var) && !tem_terminal?(rule)
          list << var
        end
      end
      tam2 = list.size
      tamf = tam1-tam2
    end

    if list.include?(start)
      flag = true
    else
      flag = false
    end

    maior = 0
    each_rule do |rule|
      maior = rule.size if maior < rule.size
    end

    1.upto(maior-1) do
      #Deleta regras que geram lambda em alguma recursão
      each_rule_with_var do |var,rule|
      rule.each_letter do |letra|
        contador = rule.count letra
        if list.include?(letra)
          if contador == 1
            productions[var] << rule.gsub(letra,'') unless productions[var].include?(rule.gsub(letra,'')) || rule.gsub(letra,'') == var
          else
            rule_temp1 = rule.sub(letra,'#')
            productions[var] << rule.sub(letra,'') unless productions[var].include?(rule.sub(letra,'')) || rule.sub(letra,'') == var
            2.upto(contador) do
              rule_temp2 = rule_temp1.sub(letra,'')
              rule_temp2 = rule_temp2.sub('#',letra)
              productions[var] << rule_temp2 unless productions[var].include?(rule_temp2) || rule_temp2 == var
              rule_temp1 = rule_temp1.sub(letra,'#')
            end
            productions[var] << rule.gsub(letra,'') unless productions[var].include?(rule.gsub(letra,'')) || rule.gsub(letra,'') == var
          end
        end
      end
    end
  end

  #Remove regras que apontam diretamente pra lambda
  each_rule_with_var do |var,rule|
    if rule == empty
          productions[var].delete(rule)
        end
    end

  #Corrige regras inexistentes
  each_rule_with_var do |var,rule|
    if rule == ''
      productions[var].delete(rule)
    end
  end

  #Acrescenta lambda na variável de partida caso necessário
  if flag
    productions[start] << empty
  end
end

  def tem_terminal?(rule)
    rule.each_letter do |letra|
      if terms.include?(letra)
        return true
      end
    end
    return false
  end

  def esta_no_array?(lista,rule)
    rule.each_letter do |letra|
      if lista.include?(letra)
        return true
      end
    end
    return false
  end

  # Simplification: Remove regra unitária
  def limpa_regra_unitaria
    each_rule_with_var do |var,rule|
      if rule.size == 1 && vars.include?(rule)
        productions[rule].each do |unitaria|
          productions[var] << unitaria unless productions[var].include?(unitaria)
        end
        productions[var].delete(rule)
        return limpa_regra_unitaria
      end
    end
  end

# Returns the next var avaliable
  def new_var
    ('A'..'Z').to_a.each do |letter|
      if !vars.include?(letter)
        vars << letter
        return letter
      end
    end
  end

  def vars_to_the_right_in_production
    each_rule do |rule|
      if rule.size >= 2
        rule.each_letter do |l|
          rule.gsub!(l, find_or_create_var_by_content(l)) if is_a_term?(l)
        end
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  def max_last_two_vars_in_productions
    each_rule do |rule|
      if rule.size >= 3
        v = find_or_create_var_by_content(rule[1, rule.size])
        rule[1, rule.size] = v
        return max_last_two_vars_in_productions
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  # TODO TEST!!!
  def each_rule
    vars.each do |var|
      productions[var].size.times do |i|
      yield productions[var][i]
      end
    end
  end

  # TODO rewrite in a Ruby way (clean code)
  # TODO TEST!!!
  def each_rule_with_var
    vars.each do |var|
      productions[var].size.times do |i|
        yield var, productions[var][i]
      end
    end
  end

  def empty
    '&'
  end

  def find_var_by_content(q)
    productions.each do |var, content|
      return var if content[0] == q or content == q
    end
    return false
  end 

  def find_or_create_var_by_content(q)
    unless v = find_var_by_content(q)
      v = new_var
      productions[v] = [q]
    end
    return v
  end

  def to_cnf
    ChomskyNormalForm.from_fcgc(self)
  end
 
  def to_gnf
    GreibachNormalForm.from_fcgg(self)
  end

  def gera_gnf
    vars.each do |var|
      aux = productions[var].size
      aux2 = 0
      0.upto(aux) do
#        if productions[var][aux2].size == 2
#          puts productions[var][aux2][0..0]
#        end
        aux2++
      end
    end
  end
  
  def is_a_var?(q)
    vars.include?(q)
  end
  
  def is_a_term?(q)
    terms.include?(q)
  end
  
  def vars
    productions.keys
  end
end

class String
  def each_letter(sep = '')
    self.split(sep).each { |l| yield l }
  end
end
