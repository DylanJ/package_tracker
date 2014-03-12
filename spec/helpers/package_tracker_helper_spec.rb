require 'spec_helper'

describe PackageTracker::TrackerHelper do
  describe 'tracker_button' do
    it "should render modal partial" do
      helper.stub(:modal_id).and_return(1)
      helper.should_receive(:render).with('package_tracker/tracking/modal', modal_id: 1)
      helper.tracker_button()
    end
  end
end


