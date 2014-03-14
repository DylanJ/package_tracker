require 'spec_helper'

describe PackageTracker::TrackerHelper do
  describe 'tracker_button' do
    before(:each) do
      helper.stub(:modal_id).and_return(1)
      helper.should_receive(:render).with('package_tracker/tracking/modal', modal_id: 1, id: id)
    end
    context "with an argument" do
      let(:id) { '123' }
      it "should render modal partial" do
        helper.tracker_button( id )
      end
    end

    context "without an argument" do
      let(:id) { nil }
      it "should render modal partial" do
        helper.tracker_button()
      end
    end
  end
end


