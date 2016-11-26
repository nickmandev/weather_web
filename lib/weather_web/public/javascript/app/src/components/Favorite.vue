<template>
    <div id="favorite" class="container-fluid">
        <div class="jumbotron">
            <h2 class="text-center">Favorites</h2>
            <p class="text-center">From this section of the app you can add or remove city's from Favorites.</p>
            <p class="text-center">Check the weather for specific city, check 5 day-forecast for your Favorites.</p>
        </div>
        <!-- Panel to manage Favorites -->
        <div>
            <manageFavorites></manageFavorites>
        </div>
        <!-- Foreacst for Favorites  -->
        <div class="row">
            <favoriteItem></favoriteItem>
        </div>
    </div>
</template>
<script>
import auth from '../auth/auth'
import FavoriteItem from '../components/FavoriteItem.vue'
import ManageFavorites from '../components/ManageFavorites.vue'
export default{
    name: "favorite",
    props: ['cityName'],
    data: function(){
            return{
                clicked: false,
            }
    },
    components:{
        "favoriteItem": FavoriteItem,
        "manageFavorites": ManageFavorites
    },

    methods:{

    }

}
</script>
