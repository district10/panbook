function panbookinit() {
    $('#panbookhome').click(function(){
        $('#panbookbody').load( "/fragments/README.html", panbookinit );
    });
    $('.pblinks a, ul.pblinks li a').click(function(){
        $('#panbookbody').load( $(this).attr('href'), panbookinit );
        return false;
    });
    $('a').click(function(){
        if ( $(this).attr('href').contains('fragments/') ) {
            $('#panbookbody').load( $(this).attr('href'), panbookinit );
            return false;
        }
    });
}

$(document).ready(function(){
    panbookinit();
});
