Overlay: true
Navigation: Overview
SortOrder: 0

[[description]]
A ReSTful API for verifying 'life events' such as births, deaths and marriages.


Getting started
---------------

To get started using the API we recommend first experimenting with the [mock API]. All the methods described here can be called without the need to first be on-boarded.


On-boarding and authentication
------------------------------

In order for you to use the LEV API your department will need to have an agreement with us ([HMPO]). Provided you have that you will be able to follow the [technical steps to on-board and authenticate with the service].

[mock API]: ./guides/Mock
[HMPO]: https://www.gov.uk/government/organisations/hm-passport-office
[technical steps to on-board and authenticate with the service]: ./guides/Authentication


[[birth-records/description]]
Look up and search for birth records. Individual birth records can be looked up using the `systemNumber` printed in the bottom-left of the birth certificate. Alternatively, it is possible to search for birth records by supplying the date of birth, surname and at least the first forename of the child.
