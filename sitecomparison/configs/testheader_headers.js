module.exports = function (casper) {
    // load the page with the correct header overrides
    casper.open(casper.page.url, {
        method: 'get',
        headers: {
            "host":      "testcname_1234_foo_bar"
        }
    });
};
