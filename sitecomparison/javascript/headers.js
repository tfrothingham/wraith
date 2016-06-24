module.exports = function (casper, cname) {
    // load the page with the correct header overrides
    casper.open(casper.page.url, {
        method: 'get',
        headers: {
            "Host": cname
        }
    });
};