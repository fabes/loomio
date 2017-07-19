class CohortService
  def self.tag_groups
    Cohort.latest.assign!
    Cohort.ensure_current_cohort!
  end
end
