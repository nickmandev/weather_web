<template>
    <div id="favorite-item" class="container-fluid">
        <div class="col-xs-2 well" v-for="f in favorites" id="weather-box" v-if="show">
            <h4 class="text-center">{{ f.date }}</h4>
            <h3 class="text-center">{{ f.day }}</h3>
            <div class="row">
                <div class="col-xs-6">
                    <h4 >{{ f.city_name}}</h4>
                    <h4 >{{f.weather_type}}</h4>
                    <h5 > {{f.temp_min}}°/{{ f.temp_max}}°</h5>
                </div>
                <div class="col-xs-2">
                    <span><object id="svg-icon" type="image/svg+xml" :data="f.icon"></object></span>
                </div>
            </div>
        </div>
        <button type="submit" @click="getFavorites" class="btn btn-default" v-if="!hide">Show Favorites</button>
        <button type="submit" @click="hideFavorites" class="btn btn-default" v-if="hide">Hide Favorites</button>
    </div>
</template>
<style>
    #weather-box{
        margin-left: 40px;
    }
</style>
<script>
 export default{
    name: "favorite-item",
    props: ['clicked'],
    data: function(){
        return{
            favorites:[],
            hide: false,
            show: true
        }
    },
    computed:{
        ifClicked(){
            console.log(this.click)
            return this.click = this.clicked
            if(this.click == true){
                console.log("True")
                this.getFavorites()
            }else{
                console.log("False")
            }
        }
    },
    methods:{
        getFavorites(){
            this.$http.post('http://localhost:9292/api/favorites', this.$store.state.current_user).then(function(data){
                this.favorites = data.body
                this.hide = true
                this.show = true
                console.log(this.click)
            }),(response) => {
                console.log(response)
            }
        },
        hideFavorites(){
            this.show = false
            this.hide = false
        }
    },


 }
</script>
