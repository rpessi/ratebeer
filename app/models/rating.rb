class Rating < ApplicationRecord
  belongs_to :beer

  def print_report
    report = []
    report << "#{beer.name} "
    report << "#{score}"
    report.join("")
  end

  def to_s
    "tekstiesitys"
  end
end
