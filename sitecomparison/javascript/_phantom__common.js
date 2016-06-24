module.exports = function (config) {

  // modules
  var page = require('webpage').create();

  // config
  var systemArgs        = config.systemArgs,
      javascriptEnabled = config.javascriptEnabled,
      ycname            = config.ycname;


  // command line arguments
    //TODO need to clean this up in the wraith code, leaving the params in place until then
  var url = systemArgs[1],
      dimensions = require('./_getDimensions.js')(systemArgs[2]),
      image_name = systemArgs[3],
      selector   = systemArgs[4],
      globalBeforeCaptureJS = systemArgs[5],
      pathBeforeCaptureJS = systemArgs[6];

 // globalBeforeCaptureJS = globalBeforeCaptureJS === 'false' ? false : globalBeforeCaptureJS;
 // pathBeforeCaptureJS   = pathBeforeCaptureJS === 'false' ? false : pathBeforeCaptureJS;

  var current_requests = 0;
  var last_request_timeout;
  var final_timeout;

  page.viewportSize = { width: dimensions.viewportWidth, height: dimensions.viewportHeight};
  page.settings = { loadImages: true, javascriptEnabled: true };

  // If you want to use additional phantomjs commands, place them here
  page.settings.userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.17';
  //
    // page.settings.proxy('4.174.153.198','80');

    page.webSecurityEnabled = true;
  // You can place custom headers here, example below.
    page.customHeaders = {

       'Host': config.ycname

    };


    //once the page as initialized we need to clear the headers, to get the other requests
    page.onInitialized = function() {
        page.customHeaders = {};
    };



  // If you want to set a cookie, just add your details below in the following way.

  // phantom.addCookie({
  //     'name': 'ckns_policy',
  //     'value': '111',
  //     'domain': '.bbc.co.uk'
  // });
  // phantom.addCookie({
  //     'name': 'locserv',
  //     'value': '1#l1#i=6691484:n=Oxford+Circus:h=e@w1#i=8:p=London@d1#1=l:2=e:3=e:4=2@n1#r=40',
  //     'domain': '.bbc.co.uk'
  // });

  page.onResourceRequested = function(req) {
    current_requests += 1;
  };

  page.onResourceReceived = function(res) {
    if (res.stage === 'end') {
      current_requests -= 1;
      debounced_render();
    }
  };

    page.onNavigationRequested = function(url, type, willNavigate, main) {
        if (main && url!=myurl) {
            myurl = url;
            console.log("redirect caught");
            page.close();
            renderPage(url);
        }
    };

  page.open(url, function(status) {
    if (status !== 'success') {
      console.log('Error with page ' + url);
      phantom.exit();
    }
  });


  function debounced_render() {
    clearTimeout(last_request_timeout);
    clearTimeout(final_timeout);

    // If there's no more ongoing resource requests, wait for 1 second before
    // rendering, just in case the page kicks off another request
    if (current_requests < 1) {
      clearTimeout(final_timeout);
      last_request_timeout = setTimeout(function() {

     /*     if (globalBeforeCaptureJS) {
            require(globalBeforeCaptureJS)(page);
          }
          if (pathBeforeCaptureJS) {
            require(pathBeforeCaptureJS)(page);
          }*/

          console.log('Snapping ' + url + ' at: ' + dimensions.viewportWidth + 'x' + dimensions.viewportHeight);
          page.clipRect = {
            top: 0,
            left: 0,
            height: dimensions.viewportHeight,
            width: dimensions.viewportWidth
          };
          console.log("rendering an image of the page");
          page.render(image_name);
          phantom.exit();
      }, 5000);
    }

    // Sometimes, straggling requests never make it back, in which
    // case, timeout after 5 seconds and render the page anyway
    final_timeout = setTimeout(function() {

    //  if (globalBeforeCaptureJS) {
    //    require(globalBeforeCaptureJS)(page);
    //  }
    //  if (pathBeforeCaptureJS) {
     //   require(pathBeforeCaptureJS)(page);
     // }

      console.log('Snapping ' + url + ' at: ' + dimensions.viewportWidth + 'x' + dimensions.viewportHeight);
      page.clipRect = {
        top: 0,
        left: 0,
        height: dimensions.viewportHeight,
        width: dimensions.viewportWidth
      };
      page.render(image_name);
      phantom.exit();
    }, 15000);
  }

};