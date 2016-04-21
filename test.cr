require "./yali"


test_cases = [
  [:+, 1, 2] of Expression,
  [:*, 2, 3] of Expression,
  [:*, 2, [:+, 3, 4] of Expression] of Expression,
  [:*, [:+, 1, 2] of Expression, [:+, 3, 4] of Expression] of Expression,
  [[:lambda, [:x] of Expression, [:*, 2, :x] of Expression] of Expression, 3] of Expression,
  [:let, [[:x, 2] of Expression] of Expression,
    [:let, [[:f, [:lambda, [:y] of Expression, [:*, :x, :y] of Expression] of Expression] of Expression] of Expression,
      [:f, 3] of Expression] of Expression] of Expression,
  [:let, [[:x, 2] of Expression] of Expression,
    [:let, [[:f, [:lambda, [:y] of Expression, [:*, :x, :y] of Expression] of Expression] of Expression] of Expression,
      [:let, [[:x, 4] of Expression] of Expression,
        [:f, 3] of Expression] of Expression] of Expression] of Expression
]


test_cases.each do |test_case|
  puts interpreter test_case
end
