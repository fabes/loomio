require 'rails_helper'

describe Cohort do
  describe '.ensure_current!' do
    let(:past_cohort) { create :cohort, start_on: 3.weeks.ago, end_on: 1.week.ago }
    let(:current_cohort) { create :cohort, start_on: 1.week.ago, end_on: 1.week.from_now }

    it 'returns an existing cohort if one is present' do
      current_cohort
      expect(Cohort.ensure_current!).to eq current_cohort
    end

    it 'creates a new cohort starting at the end of the last on if one is not present' do
      past_cohort
      expect { Cohort.ensure_current! }.to change { Cohort.count }.by(1)
      cohort = Cohort.last
      expect(cohort.start_on).to eq 1.week.ago.to_date
      expect(cohort.end_on).to eq 1.week.from_now.to_date
    end

    it 'creates a new cohort starting today if no cohorts exist' do
      expect { Cohort.ensure_current! }.to change { Cohort.count }.by(1)
      cohort = Cohort.last
      expect(cohort.start_on).to eq 0.weeks.from_now.to_date
      expect(cohort.end_on).to eq 2.weeks.from_now.to_date
    end
  end
end
