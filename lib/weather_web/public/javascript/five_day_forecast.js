$(document).ready(function(){
    var div =  $("<div></div>").addClass("col-xs-1");
    var city_name = $("<h2></h2>").addClass("text-center");
    var temp = $("<h3></h3>").addClass("text-center");
    var icon = $("<object></object>");

    $.ajax({
        type: "GET",
        dataType: "text",
        url: 'http://localhost:9292/favorites/json',
        success: function(Weather_data){
            ProcessData(Weather_data);
        }
    });

    function ProcessData(weather_data) {
        var data = JSON.parse(weather_data);
            for(var i = 0;i<data.length;i++){
                var weather = "" + data[i]['weather_type'] + " " + data[i]['temp'] + "°";
                $("#five_day_container").append($("<div></div>")
                    .addClass("col-xs-2 five_day_box")
                    .append($("<h6></h6>")
                        .append($("<object></object>")
                        .attr({type: "image/svg+xml", data: data[i]["icon"]}))
                        .addClass('text-center'))
                    .append($("<h2></h2>")
                        .addClass('text-center')
                        .text(data[i]['city_name']))
                    .append($("<h4></h4>")
                        .addClass('text-center')
                        .text(weather))
                    .append($("<h5></h5>")
                        .addClass('text-center')
                        .text(data[i]['date']))

                )
            }
    }
});


