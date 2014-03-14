require 'spec_helper'

describe PackageTracker::TrackerHelper do
  describe 'tracker_button' do
    context "with an argument" do
      let(:id) { '123' }
      it "should render modal partial" do
        helper.should_receive(:render).with('package_tracker/tracking/results', id: id)
        helper.track_shipment( id )
      end
    end

    context "without an argument" do
      it "should render modal partial" do
        helper.stub(:modal_id).and_return(1)
        helper.should_receive(:render).with('package_tracker/tracking/modal', modal_id: 1)
        helper.track_shipment()
      end
    end
  end
end


