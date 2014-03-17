require 'spec_helper'

describe PackageTracker::Tracker do
  subject { PackageTracker::Tracker.lookup(id) }

  describe 'FedEx' do
    context 'with tracking number that exists' do
      let(:id) { '1010095742170014832400578986691756' }
      it { should == {
        carrier: "FedEx Express",
        events: [
          {date: "2014-01-17 11:30:00", location: "OSASCO BR", status: "Delivered"},
          {date: "2014-01-17 10:11:00", location: "SAO PAULO BR", status: "On FedEx vehicle for delivery"},
          {date: "2014-01-17 06:47:00", location: "SAO PAULO BR", status: "At local FedEx facility"},
          {date: "2014-01-16 22:44:00", location: "CAMPINAS BR", status: "In transit"},
          {date: "2014-01-16 22:05:00", location: "CAMPINAS BR", status: "International shipment release - Import"},
          {date: "2014-01-16 20:02:00", location: "CAMPINAS BR", status: "In transit"},
          {date: "2014-01-16 19:16:00", location: "CAMPINAS BR", status: "In transit"},
          {date: "2014-01-16 16:34:00", location: "CAMPINAS BR", status: "At destination sort facility"},
          {date: "2014-01-16 17:50:00", location: "GROSSBEEREN DE", status: "Left FedEx origin facility"},
          {date: "2014-01-16 03:47:00", location: "MEMPHIS, TN", status: "Departed FedEx location"},
          {date: "2014-01-16 02:08:00", location: "MEMPHIS, TN", status: "In transit"},
          {date: "2014-01-16 02:08:00", location: "MEMPHIS, TN", status: "In transit"},
          {date: "2014-01-16 02:08:00", location: "MEMPHIS, TN", status: "In transit"},
          {date: "2014-01-16 00:01:00", location: "MEMPHIS, TN", status: "Arrived at FedEx location"},
          {date: "2014-01-15 23:00:00", location: "KOELN DE", status: "In transit"},
          {date: "2014-01-15 21:16:00", location: "KOELN DE", status: "Departed FedEx location"},
          {date: "2014-01-15 07:54:00", location: "KOELN DE", status: "At local FedEx facility"},
          {date: "2014-01-15 04:38:00", location: "KOELN DE", status: "In transit"},
          {date: "2014-01-15 03:07:00", location: "KOELN DE", status: "Arrived at FedEx location"},
          {date: "2014-01-14 19:05:00", location: "GROSSBEEREN DE", status: "Left FedEx origin facility"},
          {date: "2014-01-14 17:08:00", location: "GROSSBEEREN DE", status: "Picked up"},
          {date: "2014-01-14 07:30:26", location: "", status: "Shipment information sent to FedEx"}
        ],
        response: "success",
        status: "Delivered: 1/17/2014 11:30 am Signed for by:H.SANTOS; OSASCO, BR"
      } }
    end

    context 'with tracking number that does not exist' do
      let(:id) { '2012095742170825100801578286691723' }
      it { should == { response: 'failure', message: 'No information for the following shipments has been received by our system yet.  Please try again or contact Customer Service at 1.800.Go.FedEx(R) 800.463.3339.' } }
    end
  end

  describe 'DHL' do
    context 'with tracking number that exists' do
      let(:id) { '054655197259' }
      it { should == {
        carrier: "DHL",
        events: [
          {date: "Wed, 15.01.2014 20:19 h", location: "Köngen", status: "The shipment has been processed in the parcel center of origin"},
          {date: "Thu, 16.01.2014 00:20 h", location: "--", status: "The instruction data for this shipment have been provided by the sender to DHL electronically"},
          {date: "Thu, 16.01.2014 04:22 h", location: "Greven", status: "The shipment has been processed in the destination parcel center"},
          {date: "Thu, 16.01.2014 07:14 h", location: "Osnabrück", status: "The shipment has been loaded onto the delivery vehicle"},
          {date: "Thu, 16.01.2014 09:24 h", location: "--", status: "The shipment has been successfully delivered"}
        ],
        response: "success",
        status: "The shipment has been successfully delivered"
      } }
    end

    context 'with tracking number that does not exist' do
      let(:id) { '123456789012' }
      it { should == { response: 'failure', message: 'No such tracking ID' } }
    end
  end

  context "invalid id" do
    let(:id) { 'ABC' }
    it { should == { response: 'failure', message: 'Invalid tracking ID' } }
  end
end
