<template>
    <div id="favorite">
        <div class="jumbotron">
            <h2 class="text-center">Favorites</h2>
            <p class="text-center">From this section of the app you can add or remove city's from Favorites,
                check for the forecast 5 days ahead.</p>
        </div>
    </div>
</template>
<script>
import auth from '../auth/auth'

    export default{
        name: "favorite",
        data: function(){
            return{
               current_user:'',
            }
        },
        methods:{

        }
    }
</script>
