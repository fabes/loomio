class Cohort < ActiveRecord::Base
  has_many :groups

  def assign!
    Group.within(start_on, end_on).update_all(cohort: self)
  end

  def self.latest
    order(end_on: :desc).first
  end

  def self.present_cohort(today = Date.today)
    latest_cohort = latest || Cohort.new(end_on: today)
    if latest_cohort.end_on > today
      latest_cohort
    else
      create(start_on: latest_cohort.end_on, end_on: latest_cohort.end_on + 2.weeks)
    end
  end
end
