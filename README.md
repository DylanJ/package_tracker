# Package Tracker

This is a fairly simple project which piggy backs off of active_shipping to look up FedEx and DHL tracking information. It gives you the helper `tracker_button` which adds a button wherever it is called that once clicked opens a modal which if called with a tracking ID as the argument will be populated with the tracking information. If no argument is given the user is presented with a form which will fetch tracking information in the background and present it in the modal.

## Dependencies

package_tracker assumes you have both jQuery and bootstrap(css & javascript) loaded into your application.

## Installation

1. rake package_tracker:install ( doesn't actually exist atm ) [TODO]
2. load package_tracker/package_tracker javascript somewhere on your page

## Config

Once installed there should be a file called package_tracker.yml in your applications config directory. Fill in your credentials there.

## TODO
1. Support DHL ( implement relevant portion in active_shipping )
2. Write installation script
3. Clean up code a wee bit

