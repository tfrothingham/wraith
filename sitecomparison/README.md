#Site Comparison Tool

This tool is currently setup to take before and after screen shots of a given url and return a visual diff between the two
screen shots.


#Install

1. Pull down this repo
2. run `gem build yottaawraith.gemspec`
3. run `gem install yottaawraith-2.0.gem`
4. run `yottaawraith` from a terminal to get a list of options, it is recommended that the tool is run from the install directory

#Configuration

Configuration is very simple, the sites/pages that you want to compare are list out in a csv file.
* There is **NO** header row.

There are two required columns for the list of sites:
* Logical Name
  * This is a logical name for the site, something easily readable.
* Site Home page
  * The front of the site that you are testing, this is required as any other child pages are based off of this value


## Examples

```
     ClarksUSA,https://www.clarksusa.com,/eng/categories/mens/hard-to-find-sizes-widths,/eng/product/slone/26082470
     MooseJaw,http://www.moosejaw.com,/moosejaw/shop/navigation__Clothing_____,/moosejaw/shop/product_Prana-Mens-Crew-Tee_10253641_10208_10000001_-1_
```

#What's going on?

This tool is a wrapper around a gem called wraith.  Wraith makes use of phantomjs and imagemagik to take screen shots of
a given set of web pages and compare the results to see the visual differences.  In order to run against a site, you had to
create a yaml file for each site and provide specific information depending on the type of run that you were looking to perform.
This wrapper does away with the manual config through yaml files and creates them automatically with the information that
is provided for all intended sites.
This wrapper also detects the number of sites and iterates through them until complete as opposed to run the tool once per site.

There will be more updates coming, as a current limitation is the the auto configuration creates yaml files specifically for before and after
shots of the sites.  There will be a variant coming that would be able to compare two live sites with each other (say Feature and Staging).

#Results

The output is tucked into the working directory in the UICompare directory.  Under this directory you will find sub-directories
call archive, current and historical (these are created as needed).
* Archive
  * Previous run are stored here, they are sorted into sub-directories by date.
* Current
  * The core of what you will be looking for, this is the results from the most recent comparison
  * The sub-directories are list by the site logical name, directly under that directory is an gallery.html file that will
   present the visual results from the run. In other words, open this file in a browser.
* History
  * Similar to the Current folder, except there are no results.  These are your baseline screen captures.
