require "./yali.cr"


test_cases = [
  [:+, 1, 2] of Exp,
  [:*, 2, 3] of Exp,
  [:*, 2, [:+, 3, 4] of Exp] of Exp,
  [:*, [:+, 1, 2] of Exp, [:+, 3, 4] of Exp] of Exp,
  [[:lambda, [:x] of Exp, [:*, 2, :x] of Exp] of Exp, 3] of Exp,
  [:let, [[:x, 2] of Exp] of Exp,
    [:let, [[:f, [:lambda, [:y] of Exp, [:*, :x, :y] of Exp] of Exp] of Exp] of Exp,
      [:f, 3] of Exp] of Exp] of Exp,
  [:let, [[:x, 2] of Exp] of Exp,
    [:let, [[:f, [:lambda, [:y] of Exp, [:*, :x, :y] of Exp] of Exp] of Exp] of Exp,
      [:let, [[:x, 4] of Exp] of Exp,
        [:f, 3] of Exp] of Exp] of Exp] of Exp
]


test_cases.each do |test_case|
  puts interpreter test_case
end
