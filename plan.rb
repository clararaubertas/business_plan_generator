#!/usr/bin/ruby
require 'term/ansicolor'
include Term::ANSIColor
load 'cost.rb'


#-------Fill out this section with your own business info.

@business_name = "COOL BUSINESS IDEA"
@business_description = "COOL BUSINESS IDEA is going to make money by selling some things to customers, hopefully for more money than it costs us to make/buy the things."
@target_market = "We expect to be able to find customers for our product in ways that would be listed here if this weren't just dummy info."

@descriptions = {}

@unit_price = 20
@descriptions[:unit_price] = "This is the retail cost of each unit."

@margin = 55
@descriptions[:margin] =
  "This is how much we will mark up each unit from what we paid."

@units_per_day = 20
@descriptions[:units_per_day] = "This is how many units we expect to sell."


@costs =
  [
  # list all expected costs as formatted below
  # these do *not* include costs of goods sold
  # these are fixed monthly costs and per-business-day costs
  # the default is that a cost is per month
  # set :time_unit to :business_day for a per-business-day cost
  Cost.new(:name => 'rent', :n => 1000, :description => "Everyone's gotta be somewhere."
),
   Cost.new(:name => 'salary', :n => 2000, :description =>
            "Gotta get paid!"),
   Cost.new(:name => 'worker', :n => 100, :time_unit => :business_day, :description => 
            "$100 estimate based on 8 hours of labor at $10/hr
   plus some overhead"),
   Cost.new(:name => 'miscellaneous', :n => 1000, :description => 
            "There's always miscellaneous. 
   ")
  ]


#----------You do not need to edit this section.

def monthly_profit(units)
  ((@unit_price * @margin/100) * units) -
    monthly_operating_cost(units)
end

def monthly_operating_cost(units)
  fixed_costs = @costs.select {|c| c.time_unit == :month }
  variable_costs = @costs.select { |c| c.time_unit == :business_day }
  fixed_costs.map(&:n).reduce(:+) + 
    (variable_costs.map(&:n).reduce(:+) * (units / @units_per_day))
end

def break_even_point(units = 1, max = 5000)
  if monthly_profit(units) > 0
    return units.to_i
  elsif units > max
    return 0
  else
    return break_even_point(units + 1, max)
  end
end

def cf(string)
  return "$#{string.to_s}".blue
end

def formatted_plan
  if break_even_point == 0
    puts red("#{@business_name} will never be profitable with the numbers you have used.")
  else
    puts "--------------"
    puts white(on_black(bold("#{@business_name}")))
    puts @business_description
    puts ""
    puts white(on_black(bold("CUSTOMERS")))
    puts @target_market
    puts ""
    puts white(on_black(bold("COST BREAKDOWN:")))
    puts bold("Selling each unit to the consumer for #{cf(@unit_price)}")
    puts "   #{@descriptions[:unit_price]}"
    puts "Having an average margin of #{blue(@margin.to_s + "%")}".bold + " on unit contents".bold
    puts "   #{@descriptions[:margin]}"
    puts "Selling #{@units_per_day.to_s.blue} ".bold + "units on each business day".bold
    puts "   #{@descriptions[:units_per_day]}\n"
    @costs.each { |cost| puts cost.format_string }
    puts ""
    puts white(on_black(bold("MONTHLY OPERATING COST:")))
    puts " to break even: $#{monthly_operating_cost(break_even_point)}"
    puts ""
    puts white(on_black(bold("BREAK-EVEN POINT:")))
    puts "  #{blue(break_even_point.to_s)} units monthly (#{blue((break_even_point / 4).to_s)} each week)"
  end
end

puts formatted_plan

