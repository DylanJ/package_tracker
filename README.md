# Package Tracker

This is a fairly simple project which scrapes tracking information for both DHL and FedEx and spits the info out into a modal. It gives you the helper method `tracker_button` which adds a button wherever it is called that once clicked opens a modal which will automatucally fetch the tracking info if a tracking id is specified. If no tracking ID is specified you can enter a tracking ID in the modal and it will be fetched once the user clicks 'Track Shipment'.

## Dependencies

package_tracker assumes you have both jQuery and bootstrap(css & javascript) loaded into your application.

## Installation

add `gem 'package_tracker'` to your gemfile.

