$(document).ready(function(){
    $('#panbookhome').click(function(){
        $('#panbookbody').load( "/fragments/README.html" );
    });
    $('.pblinks a').click(function(){
        $('#panbookbody').load( $(this).attr('href') );
        return false;
    });
    $('a').click(function(){
        if ( $(this).attr('href').contains('fragments/') ) {
            $('#panbookbody').load( $(this).attr('href') );
            return false;
        }
    });
});
