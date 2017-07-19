class Cohort < ActiveRecord::Base
  has_many :groups
  has_many :parent_groups, -> { parents_only }, class_name: "Group"

  def assign!
    Group.within(start_on, end_on).update_all(cohort: self)
  end

  def self.latest
    order(end_on: :desc).first
  end

  def self.ensure_current!
    last_end_on = latest&.end_on || Date.today
    if last_end_on > Date.today
      latest
    else
      create(start_on: last_end_on, end_on: last_end_on + 2.weeks.ago)
    end
  end
end
