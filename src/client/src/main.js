require.config({
    paths: {
        jquery:"https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min"
    }
});

require(["cs!app/pictoscrawl", "jquery"], function (Pictoscrawl, $) {
   $(Pictoscrawl.setup);
});
