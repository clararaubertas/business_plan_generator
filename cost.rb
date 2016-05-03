class Cost
  attr_accessor :time_unit
  attr_accessor :n
  attr_accessor :name
  attr_accessor :description
  
  def format_string
    bold("Spending #{cf(self.n)}") + bold(" on #{self.name} each #{self.time_unit.to_s.gsub('_', ' ')}") +
    "\n   #{self.description}"
  end

  def initialize(params)
    self.n = params[:n]
    self.time_unit = params[:time_unit]
    self.name = params[:name]
    self.description = params[:description]
    self.time_unit ||= :month
  end
end
