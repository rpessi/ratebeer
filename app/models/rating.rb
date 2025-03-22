class Rating < ApplicationRecord
  belongs_to :beer

  def print_report
    # report = []
    # report << "#{beer.name} "
    # report << "#{score}"
    # report.join("")
    return "#{beer.name} #{score}"
  end

  def to_s
    return "#{beer.name} #{score}"
  end
end
