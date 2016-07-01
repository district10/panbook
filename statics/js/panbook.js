function panbookinit() {
    $('#panbookhome').click(function(){
        $('#panbookbody-github').load( "/fragments/README.html", panbookinit );
        $('#panbookbody-native').load( "/fragments/README.html", panbookinit );
    });
    $('.pblinks a, ul.pblinks li a').click(function(){
        $('#panbookbody-github').load( $(this).attr('href'), panbookinit );
        $('#panbookbody-native').load( $(this).attr('href'), panbookinit );
        return false;
    });
    $('a').click(function(){
        if ( $(this).attr('href').contains('fragments/') ) {
            $('#panbookbody-github').load( $(this).attr('href'), panbookinit );
            $('#panbookbody-native').load( $(this).attr('href'), panbookinit );
            return false;
        }
    });
}

$(function(){
    panbookinit();
    $("#tabNav ul").idTabs("tab1");
    $(".diagram").sequenceDiagram({theme: 'hand'});
     var diagram = flowchart.parse('st=>start: Start:>http://www.google.com[blank]\n' +
                                    'e=>end:>http://www.google.com\n' +
                                    'op1=>operation: My Operation\n' +
                                    'sub1=>subroutine: My Subroutine\n' +
                                    'cond=>condition: Yes \n' +
                                    'or No?\n:>http://www.google.com' +
                                    'io=>inputoutput|request: catch something...\n' +
                                    '' +
                                    'st->op1->cond\n' +
                                    'cond(yes)->io->e\n' + // conditions can also be redirected like cond(yes, bottom) or cond(yes, right)
                                    'cond(no)->sub1(right)->op1');// the other symbols too...
      diagram.drawSVG('diagram');
});
