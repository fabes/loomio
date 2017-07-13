class CohortService
  def self.tag_groups
    Cohort.next_to_latest.assign!
    Cohort.latest&.assign!
    cohort = Cohort.latest
    Group.within(cohort.start_on, cohort.end_on).update_all(cohort: cohort)
    Cohort.ensure_present!
  end
end
