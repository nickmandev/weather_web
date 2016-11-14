$(document).ready(function(){
    $('#search').addEventListener('click',function (e) {
        $('#search').css('with','100%');
        e.stopPropagation();
    });
    $(document).addEventListener('click',function (){
        $('#search').css('width','0%');
    });

});

