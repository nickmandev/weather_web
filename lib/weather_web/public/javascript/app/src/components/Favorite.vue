<template>
    <div id="favorite" class="container-fluid">
        <div class="jumbotron">
            <h2 class="text-center">Favorites</h2>
            <p class="text-center">From this section of the app you can add or remove city's from Favorites.</p>
            <p class="text-center">Check the weather for specific city, check 5 day-forecast for your Favorites.</p>
        </div>
        <div class="panel panel-default well" v-show="this.$store.state.favorites">
            <div class="panel-heading">Favorites</div>
            <ul class="list-group">
                <li class="list-group-item clearfix" v-for="fav in this.$store.state.favorites">
                    {{fav.name}} <button class="glyphicon glyphicon-remove" type="submit" v-model="this.favId = fav.city_id" @click="removeFavorite"></button>
                </li>
            </ul>
        </div>
        <div class="row">
            <favoriteItem></favoriteItem>
        </div>
    </div>
</template>
<script>
import auth from '../auth/auth'
import FavoriteItem from '../components/FavoriteItem.vue'
    export default{
        name: "favorite",
        data: function(){
                return{
                    clicked: false,
                    favId: ''
                }
        },
        components:{
            "favoriteItem": FavoriteItem
        },
        methods: {
            removeFavorite(){
            console.log(this.favId)
            }
        }

    }
</script>
