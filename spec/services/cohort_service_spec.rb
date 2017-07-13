require 'rails_helper'

describe CohortService do
  context "tag_groups" do
    let!(:other_group) { FactoryGirl.create :group, created_at: 1.month.ago }
    let!(:group) { FactoryGirl.create :group }
    let(:cohort) { Cohort.create start_on: 1.week.ago.to_date, end_on: 1.week.from_now.to_date }

    it "tags all groups in the cohort timeframe with the cohort id" do
      cohort
      CohortService.tag_groups
      expect(group.reload.cohort).to eq cohort
      expect(other_group.cohort).to eq nil
    end

    it 'creates a current cohort if one does not exist' do
      expect { CohortService.tag_groups }.to change { Cohort.count }.by(1)
    end
  end
end
