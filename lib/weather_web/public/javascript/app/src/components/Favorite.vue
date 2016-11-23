<template>
    <div id="favorite" class="container-fluid">
        <div class="well">
            <h2 class="text-center">Favorites</h2>
            <p class="text-center">From this section of the app you can add or remove city's from Favorites,
                check for the forecast 5 days ahead.</p>
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
                    clicked: false
                }
        },
        components:{
            "favoriteItem": FavoriteItem
        },
        methods: {
            getFavorites(){
            console.log("getFavorites")
               return this.clicked = true
            }
        }

    }
</script>
