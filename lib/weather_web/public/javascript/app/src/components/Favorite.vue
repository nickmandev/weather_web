<template>
    <div id="favorite">
            <div class="col-xs-12">
            <h2 class="text-center">Favorites</h2>
            <p class="text-center">From this section of the app you can add or remove city's from Favorites,
                check for the forecast 5 days ahead.</p>
            <button type="submit" @click="getFavorites()" class="btn btn-default">GET</button>
                </div>
            <div v-show="favorites" v-for="f in favorites">
               <div class="col-xs-2">
                <h2> {{ f.weather_type }}</h2>
                <h5>{{ f.city_name }}</h5>
                <h4> {{ f.temp_min - f.temp_max }}</h4>
               </div>
            </div>

    </div>
</template>
<script>
import auth from '../auth/auth'

    export default{
        name: "favorite",
        data: function(){
                return{
                   favorites:[]
                }
        },
        methods:{
            getFavorites(){
                this.$http.post('http://localhost:9292/api/favorites', this.$store.state.current_user).then(function(data){
                    this.favorites = data.body
                }),(response) => {
                    console.log(response)
                }
            }
        }
    }
</script>
