<template>
    <div>
        <div v-for="city in oneCity">
            <div class="row well">
                <div class="col-xs-3"> <h2> {{ city.name }}  </h2></div>
                <div class="col-xs-3"><h3> {{ city.weather_type }}</h3></div>
                <div class="col-xs-3">
                    <span><object id="svg-icon"  type="image/svg+xml" :data="city.icon"></object></span>
                </div>
                <div class="col-xs-2"><h3> {{ city.temp }}° </h3></div>
                <div class="col-xs-1"><span class="glyphicon glyphicon-remove" @click="close"></span></div>
            </div>
        </div>
        <div class="well" v-if="multipleCitys.length > 1">
            <div>
                <h4>Select city:</h4>
            </div>
            <ul class="list-group">
                <li class="list-group-item" v-for="city in multipleCitys">
                    <h5>
                        City: {{ city.city_name }}, Country: {{ city.country }}
                        <button class="btn btn-default btn-xs pull-right"  @click="oneCityForecast(city.city_id)">
                            Weather
                        </button>
                    </h5>
                </li>
            </ul>
        </div>
    </div>
</template>
<style>
#svg-icon{
  width: 20%;
  height: 10%;
}
</style>
<script>
    export default{
        name:'search',
        data: function(){
            return{
                oneCity: [],
                multipleCitys: [],
                show: '',
            }
        },
        methods:{
            close(){
                this.oneCity = []
            },
            oneCityForecast: function(city_id){
                var param = city_id
                this.$http.get('http://localhost:9292/api/multiple_results',{params:{'city_id': param}}).then(function(data){
                    var parsed = JSON.parse(data.body)
                    this.oneCity = parsed
                    this.multipleCitys = []
                }),(response)=>{
                    console.log('Fail')
                }
            }
        },
        computed:{
            test(){
                return this.$store.getters.getCityName
            }
        },
        watch:{
            test: function(){
                var param = this.$store.state.cityName
                console.log(param)
                this.$http.get('http://localhost:9292/api/result', {params:{'city_name': this.$store.state.cityName}}).then(function(data){
                    var parsed = JSON.parse(data.body)
                    if(parsed.result){
                    this.oneCity = parsed
                    }else{
                    this.multipleCitys = parsed['multiple_results']
                    }
                }),(response)=>{
                    console.log('Fail')
                }
                }
            }


    }
</script>
