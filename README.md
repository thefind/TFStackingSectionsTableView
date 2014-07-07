TFStackingSectionsTableView
===========================

* Keep all of your table section headers on the screen
* Tap a header to bring a section into view

![screenshot](https://raw.githubusercontent.com/thefind/TFStackingSectionsTableView/master/Screenshots/video.gif)

In a regular table view, only the current section header is pinned to the top.
TFStackingSectionsTableView keeps all the section headers on screen, stacked
at the top and bottom of the table. You can then tap a section header to bring
that section into view.

## Installation

We recommend using CocoaPods to install TFStackingSectionsTableView. Add to your Podfile:

    pod 'TFStackingSectionsTableView'

To install manually, add TFStackingSectionsTableView to your project as a subproject, and
then add the TFStackingSectionsTableView static library in your project's Build Phases.

## Usage

In Interface Builder, set the class of your table view to `TFStackingSectionsTableView`. In code create an instance of `TFStackingSectionsTableView`. See the Demo for sample code.

